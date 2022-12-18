from . import ui
from .arb import ArbFile, load_arb_from, save_flatten
from .pair import Pair


def rename_key(
        template_path: str, other_paths: list[str], old: str, new: str,
        auto_add=True,
        indent=2, keep_unmatched_meta=False,
        terminal: ui.Terminal = ui.terminal):
    template = load_arb_from(path=template_path)
    others = [load_arb_from(path=p) for p in other_paths]
    rename_key_by(template=template, others=others, old=old, new=new, auto_add=auto_add, indent=indent,
                  keep_unmatched_meta=keep_unmatched_meta, terminal=terminal)


def rename_key_by(
        template: ArbFile, others: list[ArbFile],
        old: str, new: str,
        auto_add=True,
        indent=2, keep_unmatched_meta=False,
        terminal: ui.Terminal = ui.terminal):
    arbs = others + [template]
    for arb in arbs:
        if old in arb.pmap:
            arb.rename_key(old=old, new=new)
            terminal.log(f'renamed "{old}" to "{new}" in "{arb.file_name()}".')
        else:
            if auto_add:
                p = Pair(key=new, value="")
                arb.add(p)
                terminal.log(f'added "{new}" in "{arb.file_name()}".')

    for arb in arbs:
        save_flatten(arb, indent, keep_unmatched_meta)
        terminal.log(f'{arb.file_name()} saved.')
