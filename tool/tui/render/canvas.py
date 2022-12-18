from typing import Protocol, runtime_checkable


@runtime_checkable
class Canvas(Protocol):
    def setChar(self, x: int, y: int, char: str):
        pass

    def setColor(self, x: int, y: int, *, fg: int = None, bg: int = None):
        pass

    def getColor(self, x: int, y: int) -> tuple[int, int] | None:
        pass

    def getChar(self, x: int, y: int) -> str | None:
        pass

    @property
    def sizeX(self) -> int:
        return 0

    @property
    def sizeY(self) -> int:
        return 0

    @property
    def shouldRerender(self) -> bool:
        return True


@runtime_checkable
class Renderer(Protocol):
    def initialize(self):
        pass

    def onResize(self):
        pass

    def getCanvas(self) -> Canvas:
        pass

    def render(self, canvas: Canvas):
        pass

    def dispose(self):
        pass


class FG:
    Red: int
    Green: int
    Blue: int
    Yellow: int
    Violet: int
    White: int
    Black: int
    Cyan: int
    AllColors: list[int]


class BG:
    Red: int
    Green: int
    Blue: int
    Yellow: int
    Violet: int
    White: int
    Black: int
    Cyan: int
    AllColors: list[int]
