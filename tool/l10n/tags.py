from . import pair
from . import util


class Tag:
    name: str

    def __init__(self, name: str):
        self.name = name

    def get_weight(self):
        return 0

    def __repr__(self):
        return f"Tag({self.name},{self.get_weight()})"


class StaticTag(Tag):
    weight: int

    def __init__(self, name: str, weight: int):
        super().__init__(name)
        self.weight = weight

    def get_weight(self):
        return self.weight


class TagType:
    __sharedTag = Tag("Nameless")

    def match(self, it: pair.Pair) -> bool:
        return False

    def tag(self, it: pair.Pair) -> Tag:
        return TagType.__sharedTag


class AnyTagType(TagType):
    weight: int

    def __init__(self, weight: int):
        self.weight = weight
        self._sharedTag = StaticTag("Any", weight)

    def match(self, it: pair.Pair) -> bool:
        return True

    def tag(self, it: pair.Pair) -> Tag:
        return self._sharedTag

    def __repr__(self):
        return f"AnyTagType({self.weight})"


class StaticTagType(TagType):
    weight: int
    keyword: str | list[str]

    def __init__(self, keyword: str | list[str], weight: int):
        super().__init__()
        self.weight = weight
        self.keyword = keyword
        self._sharedTag = StaticTag(keyword, weight)

    def tag(self, it: pair.Pair) -> Tag:
        return self._sharedTag

    def match(self, it: pair.Pair) -> bool:
        if isinstance(self.keyword, list):
            return util.contains(self.keyword, it.key_parts)
        else:
            return self.keyword in it.key_parts

    def __repr__(self):
        return f"StaticTagType({self.keyword},{self.weight})"


class LengthTagType(TagType):
    factor: float

    def __init__(self, factor: float):
        self.factor = factor

    def tag(self, it: pair.Pair) -> Tag:
        return StaticTag("Length", int(len(it.key) * self.factor))

    def match(self, it: pair.Pair) -> bool:
        return True

    def __repr__(self):
        return f"LengthTagType({self.factor})"


def sum_weight(tags: list[Tag]):
    res = None
    for tag in tags:
        if res is None:
            res = tag.get_weight()
        else:
            res += tag.get_weight()
    return res
