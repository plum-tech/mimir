from typing import Iterable

import project
from args import group_args, Args
from build import input_multiline, yes_no, await_input
from cmd import CmdContext, CommandEmptyArgsError, CommandArgError
from project import ExtraCommandEntry, ExtraCommandsConf
from utils import Ref, useRef


def _get_arg(grouped: dict[str | None, list[Args]], argname: str, allow_empty=False) -> str | None:
    if argname not in grouped and allow_empty:
        return None
    n_argslist = grouped[argname]
    if len(n_argslist) > 1:
        raise CommandArgError(AliasCmd, n_argslist[1][0], f"redundant arg<{argname}> provided")
    n_args = n_argslist[0]
    if n_args.size == 0:
        if allow_empty:
            return None
        raise CommandEmptyArgsError(AliasCmd, n_args, f"arg<{argname}> is empty")
    elif n_args.size == 1:
        n_arg = n_args[0]
        return n_arg.full
    else:
        return n_args.full()


class AliasCmd:
    name = "alias"

    @staticmethod
    def add_cmd(conf: ExtraCommandsConf, name: str, fullargs: str, helpinfo: str):
        entry = ExtraCommandEntry(name=name, fullargs=fullargs, helpinfo=helpinfo)
        conf[name] = entry

    @staticmethod
    def execute_cli(ctx: CmdContext):
        if ctx.args.isempty:
            raise CommandEmptyArgsError(AliasCmd, ctx.args, "no command name given")
        t = ctx.term
        grouped = group_args(ctx.args)
        ungrouped_args = grouped[None][0]
        if not ungrouped_args.isempty:
            alias_arg = ungrouped_args[0]
            if not alias_arg.ispair:
                raise CommandArgError(AliasCmd, alias_arg, 'plz match <cmd_name="full args"> format')
            else:
                name = alias_arg.key
                args = alias_arg.value
        else:
            name = _get_arg(grouped, argname="n", allow_empty=False)
            args = _get_arg(grouped, argname="args", allow_empty=False)
        info = _get_arg(grouped, argname="info", allow_empty=True)
        if info is None:
            info = ""
        conf = ctx.proj.settings.get(project.extra_commands, settings_type=ExtraCommandsConf)
        AliasCmd.add_cmd(conf, name, args, info)
        t.both << f'command<{name}> added.'
        ctx.proj.kernel.reloader.reload_cmds()

    @staticmethod
    def execute_interactive(ctx: CmdContext) -> Iterable:
        t = ctx.term
        # Enter name
        t << f"plz enter a unique name."
        while True:
            inputted: str = useRef()
            yield await_input(ctx, prompt="name=", ref=inputted)
            name = inputted.strip()
            if ctx.cmdlist.is_builtin(name):
                t << f"❌ {name} is a builtin command."
            else:
                break
        t.logging << f"name is {name}"
        t << f'plz enter cmd&args.'
        # Enter args
        inputted: Ref = useRef()
        yield input_multiline(ctx, prompt=lambda res: "+ " if len(res) > 0 else "args=", ref=inputted)
        lines: list[str] = inputted.deref()
        fullargs = " + ".join(lines)
        t.logging << f"{fullargs=}"
        # Enter help into
        t << f'plz enter help info.'
        inputted: Ref = useRef()
        yield input_multiline(ctx, prompt=lambda res: "\\n " if len(res) > 0 else "info=", ref=inputted)
        info: list[str] = inputted.deref()
        helpinfo = "\n".join(info)
        t.logging << f"{helpinfo=}"
        conf = ctx.proj.settings.get(project.extra_commands, settings_type=ExtraCommandsConf)
        if name in conf:
            confirm: bool = useRef()
            t << f"{ctx.style.usrname(name)} already exists, confirm to override it?"
            yield yes_no(ctx, ref=confirm)
            if not confirm:
                t.both << f"adding command<{name}> aborted"
                return
        AliasCmd.add_cmd(conf, name, fullargs, helpinfo)
        t.both << f'command<{name}> added.'
        ctx.proj.kernel.reloader.reload_cmds()

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "add an alias of commands"
        t << "| alias --n <cmd name> --args <full args> [--info <help info>]"
        t << '| alias cmd_name="full args" [--info <help info>]'
