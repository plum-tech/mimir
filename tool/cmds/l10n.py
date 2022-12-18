from threading import Thread
from typing import Iterable, Callable

import fuzzy
from build import select_one, await_input
from cmd import CmdContext, CommandArgError, CommandEmptyArgsError, CommandLike
from cmds.shared import print_stdout
from filesystem import File
from project import Proj
from utils import useRef, cast_bool


class ServeTask:
    name = "l10n_serve"

    def __init__(self):
        self.running = True

    def terminate(self):
        self.running = False


def template_and_others(proj: Proj) -> tuple[File, list[File]]:
    template = proj.template_arb_fi
    template_name = template.name
    others = []
    for fi in proj.l10n_dir.listing_fis():
        if fi.name != template_name:
            others.append(fi)
    return template, others


def resort(ctx: CmdContext):
    import l10n.resort as res
    for fi in ctx.proj.l10n_dir.listing_fis():
        if fi.extendswith("arb"):
            new = res.resort(fi.read(), res.methods[res.Alphabetical])
            fi.write(new)
            ctx.term << f"{fi.path} resorted."


def rename(ctx: CmdContext) -> Iterable:
    import l10n.rename as res
    from l10n.arb import load_arb_from
    template, others = template_and_others(ctx.proj)
    template_arb = load_arb_from(path=str(template.path))
    while True:
        while True:
            yield await_input(ctx, "old=", ref=(inputted := useRef()))
            old = inputted.obj.strip()
            if old in template_arb.pmap:
                break
            else:
                matched, ratio = fuzzy.match(old, template_arb.pmap.items())
                if ratio > fuzzy.at_least:
                    ctx.term << f'"{old}" not found, do you mean "{matched}"?'
                    yield await_input(ctx, "y/n=", ref=inputted)
                    if cast_bool(inputted):
                        old = matched
                        break
                    else:
                        ctx.term << "alright, let's start all over again."

        yield await_input(ctx, "new=", ref=inputted)
        new = inputted.obj.strip()
        res.rename_key_by(template=template_arb, others=[load_arb_from(path=str(f.path)) for f in others],
                          old=old, new=new,
                          terminal=ctx.term,
                          auto_add=True)


def serve(ctx: CmdContext):
    import l10n.serve as ser
    template, others = template_and_others(ctx.proj)
    task = ServeTask()

    def run():
        try:
            ser.start(
                str(template.path),
                [str(f.path) for f in others],
                terminal=ctx.term,
                is_running=lambda: task.running)
        except Exception as e:
            ctx.term << str(e)

    thread = Thread(target=run)
    thread.daemon = True
    thread.start()
    ctx.proj.kernel.background << task
    ctx.term << "l10n is serving in background"


def gen(ctx: CmdContext):
    proc = ctx.proj.dartRunner.flutter(["gen-l10n"])
    print_stdout(ctx, proc)


name2function: dict[str, Callable[[CmdContext], None]] = {
    "resort": resort,
    "serve": serve,
    "gen": gen
}


class L10nCmd:
    name = "l10n"

    @staticmethod
    def execute_cli(ctx: CmdContext):
        args = ctx.args
        if len(args) == 0:  # only None
            raise CommandEmptyArgsError(L10nCmd, args, "no function specified")
        elif len(args) == 1:
            func_name = args[0].full.removeprefix("--")
            if func_name not in name2function:
                raise CommandArgError(L10nCmd, args[0], f"function<{func_name}> not found")
            else:
                func = name2function[func_name]
                func(ctx)
        else:  # including None
            raise CommandArgError(L10nCmd, args[1], "only allow one function")

    @staticmethod
    def execute_interactive(ctx: CmdContext) -> Iterable:
        while True:
            selected = useRef()
            funcs = dict(name2function)
            funcs.update({
                "rename": rename
            })
            yield select_one(ctx, funcs, prompt="func=", fuzzy_match=True, ref=selected)
            if selected == rename:
                yield rename(ctx)
            else:
                selected(ctx)

    @staticmethod
    def help(ctx: CmdContext):
        t = ctx.term
        t << "l10 resort: resort .arb files alphabetically"
        t << "l10 serve: watch the change of .arb files"
