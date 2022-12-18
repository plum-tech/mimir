import traceback
from io import StringIO
from typing import Iterable, runtime_checkable, Protocol, Iterator, Any, Callable

import fuzzy
import strings
from args import Args, Arg, split_multicmd
from project import Proj
from style import Style
from ui import Terminal

_default_style = Style()

max_ctx_depth = 64


class CmdContext:
    def __init__(
            self, proj: Proj, terminal: Terminal, cmdlist: "CommandList",
            args: Args = None, style: Style = _default_style):
        self.proj = proj
        self.term = terminal
        self.cmdlist = cmdlist
        self.args = args
        self.style = style
        self.depth = 0

    @property
    def is_cli(self) -> bool:
        return self.args is not None

    def __str__(self):
        return f"{self.proj},{self.args}"

    def __repr__(self):
        return str(self)

    def __copy__(self) -> "CmdContext":
        return CmdContext(self.proj, self.term, self.cmdlist, self.args)

    def copy(self, **kwargs) -> "CmdContext":
        """
        return a recursion-aware copy
        """
        cloned = self.__copy__()
        for k, v in kwargs.items():
            setattr(cloned, k, v)
        cloned.depth = self.depth + 1
        return cloned


@runtime_checkable
class CommandLike(Protocol):
    """
    optional:
    - created_by_user: bool -- whether this command is created by user, [False] as default.
    """
    name: str
    """the name of command"""

    def execute_cli(self, ctx: CmdContext):
        """execute the command in cli mode"""
        pass

    def execute_interactive(self, ctx: CmdContext) -> Iterator:
        """execute the command in interactive mode. return an Iterator as a coroutine"""
        pass

    def help(self, ctx: CmdContext):
        """help info of command"""
        pass


# noinspection SpellCheckingInspection
class CommandList:
    name2cmd: dict[str, CommandLike]

    def __init__(self, logger=None):
        self.name2cmd = {}
        self.builtins = set()
        self.logger = logger

    def log(self, *args):
        if self.logger is not None:
            self.logger.log(*args)

    def add_cmd(self, name: str, cmd: CommandLike):
        name = name.lower()
        if name in self.name2cmd:
            raise Exception(f"{name} command has already registered")
        self.log(f"command<{name}> loaded.")
        self.name2cmd[name] = cmd

    def is_builtin(self, name: str) -> bool:
        return name in self.builtins

    def __setitem__(self, key: str, cmd: CommandLike):
        self.add_cmd(key, cmd)

    def __getitem__(self, name: str) -> CommandLike | None:
        if name not in self.name2cmd:
            return None
        else:
            return self.name2cmd[name]

    def add(self, cmd: CommandLike | Any):
        self.add_cmd(cmd.name, cmd)

    def __lshift__(self, cmd: CommandLike | Any):
        self.add(cmd)

    @property
    def size(self):
        return len(self.name2cmd)

    @property
    def isempty(self):
        return self.size > 0

    def __contains__(self, name: str) -> bool:
        return name in self.name2cmd

    def __iter__(self):
        return iter(self.name2cmd.items())

    def keys(self):
        return iter(self.name2cmd.keys())

    def values(self):
        return iter(self.name2cmd.values())

    def items(self):
        return iter(self.name2cmd.items())

    def fuzzy_match(self, name: str, threshold: float) -> CommandLike | None:
        candidate, radio = fuzzy.match(name, self.name2cmd.keys())
        if radio < threshold:
            return None
        else:
            return self.name2cmd[candidate]

    def __str__(self):
        return f"[{', '.join(self.name2cmd.keys())}]"

    def __repr__(self):
        return str(self)

    def __len__(self) -> int:
        return self.size

    def browse_by_page(self, cmd_per_page: int) -> Iterable[tuple[int, Iterable[CommandLike]]]:
        cur = []
        for i, cmd in enumerate(self.name2cmd.values()):
            if i % cmd_per_page == 0 and i != 0:
                yield i // cmd_per_page, cur
                cur.clear()
            else:
                cur.append(cmd)
        if len(cur) > 0:
            yield (self.size - 1) // cmd_per_page, cur

    def calc_total_page(self, cmd_per_page: int) -> int:
        return self.size // cmd_per_page


class CommandArgError(Exception):
    def __init__(self, cmd: CommandLike | Any, arg: Arg | None, *more):
        super(CommandArgError, self).__init__(*more)
        self.arg = arg
        self.cmd = cmd


class CommandEmptyArgsError(Exception):
    def __init__(self, cmd: CommandLike | Any, cmdargs: Args, *more):
        super(CommandEmptyArgsError, self).__init__(*more)
        self.cmdargs = cmdargs
        self.cmd = cmd


class CommandExecuteError(Exception):
    def __init__(self, cmd: CommandLike | Any, *args):
        super(CommandExecuteError, self).__init__(*args)
        self.cmd = cmd


def print_cmdarg_error(ctx: CmdContext, e: CommandArgError):
    index = e.arg.raw_index
    full, pos = e.arg.root.located_full(index)
    t = ctx.term
    _er0 = ctx.style.error('×')
    _er1 = ctx.style.error('│')
    _er2 = ctx.style.error('╰─>')

    t.both << f"{_er0} {full[:pos.start]}{ctx.style.highlight(full[pos.start:pos.end])}{full[pos.end:]}"
    with StringIO() as s:
        s.write(_er1)
        s.write(" ")
        s.write(strings.repeat(pos.start))
        s.write(ctx.style.arrow(strings.repeat(pos.end - pos.start, "^")))
        t.both << s.getvalue()
    t.both << ctx.style.error(f'╰─> {type(e).__name__}: {e}')


def print_cmdargs_empty_error(ctx: CmdContext, e: CommandEmptyArgsError):
    full = e.cmdargs.root.full()
    t = ctx.term
    _er0 = ctx.style.error('×')
    _er1 = ctx.style.error('│')
    _er2 = ctx.style.error('╰─>')

    _arrow = ctx.style.arrow("^")

    t.both << f"{_er0} {full}"
    with StringIO() as s:
        s.write(strings.repeat(len(full)))
        s.write(_arrow)
        t.both << f"{_er1} {s.getvalue()}"
    t.both << ctx.style.error(f'╰─> {type(e).__name__}: {e}')


class CommandDelegate(CommandLike):
    created_by_user = True

    def __init__(self, name: str, fullargs: str, helpinfo: str):
        self.name = name
        self.fullargs = fullargs
        self.helpinfo = helpinfo

    def execute(self, ctx: CmdContext):
        if ctx.depth >= max_ctx_depth:
            raise CommandExecuteError(self, "recursive executing detected")
        args = Args.by(full=self.fullargs)
        all_cmdargs = split_multicmd(args)
        # prepare commands to run
        exe_args = []
        # check if all of them are executable
        for command, args in (args.poll() for args in all_cmdargs):
            cmdname = command.full
            executable = ctx.cmdlist[cmdname]
            if executable is None:
                raise CommandArgError(self, command, f"command not found")
            exe_args.append((executable, args))
        for i, pair in enumerate(exe_args):
            executable, args = pair
            subctx = ctx.copy(args=args)
            executable.execute_cli(subctx)

    def execute_cli(self, ctx: CmdContext):
        self.execute(ctx)

    def execute_interactive(self, ctx: CmdContext) -> Iterator:
        self.execute(ctx)
        yield

    def help(self, ctx: CmdContext):
        for line in self.helpinfo.splitlines():
            ctx.term << line


def log_traceback(t: Terminal):
    if t.has_logger:
        t.logging << traceback.format_exc()
        t << "ℹ️ full traceback was printed into log."


def catch_executing(
        ctx: CmdContext,
        executing: Callable[[], Any]
) -> Any:
    try:
        return executing()
    except CommandArgError as e:
        print_cmdarg_error(ctx, e)
        log_traceback(ctx.term)
    except CommandEmptyArgsError as e:
        print_cmdargs_empty_error(ctx, e)
        log_traceback(ctx.term)
    except CommandExecuteError as e:
        ctx.term.both << ctx.style.error(f"{type(e).__name__}: {e}")
        log_traceback(ctx.term)
