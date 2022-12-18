from typing import Iterable, Iterator

import build
from args import group_args, Args
from cmd import CmdContext, CommandList, CommandArgError, CommandEmptyArgsError, CommandLike
from ui import Terminal
from utils import useRef, cast_int


class HelpBoxTerminal(Terminal):

    def __init__(self, inner: Terminal):
        super().__init__()
        self.inner = inner

    def print(self, *args):
        self.inner.print("|", *args)

    def log(self, *args):
        self.inner.log(*args)

    def input(self, prompt: str) -> str:
        return self.inner.input(f"| {prompt}")

    def print_log(self, *args):
        self.print(*args)
        self.log(*args)


def create_page4show(cmdlist: CommandList, page: set[int], cmd_per_page: int) -> Iterable[CommandLike]:
    for pagenum, cmds in cmdlist.browse_by_page(cmd_per_page):
        if pagenum in page:
            for cmd in cmds:
                yield cmd


class HelpCmd(CommandLike):
    def __init__(self, cmdlist: CommandList):
        self.name = "help"
        self.cmdlist = cmdlist
        self.cmd_per_page = 5

    def execute_interactive(self, ctx: CmdContext) -> Iterator:
        # all_cmd = ', '.join(ctx.cmdlist.keys())
        # ctx.term << f"all commands = [{all_cmd}]"
        while True:
            ctx.term << f'plz select commands to show info.'
            selected: list[CommandLike] = useRef()
            yield build.select_many_cmds(ctx, ctx.cmdlist.name2cmd, prompt="I want=", ref=selected)
            ctx.term.line(48)
            help_ctx = ctx.copy(term=HelpBoxTerminal(ctx.term))
            for cmd in selected:
                HelpCmd.show_help_info(cmd, ctx, help_ctx)
            ctx.term.line(48)

    def execute_cli(self, ctx: CmdContext):
        grouped = group_args(ctx.args)
        cmd_args: Args = grouped[None][0]
        if cmd_args.isempty:
            raise CommandEmptyArgsError(self, cmd_args, "no command name given")
        cmdname_arg = cmd_args[0]
        if cmdname_arg.ispair and cmdname_arg.key == "name":
            cmdname = cmdname_arg.value
        else:
            cmdname = cmdname_arg.key
        # Display board
        help_ctx = ctx.copy(term=HelpBoxTerminal(ctx.term))
        if cmdname == "*":  # show all
            if "p" in grouped:
                page_group = grouped["p"]
                pages = set()
                for page in page_group:
                    pagenum_arg = page[0]
                    if pagenum_arg is not None:
                        if pagenum_arg.ispair:
                            raise CommandArgError(self, pagenum_arg, "❌ arg<p> can't be a pair")
                        pagenum = cast_int(pagenum_arg.key)
                        if pagenum is None:
                            raise CommandArgError(
                                self, pagenum_arg, f"❌ {pagenum_arg.key} isn't valid page number")
                        pages.add(pagenum)
                    else:
                        raise CommandArgError(self, pagenum_arg, "❌ arg<p> is empty")
                for cmd_obj in create_page4show(ctx.cmdlist, pages, self.cmd_per_page):
                    HelpCmd.show_help_info(cmd_obj, ctx, help_ctx)
                ctx.term << f"total page: {ctx.cmdlist.calc_total_page(self.cmd_per_page)}"
            else:
                for cmd_obj in ctx.cmdlist.values():
                    HelpCmd.show_help_info(cmd_obj, ctx, help_ctx)

        else:  # show specified
            cmd_obj = ctx.cmdlist[cmdname]
            if cmd_obj is None:
                raise CommandArgError(self, cmdname_arg, f"❌ command<{cmdname}> not found")
            HelpCmd.show_help_info(cmd_obj, ctx, help_ctx)

    @staticmethod
    def show_help_info(cmd: CommandLike, ctx: CmdContext, help_box: CmdContext):
        ctx.term << build.tint_cmdname(ctx, cmd)
        cmd.help(help_box)

    def help(self, ctx: CmdContext):
        ctx.term << 'help <command name>'
        ctx.term << "| show command's info"
        ctx.term << 'help *'
        ctx.term << '| show all commands info'
        ctx.term << '| --p [int]: specify the page to show'
