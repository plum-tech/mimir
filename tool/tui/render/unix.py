import curses
import shutil
from typing import Optional

import numpy as np

from .canvas import Canvas, Renderer, FG, BG


def toColorPair(fg: int, bk: int) -> int: return bk | (fg << 3)


# noinspection DuplicatedCode
class UnixCanvas(Canvas):

    def __init__(self, width: int, height: int):
        self._sizeX = width
        self._sizeY = height
        self.char: np.ndarray | None = None
        self.fg: np.ndarray | None = None
        self.bg: np.ndarray | None = None
        self.dirty = False

    def setChar(self, x: int, y: int, char: str):
        sizeX = self.sizeX
        sizeY = self.sizeY
        if 0 <= x < sizeX and 0 <= y < sizeY:
            self.char[x * sizeY + y] = char
            self.dirty = True

    def setColor(self, x: int, y: int, *, fg: int = None, bg: int = None):
        sizeX = self.sizeX
        sizeY = self.sizeY
        if 0 <= x < sizeX and 0 <= y < sizeY:
            if fg is not None:
                self.fg[x * sizeY + y] = fg
                self.dirty = True
            if bg is not None:
                self.bg[x * sizeY + y] = bg
                self.dirty = True

    def getColor(self, x: int, y: int) -> tuple[int, int] | None:
        sizeX = self.sizeX
        sizeY = self.sizeY
        if 0 <= x < sizeX and 0 <= y < sizeY:
            return self.fg[x * sizeY + y], self.bg[x * sizeY + y]
        return None

    def getChar(self, x: int, y: int) -> str | None:
        sizeX = self.sizeX
        sizeY = self.sizeY
        if 0 <= x < sizeX and 0 <= y < sizeY:
            return self.char[x * sizeY + y]
        return None

    @property
    def sizeX(self) -> int:
        return self._sizeX

    @property
    def sizeY(self) -> int:
        return self._sizeY

    @property
    def shouldRerender(self) -> bool:
        return self.dirty

    def renderOn(self, window: curses.window):
        sizeX = self.sizeX
        sizeY = self.sizeY
        char = self.char
        fg = self.fg
        bg = self.bg
        for y in range(sizeY):
            for x in range(sizeX):
                pos = x * sizeY + y
                window.addstr(x, y, char[pos],
                              curses.color_pair(toColorPair(fg[pos], bg[pos])))


# noinspection DuplicatedCode
class UnixRenderer(Renderer):
    def __init__(self, window: curses.window):
        self.window = window
        self.needRegen = False
        self.last: Optional[UnixCanvas] = None

    def initialize(self):
        pass

    # noinspection PyMethodMayBeStatic
    def regenCanvas(self) -> UnixCanvas:
        size = shutil.get_terminal_size()
        sizeX, sizeY = size.columns, size.lines
        c = UnixCanvas(sizeX, sizeY)
        c.char = np.full(sizeX * sizeY, " ", dtype=str)
        c.fg = np.full(sizeX * sizeY, 0, dtype=int)
        c.bg = np.full(sizeX * sizeY, toColorPair(FG.White, BG.Black), dtype=int)
        return c

    def onResize(self):
        self.needRegen = True

    def getCanvas(self) -> Canvas:
        canvas = self.last
        if canvas is None or self.needRegen:
            canvas = self.regenCanvas()
            self.needRegen = False
        return canvas

    def render(self, canvas: Canvas):
        if isinstance(canvas, UnixCanvas):
            canvas.renderOn(self.window)
            self.window.refresh()

    def dispose(self):
        pass
