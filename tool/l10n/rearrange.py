from json import JSONDecodeError

from .arb import *
import os
import os.path

required_para = [
    "prefix",
    "template",
]


def wrapper(args):
    paras = split_para(args)
    check_para_exist(paras, required_para)
    prefix = paras["prefix"]
    template = paras["template"]
    fill_blank = to_bool(From(paras, Get="fill_blank", Or="n"))
    indent = int(From(paras, Get="indent", Or="2"))
    keep_unmatched_meta = to_bool(From(paras, Get="keep_unmatched_meta", Or="n"))
    teplt_head, teplt_tail = os.path.split(template)
    template_suffix = teplt_tail.removeprefix(prefix)
    rearrange(teplt_head, prefix, template_suffix, indent, keep_unmatched_meta, fill_blank)


def rearrange(l10n_dir: str, prefix: str, template_suffix: str, indent=2, keep_unmatched_meta=False, fill_blank=False):
    """
    :param keep_unmatched_meta: keep a meta missing a pair
    :param l10n_dir: lib/l10n
    :param prefix: app_
    :param template_suffix: en.arb
    :param indent: 2
    :param fill_blank: False
    """
    template_fullname = prefix + template_suffix
    others_path = collect_others(l10n_dir, prefix, template_fullname)
    template_path = os.path.join(l10n_dir, template_fullname)
    tplist, tpmap = load_arb(path=template_path)
    rearrange_others_saved_re(others_path, tplist, indent, keep_unmatched_meta, fill_blank)


def collect_others(l10n_dir: str, prefix: str = "app", template: str = "app_en.arb") -> list[str]:
    """
    :param template: the full name of template
    :param prefix: app_
    :param l10n_dir: lib/l10n
    :return: paths of other .arb files
    """
    others_path = []
    for f in os.listdir(l10n_dir):
        full = os.path.join(l10n_dir, f)
        if os.path.isfile(full):
            if f != template and f.endswith(".arb") and f.startswith(prefix):
                others_path.append(full)
    return others_path


def rearrange_others(arbs: list[ArbFile], template: ArbFile, fill_blank=False):
    """
    rearrange in place
    """
    for arb in arbs:
        new_plist = []
        for tp in template.plist:
            key = tp.key
            if key in arb.pmap:
                new_plist.append(arb.pmap[key])
            else:
                if fill_blank:
                    p = Pair(key, value="")
                    arb.pmap[key] = p
                    new_plist.append(p)
        arb.plist = new_plist


def rearrange_others_saved_re(
        others_path: list[str], template_plist: PairList,
        indent=2, keep_unmatched_meta=False, fill_blank=False,
        on_rearranged: Callable[[str], None] = lambda _: None
):
    others_arb = []
    for other_path in others_path:
        try:
            arb = load_arb_from(path=other_path)
        except FileNotFoundError or JSONDecodeError:
            arb = ArbFile(other_path, [], {})
        others_arb.append(arb)
    for arb in others_arb:
        new_plist = []
        for tp in template_plist:
            key = tp.key
            if key in arb.pmap:
                new_plist.append(arb.pmap[key])
            else:
                if fill_blank:
                    p = Pair(key, value="")
                    arb.pmap[key] = p
                    new_plist.append(p)
        arb.plist = new_plist
    for arb in others_arb:
        save_flatten(arb, indent, keep_unmatched_meta)
        on_rearranged(arb.path)
