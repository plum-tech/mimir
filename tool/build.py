from io import StringIO
from typing import Iterator, Any, Callable, TypeVar

import convert
from convert import Type2Converters
import fuzzy
from cmd import CommandLike, CmdContext
from coroutine import Task, STOP
from utils import cast_int, cast_bool, useRef, Ref

T = TypeVar("T")


def await_input(
        ctx: CmdContext, prompt: str, *, ref: useRef,
        abort_sign="#"
) -> Task:
    """
    when input is a hash sign "#", the coroutine will abort instantly
    """

    def task():
        inputted = ctx.term.input(ctx.style.inputting(prompt))
        if inputted == abort_sign:
            yield STOP
        else:
            ref.obj = inputted
            yield

    return task


def tint_cmdname(ctx: CmdContext, cmd: CommandLike) -> str:
    if hasattr(cmd, "created_by_user"):
        if getattr(cmd, "created_by_user"):
            return ctx.style.usrname(cmd.name)
    return ctx.style.name(cmd.name)


_TintFunc = Callable[[str], str]


def _build_contents(
        ctx: CmdContext, candidates: dict[str, Any], row: int,
        tint_num: _TintFunc, tint_name: _TintFunc,
):
    s = StringIO()
    t = ctx.term
    for i, pair in enumerate(candidates.items()):
        key, value = pair
        if i != 0 and i % row == 0:
            t << f"👀 {s.getvalue()}"
            s.close()
            s = StringIO()
        s.write(f"{tint_num(f'#{i}')}={tint_name(key)}\t")
    if s.readable():
        t << f"👀 {s.getvalue()}"
        s.close()


def select_many(
        ctx: CmdContext,
        candidates: dict[str, Any],
        prompt: str,
        *, ignore_case=True,
        row=4, ref: Ref | Any
) -> Task:
    return _select_many(
        ctx, candidates,
        prompt, ignore_case=ignore_case,
        row=row, ref=ref,
        tint_num=lambda num: ctx.style.number(num),
        tint_name=lambda name: ctx.style.name(name)
    )


def select_many_cmds(
        ctx: CmdContext,
        candidates: dict[str, CommandLike],
        prompt: str,
        *, ignore_case=True,
        row=4, ref: Ref | Any
) -> Task:
    return _select_many(
        ctx, candidates,
        prompt, ignore_case=ignore_case,
        row=row, ref=ref,
        tint_num=lambda num: ctx.style.number(num),
        tint_name=lambda cmd: tint_cmdname(ctx, candidates[cmd]) if cmd in candidates else ctx.style.name(cmd)
    )


def _select_many(
        ctx: CmdContext,
        candidates: dict[str, Any],
        prompt: str,
        *, ignore_case=True,
        row=4, ref: Ref | Any,
        tint_num: _TintFunc, tint_name: _TintFunc,
) -> Task:
    li = list(candidates.items())
    t = ctx.term
    while True:
        _build_contents(ctx, candidates, row, tint_num, tint_name)
        t << '[multi-select] enter "*" to select all or split each by ",".'
        inputted: str = useRef()
        yield await_input(ctx, prompt, ref=inputted)
        inputted = inputted.strip()
        if inputted == "*":
            ref.obj = candidates.values()
            yield
        res = []
        failed = False
        for entry in inputted.split(","):
            entry = entry.strip()
            if entry.startswith("#"):
                # numeric mode
                entry = entry.removeprefix("#")
                num = cast_int(entry)
                if num is None:
                    t << f"❗ {entry} isn't an integer, plz try again."
                    failed = True
                    break
                else:
                    key, value = li[num]
                    res.append(value)
            else:
                # name mode
                if ignore_case:
                    entry = entry.lower()
                # name mode
                if entry in candidates:
                    res.append(candidates[entry])
                else:
                    t << f'❗ "{entry}" not found, plz try again.'
                    failed = True
                    break
        if not failed:
            ref.obj = res
            yield


def select_one_cmd(
        ctx: CmdContext,
        candidates: dict[str, Any],
        prompt: str,
        *, ignore_case=True,
        fuzzy_match=False,
        row=4, ref: Ref | Any
) -> Task:
    return _select_one(
        ctx, candidates,
        prompt, ignore_case=ignore_case,
        fuzzy_match=fuzzy_match,
        row=row, ref=ref,
        tint_num=lambda num: ctx.style.number(num),
        tint_name=lambda cmd: tint_cmdname(ctx, candidates[cmd]) if cmd in candidates else ctx.style.name(cmd)
    )


def select_one(
        ctx: CmdContext,
        candidates: dict[str, Any],
        prompt: str,
        *, ignore_case=True,
        fuzzy_match=False,
        row=4, ref: Ref | Any
) -> Task:
    return _select_one(
        ctx, candidates,
        prompt, ignore_case=ignore_case,
        fuzzy_match=fuzzy_match,
        row=row, ref=ref,
        tint_num=lambda num: ctx.style.number(num),
        tint_name=lambda cmd: ctx.style.name(cmd)
    )


def _select_one(
        ctx: CmdContext,
        candidates: dict[str, Any],
        prompt: str,
        *, ignore_case=True,
        fuzzy_match=False,
        row=4, ref: Ref | Any,
        tint_num: _TintFunc, tint_name: _TintFunc,
) -> Task:
    def task() -> Iterator:
        t = ctx.term
        li = list(candidates.items())
        while True:
            _build_contents(ctx, candidates, row, tint_num, tint_name)
            inputted: str = useRef()
            yield await_input(ctx, prompt, ref=inputted)
            inputted = inputted.strip()
            if inputted.startswith("#"):
                # numeric mode
                inputted = inputted.removeprefix("#")
                num = cast_int(inputted)
                if num is None:
                    t << f"❗ {inputted} isn't an integer, plz try again."
                else:
                    if 0 <= num < len(li):
                        key, value = li[num]
                        ref.obj = value
                        yield
                    else:
                        t << f"❗ {num} is out of range[0,{len(li)}), plz try again."
            else:
                if ignore_case:
                    inputted = inputted.lower()
                # name mode
                if inputted in candidates:
                    ref.obj = candidates[inputted]
                    yield
                elif fuzzy_match:
                    matched, radio = fuzzy.match(inputted, candidates.keys())
                    if radio >= fuzzy.at_least:
                        t << f'do you mean "{matched}"?'
                        inputted = useRef()
                        yield await_input(ctx, prompt="y/n=", ref=inputted)
                        inputted = inputted.strip()
                        if inputted == "" or cast_bool(inputted):
                            ref.obj = candidates[matched]
                            yield
                        else:
                            t << f"alright, let's start all over again."
                    else:
                        t << f'❗ "{inputted}" not found, plz try again.'
                else:
                    t << f'❗ "{inputted}" not found, plz try again.'

    return task


def input_multiline(
        ctx: CmdContext, prompt: Callable[[list[str]], str],
        end_sign="#END", *, ref: Ref | Any
) -> Task:
    lines = []

    def task() -> Iterator:
        while True:
            end_sign_tip = ctx.style.highlight("#END")
            ctx.term << f'enter "{end_sign_tip}" to end multi-line'
            yield await_input(ctx, prompt=prompt(lines), ref=(line := useRef()))
            line = line.strip()
            if line == end_sign:
                break
            lines.append(line)
        yield

    ref.obj = lines
    return task


def yes_no(
        ctx: CmdContext, *, ref: Ref | Any
) -> Task:
    def task() -> Iterator:
        inputted: str = useRef()
        yield await_input(ctx, prompt="y/n=", ref=inputted)
        reply = inputted.strip()
        ref.obj = cast_bool(reply)
        yield

    return task


AttrViewer = Callable[[T], Iterator[tuple[str, Any]]]


def respect_private_viewer(obj: Any) -> Iterator[tuple[str, Any]]:
    for name, value in vars(obj).items():
        if not name.startswith("_"):
            yield name, value


def replace_settings(
        ctx: CmdContext, *,
        obj: T, viewer: AttrViewer = respect_private_viewer,
        converters: Type2Converters | Callable[[], Type2Converters] = lambda: convert.builtins
) -> Task:
    def task() -> Iterator:
        s = ctx.style
        skip_sign_tip = s.highlight("#SKIP")
        end_sign_tip = s.highlight("#END")
        ctx.term << f'enter "{skip_sign_tip}" to skip, "{end_sign_tip}" to interrupt'
        type2cnvt = converters if isinstance(converters, dict) else converters()
        end = False
        for name, value in viewer(obj):
            t = type(value)
            cnvt = type2cnvt[t]
            ctx.term << f"{s.name(name)}:{s.type(t.__name__)}={s.value(cnvt.to_str(value))}"
            while True:
                yield await_input(ctx, prompt=f"{name}=", ref=(ref := useRef()))
                new_raw = ref.deref()
                if new_raw == "#SKIP":
                    break
                elif new_raw == "#END":
                    end = True
                    break
                else:
                    new_value = cnvt.from_str(new_raw)
                    if new_value is None:
                        ctx.term << "failed to convert, plz try again."
                        continue
                    else:
                        setattr(obj, name, new_value)
                        break
            if end:
                break
        yield

    return task


def settings_from_str(
        obj: Any, settings: dict[str, str],
        converters: Type2Converters | Callable[[], Type2Converters] = lambda: convert.builtins,
):
    type2cnvt = converters if isinstance(converters, dict) else converters()
    for name, value in settings.items():
        if hasattr(obj, name):
            original = getattr(obj, name)
            cnvt = type2cnvt[type(original)]
            setattr(obj, name, cnvt.from_str(value))
