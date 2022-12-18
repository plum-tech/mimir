from collections import OrderedDict
from typing import Any

RawPairList = list[tuple[str, Any]]

EMPTY_VALUE = object()


class Pair:
    key: str
    value: str | object
    has_meta: bool
    meta_value: Any
    key_parts: list[str]

    def __init__(self, key: str = "", value: str = EMPTY_VALUE):
        self.key = key
        self.value = value
        self.has_meta = False
        self.meta_value = None

    def set_value(self, value: str):
        self.value = value

    def set_meta(self, meta_value: Any):
        self.has_meta = True
        self.meta_value = meta_value

    def __repr__(self):
        return f"Pair({self.key},{self.has_meta=}:\"{self.value}\")"


PairList = list[Pair]
PairMap = dict[str, Pair]


def convert_pairs(pairs: RawPairList) -> tuple[PairList, PairMap]:
    """
    Convert the raw pair list to real pairs and keep the same order.
    """
    di: dict[str, Pair] = {}
    li: list[Pair] = []
    for key, value in pairs:
        if key.startswith("@") and not key.startswith("@@"):  # is meta key
            raw_key = key.removeprefix("@")
            if raw_key in di:
                di[raw_key].set_meta(value)
            else:
                pair = Pair(raw_key)
                pair.set_meta(value)
                di[raw_key] = pair
                li.append(pair)
        else:  # is common key
            if key in di:
                di[key].set_value(value)
            else:
                pair = Pair(key, value)
                di[key] = pair
                li.append(pair)
    return li, di


def flatten_pairs(pairs: PairList, keep_unmatched_meta=True) -> OrderedDict[str, Any]:
    """
    flatten a Pair List.
    Keep the meta pair closely following the common pair
    :return: flatten and ordered dict
    """
    d = OrderedDict()
    for pair in pairs:
        key = pair.key
        value = pair.value
        if value is EMPTY_VALUE:
            if keep_unmatched_meta:
                print(f"[Warn] \"{key}\"  is a meta but missing a pair. <Kept>")
                if pair.has_meta:
                    d[f"@{key}"] = pair.meta_value
            else:
                print(f"[Warn] \"{key}\" is a meta but missing a pair. <Ignored>")
        else:
            d[key] = value
            if pair.has_meta:
                d[f"@{key}"] = pair.meta_value
    return d
