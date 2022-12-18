from io import StringIO
from typing import Iterator, Optional

import numpy as np
import win32con
import win32console
from win32console import PyConsoleScreenBufferType, PyCOORDType

from .canvas import Renderer, Canvas, FG, BG

"""
|---x--------->
| 0 1 2 3 4 5 6
y 1 2 3 4 5 6 7
| 2 3 4 5 6 7 8
v 3 4 5 6 7 8 9
"""


def mixColor(fg: int, bk: int) -> int: return fg | bk


class WinCanvas(Canvas):

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

    def composeCharsToRender(self) -> str:
        char = self.char
        sizeX = self.sizeX
        sizeY = self.sizeY
        with StringIO() as s:
            for y in range(sizeY):
                for x in range(sizeX):
                    s.write(char[x * sizeY + y])
            return s.getvalue()

    def iterAttributes(self) -> Iterator[int]:
        fg = self.fg
        bg = self.bg
        sizeX = self.sizeX
        sizeY = self.sizeY
        for y in range(sizeY):
            for x in range(sizeX):
                pos = x * sizeY + y
                yield mixColor(fg[pos], bg[pos])


class WinRender(Renderer):
    def __init__(self):
        super().__init__()
        self.buffer: Optional[PyConsoleScreenBufferType] = None
        self.needRegen = False
        self.last: Optional[WinCanvas] = None

    def initialize(self):
        pass

    def onResize(self):
        self.needRegen = True

    def render(self, canvas: Canvas):
        if isinstance(canvas, WinCanvas):
            buf = self.buffer
            buf.WriteConsoleOutputCharacter(
                canvas.composeCharsToRender(), PyCOORDType(0, 0)
            )
            buf.WriteConsoleOutputAttribute(
                canvas.iterAttributes(), PyCOORDType(0, 0)
            )

    def regenCanvas(self) -> WinCanvas:
        buf = win32console.CreateConsoleScreenBuffer(
            DesiredAccess=win32con.GENERIC_READ | win32con.GENERIC_WRITE,
            ShareMode=0, SecurityAttributes=None, Flags=1)
        self.buffer = buf
        buf.SetConsoleActiveScreenBuffer()
        info = buf.GetConsoleScreenBufferInfo()
        size = info["Size"]
        sizeX, sizeY = size.X, size.Y
        c = WinCanvas(sizeX, sizeY)
        c.char = np.full(sizeX * sizeY, " ", dtype=str)
        c.fg = np.full(sizeX * sizeY, 0, dtype=int)
        c.bg = np.full(sizeX * sizeY, mixColor(FG.White, BG.Black), dtype=int)
        return c

    def getCanvas(self) -> WinCanvas:
        canvas = self.last
        if canvas is None or self.needRegen:
            canvas = self.regenCanvas()
            self.needRegen = False
        return canvas

    def dispose(self):
        self.buffer.Close()
