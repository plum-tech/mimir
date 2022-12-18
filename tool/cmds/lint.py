from typing import Iterable

from cmd import CmdContext
from cmds.shared import print_stdout
from dart import DartFormatConf


def lint(ctx: CmdContext):
    conf = ctx.proj.settings.get("cmd.lint.conf", DartFormatConf)
    proc = ctx.proj.dartRunner.format(conf)
    print_stdout(ctx, proc)


class LintCmd:
    name = "lint"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        lint(ctx)

    @staticmethod
    def execute_interactive(ctx: CmdContext) -> Iterable:
        lint(ctx)
        yield

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "lint: format .dart files"
