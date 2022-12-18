from typing import Iterable

import multiplatform
from args import Args, Arg
from build import await_input
from cmd import CmdContext
from cmds.shared import print_stdout
from utils import useRef


def run_native_cmd(ctx: CmdContext, args: Args):
    proc = ctx.proj.runner.run(seq=args.compose())
    print_stdout(ctx, proc)


class NativeCmd:
    def __init__(self, name: str):
        self.name = name

    def execute_cli(self, ctx: CmdContext):
        git_args = Arg.by(self.name) + ctx.args
        run_native_cmd(ctx, git_args)

    def execute_interactive(self, ctx: CmdContext) -> Iterable:
        while True:
            yield await_input(ctx, prompt=f"{self.name} ", ref=(argsRef := useRef()))
            args = Args.by(full=argsRef.deref())
            git_args = Arg.by(self.name) + args
            run_native_cmd(ctx, git_args)

    def help(self, ctx: CmdContext):
        t = ctx.term
        t << f"the same as the native command<{self.name}>, and plz ensure it in your {multiplatform.envvar('PATH')}."
