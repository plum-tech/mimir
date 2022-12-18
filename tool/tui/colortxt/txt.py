from io import StringIO
from typing import Callable, TypeVar, Union, Protocol, runtime_checkable

from . import colors

T = TypeVar("T")


@runtime_checkable
class ColorStrLike(Protocol):
    def __len__(self) -> int:
        pass

    def __add__(self, other: Union[str, "ColorStrLike"]) -> "ColorStrLike":
        pass

    def get(self) -> str:
        pass


class ColorStr(ColorStrLike):
    def __init__(self, txt: str, *, fg=None, bg=None, style=None):
        self.txt = txt
        self.fg = fg
        self.bg = bg
        self.style = style

    def __str__(self):
        return self.txt

    def __repr__(self):
        return repr(self.txt)

    def __len__(self):
        return len(self.txt)

    def get(self) -> str:
        return colors.tint(self.txt, fg=self.fg, bg=self.bg, style=self.style)

    def __add__(self, other: Union[str, ColorStrLike]) -> "StrGroup":
        return StrGroup([self, other])

    def __mul__(self, times: int) -> "ColorStr":
        return ColorStr(self.txt * times, fg=self.fg, bg=self.bg, style=self.style)


class StrGroup(ColorStrLike):
    def __init__(self, items: list[ColorStrLike | str] = None):
        if items is None:
            items = []
        self.items = items

    def __len__(self) -> int:
        total = 0
        for item in self.items:
            total += len(item)
        return total

    def append(self, txt: ColorStrLike | str):
        self.items.append(txt)

    def add_head(self, txt: ColorStrLike | str):
        self.items.insert(0, txt)

    def insert(self, index: int, txt: ColorStrLike | str):
        self.items.insert(index, txt)

    def get(self) -> str:
        with StringIO() as s:
            for item in self.items:
                if isinstance(item, ColorStrLike):
                    s.write(item.get())
                else:
                    s.write(item)
            return s.getvalue()

    def __str__(self):
        with StringIO() as s:
            for item in self.items:
                if isinstance(item, ColorStrLike):
                    s.write(str(item))
                else:
                    s.write(item)
            return s.getvalue()

    def __repr__(self):
        return repr(str(self))


class Palette:
    def __init__(self, fg=None, bg=None, style=None):
        self.fg = fg
        self.bg = bg
        self.style = style

    def tint(self, txt) -> str:
        txt = txt if isinstance(txt, str) else str(txt)
        return colors.tint(txt, fg=self.fg, bg=self.bg, style=self.style)

    def dye(self, txt) -> ColorStr:
        txt = txt if isinstance(txt, str) else str(txt)
        return ColorStr(txt, fg=self.fg, bg=self.bg, style=self.style)

    def dye_all(self, li: list[T], mapping: Callable[[T], str] = lambda _: _) -> StrGroup:
        group: list[ColorStr] = []
        for s in li:
            group.append(self.dye(mapping(s)))
        return StrGroup(group)

    def __call__(self, *args, **kwargs) -> str | ColorStrLike:
        """

        :param args:
        :param kwargs: type=Literal[str,Any]
        :return:
        """
        if len(args) >= 1:
            arg0 = args[0]
            t = kwargs["type"] if "type" in kwargs else str
            if t == str:
                return self.tint(arg0)
            else:
                return self.dye(arg0)
        else:
            raise TypeError("only allow 1 positional arguments")
