from typing import Iterator

import fuzzy
from args import Args, split_multicmd
from build import await_input
from cmd import CmdContext, CommandExecuteError, CommandArgError, catch_executing
from style import Style
from tui.colortxt import FG
from tui.colortxt.txt import Palette
from utils import useRef, cast_bool

_cli_style = Style({
    "inputting": Palette(fg=FG.Magenta)
})


class CliCmd:
    name = "cli"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        raise CommandExecuteError(CliCmd, "only admit interactive mode")

    @staticmethod
    def execute_interactive(ctx: CmdContext) -> Iterator:
        t = ctx.term
        t << "enter the command prompts to run."
        while True:
            yield await_input(ctx, prompt="/", ref=(cmdargs := useRef()))
            cmdargs = Args.by(full=cmdargs.deref())
            all_cmdargs = split_multicmd(cmdargs)
            cmd_size = len(all_cmdargs)
            if cmd_size == 0:
                continue
            elif cmd_size == 1:
                args = all_cmdargs[0]
                command, args = args.poll()
                if command.ispair:
                    raise CommandArgError(CliCmd, command, f'invalid command format')
                cmdname = command.key
                executable = ctx.cmdlist[cmdname]
                if executable is None:
                    matched, ratio = fuzzy.match(cmdname, ctx.cmdlist.name2cmd.keys())
                    if matched is not None and ratio > fuzzy.at_least:
                        t << f'👀 command<{cmdname}> not found, do you mean command<{matched}>?'
                        yield await_input(ctx, prompt="y/n=", ref=(reply := useRef()))
                        inputted = reply.strip()
                        if inputted == "" or cast_bool(inputted):
                            executable = ctx.cmdlist[matched]
                        else:
                            t << f"alright, let's start all over again."
                            continue
                    else:
                        raise CommandArgError(CliCmd, command, "command not found")
                subctx = ctx.copy(args=args, style=_cli_style)
                catch_executing(ctx, executing=lambda: executable.execute_cli(subctx))
            else:
                # prepare commands to run
                exe_args = []
                # check if all of them are executable
                for command, args in (args.poll() for args in all_cmdargs):
                    if command.ispair:
                        raise CommandArgError(CliCmd, command, f'invalid command format')
                    cmdname = command.key
                    executable = ctx.cmdlist[cmdname]
                    if executable is None:
                        raise CommandArgError(CliCmd, command, "command not found")
                    exe_args.append((executable, args))
                for i, pair in enumerate(exe_args):
                    executable, args = pair
                    subctx = ctx.copy(args=args, style=_cli_style)
                    catch_executing(ctx, executing=lambda: executable.execute_cli(subctx))

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "cli"
        t << "|-- enter the cli mode"
