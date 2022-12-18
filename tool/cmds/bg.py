from typing import Iterator

from cmd import CmdContext


class BgCmd:
    name = "bg"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        pass

    @staticmethod
    def execute_interactive(ctx: CmdContext) -> Iterator:
        yield

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "bg <..args>: run a command in background"
        t << "bg --l: list all background tasks"
        t << "bg --kill <regex>: kill all tasks matched"
