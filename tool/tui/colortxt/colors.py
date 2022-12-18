import io
from typing import TypeVar

TIO = TypeVar("TIO", bound=io.IOBase, covariant=True)


# @formatter:off
class FG:
    Black       = ";30"
    Red         = ";31"
    Green       = ";32"
    Yellow      = ";33"
    Blue        = ";34"
    Violet      = ";35"
    Cyan        = ";36"
    White       = ";37"

    LightBlack  = ";90"
    Rose        = ";91"
    Emerald     = ";92"
    Gold        = ";93"
    Sky         = ";94"
    Magenta     = ";95"
    Azure       = ";96"
    LightWhite  = ";97"

    All: list[str] = [
        Black, Red, Green, Yellow, Blue, Violet, Cyan, White,
        LightBlack, Rose, Emerald, Gold, Sky, Magenta, Azure, LightWhite,
    ]

class BG:
    Black       = ";40"
    Red         = ";41"
    Green       = ";42"
    Yellow      = ";43"
    Blue        = ";44"
    Violet      = ";45"
    Cyan        = ";46"
    White       = ";47"

    LightBlack  = ";100"
    Rose        = ";101"
    Emerald     = ";102"
    Gold        = ";103"
    Sky         = ";104"
    Magenta     = ";105"
    Azure       = ";106"
    LightWhite  = ";107"

    All: list[str] = [
        Black, Red, Green, Yellow, Blue, Violet, Cyan, White,
        LightBlack, Rose, Emerald, Gold, Sky, Magenta, Azure, LightWhite,
    ]
class Style:
    Bold            = "1"
    Dim             = "2"
    Italics         = "3"
    Underline       = "4"
    Flash           = "5"   # not standard
    ReverseColor    = "7"
    Deleted         = "9"   # not standard
    DualUnderline   = "21"  # not standard
    Overline        = "53"  # not standard
    All: list[str] = [
        Bold, Dim, Italics, Underline, Flash, ReverseColor, Deleted, DualUnderline,
        Overline
    ]
# @formatter:on


def tint(text: str,
         *, fg=None, bg=None, style=None) -> str:
    with io.StringIO() as s:
        tintIO(s, text, fg, bg, style)
        return s.getvalue()


def tintIO(s: TIO,
           text: str, fg=None, bg=None, style=None
           ) -> TIO:
    s.write("\033[")
    if style:
        s.write(style)
    if fg:
        s.write(fg)
    if bg:
        s.write(bg)
    s.write('m')
    s.write(text)
    s.write("\033[0m")
    return s
