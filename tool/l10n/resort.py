from functools import cmp_to_key
from . import tags
from . import weights
from . import split
from .arb import *

required_para = [
    "target",
]
ResortMethod = Callable[[PairList, PairMap], PairList]


def do_alphabetically_sort(plist: PairList, pmap: PairMap, reverse=False) -> PairList:
    if not reverse:
        return sorted(plist, key=lambda x: x.key)
    else:
        return sorted(plist, key=lambda x: ''.join(reversed(x.key)))


def lexicographical_compr(a: Pair, b: Pair):
    k1 = a.key
    k2 = b.key
    l1 = len(k1)
    l2 = len(k2)
    for i in range(0, min(l1, l2)):
        str1_ch = ord(k1[i])
        str2_ch = ord(k1[i])

        if str1_ch != str2_ch:
            return str1_ch - str2_ch
    # Edge case for strings like
    # a="Liplum" and b="LiplumUwU"
    if l1 != l2:
        return l1 - l2
    else:
        # If none of the above conditions is true,
        # it implies both the strings are equal
        return 0


def do_lexicographical_sort(plist: PairList, pmap: PairMap) -> PairList:
    return sorted(plist, key=cmp_to_key(lexicographical_compr))


def lister():
    return []


def attach_tag(p: Pair):
    for tag in weights.all_tags:
        if tag.match(p):
            p_tags = getAttrOrSet(p, "tags", lister)
            p_tags.append(tag.tag(p))


def do_tags_sort(plist: PairList, pmap: PairMap) -> PairList:
    for p in plist:
        p.key_parts = split.split_key(p.key)
        attach_tag(p)
    return sorted(plist, key=lambda pr: tags.sum_weight(pr.tags), reverse=True)


Alphabetical = "alphabetical"
Aalphabetical = "-alphabetical"
Lexicographical = "lexicographical"
Tags = "tags"
methods: dict[str, ResortMethod] = {
    Alphabetical: lambda li, mp: do_alphabetically_sort(li, mp, reverse=False),
    Aalphabetical: lambda li, mp: do_alphabetically_sort(li, mp, reverse=True),
    Lexicographical: do_lexicographical_sort,
    Tags: do_tags_sort,
}
id2methods: dict[int, str] = {
    0: Alphabetical,
    1: Aalphabetical,
    2: Lexicographical,
    3: Tags,
}


def wrapper(args):
    paras = split_para(args)
    check_para_exist(paras, required_para)
    target = paras["target"]
    indent = int(From(paras, Get="indent", Or="2"))
    keep_unmatched_meta = From(paras, Get="keep_unmatched_meta", Or="n") == "y"
    method_name = From(paras, Get="method", Or="cleanup")
    method = From(methods, Get=method_name, Or=do_alphabetically_sort)
    txt = read_fi(target)
    res = resort(txt, method, indent, keep_unmatched_meta)
    write_fi(target, res)


def resort(target, method: ResortMethod, indent=2, keep_unmatched_meta=False) -> str:
    plist, pmap = load_arb(content=target)
    pair_list = method(plist, pmap)
    ordered = flatten_pairs(pair_list, keep_unmatched_meta)
    return json.dumps(ordered, ensure_ascii=False, indent=indent)
