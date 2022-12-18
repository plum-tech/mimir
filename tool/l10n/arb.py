import os.path

from .util import *
from .pair import *
import json


class ArbFile:
    path: str
    plist: PairList
    pmap: PairMap

    def __init__(self, path: str, plist: PairList, pmap: PairMap):
        self.path = path
        self.plist = plist
        self.pmap = pmap

    def split(self) -> tuple[str, str]:
        return os.path.split(self.path)

    def file_name(self) -> str:
        return self.split()[1]

    def rename_key(self, old: str, new: str) -> bool:
        if old in self.pmap:
            self.pmap[old].key = new
            self.pmap[new] = self.pmap[old]
            return True
        else:
            return False

    def add(self, pair: Pair):
        self.plist.append(pair)
        self.pmap[pair.key] = pair

    def __repr__(self):
        return f"{self.path}"


OrderedJson = OrderedDict[str, Any]
jcoder = json.JSONDecoder(object_hook=OrderedDict)


def suffix_arb(file_name: str) -> str:
    if not file_name.endswith(".arb"):
        return f"{file_name}.arb"
    else:
        return file_name


def load_arb(
        *, path=None, content=None
) -> tuple[PairList, PairMap]:
    if path is None and content is None:
        raise Exception("No .arb \"path\" or \"content\" argument is given")
    if path is not None and content is None:
        content = read_fi(path)
    l10n = jcoder.decode(content)
    relisted = list(l10n.items())
    return convert_pairs(relisted)


def load_arb_from(*, path: str) -> ArbFile:
    content = read_fi(path)
    l10n = jcoder.decode(content)
    relisted = list(l10n.items())
    plist, pmap = convert_pairs(relisted)
    return ArbFile(path, plist, pmap)


def load_all_arb_in(
        *, folder: str = None, paths: list[str] = None
) -> list[ArbFile]:
    all_arb = []
    if folder is None and paths is None:
        raise Exception("No .arb \"folder\" or \"paths\" is given")
    if folder is not None and paths is None:
        paths = []
        for f in os.listdir(folder):
            full = os.path.join(folder, f)
            if os.path.isfile(full):
                if f.endswith(".arb"):
                    paths.append(full)
    for path in paths:
        arb = load_arb_from(path=path)
        all_arb.append(arb)
    return all_arb


def save_flatten(arb: ArbFile, indent=2, keep_unmatched_meta=False):
    ordered = flatten_pairs(arb.plist, keep_unmatched_meta)
    content = json.dumps(ordered, ensure_ascii=False, indent=indent)
    write_fi(arb.path, content)
