from io import StringIO
from enum import Enum, auto


class Align(Enum):
    Left = auto()
    Right = auto()


def repeat(num: int, repeater: str = " "):
    return repeater * num


def center_text_in_line(
        text: str, length: int,
        align: Align = Align.Left,
        repeater: str = "-"
) -> str:
    rest = length - len(text)
    half = rest // 2
    if align == Align.Left:
        left = half
        right = rest - half
    else:
        left = rest - half
        right = half
    with StringIO() as s:
        s.write(repeat(left, repeater))
        s.write(text)
        s.write(repeat(right, repeater))
        return s.getvalue()
