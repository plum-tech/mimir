from io import StringIO
from typing import Any, Sequence


# noinspection SpellCheckingInspection
class Terminal:
    def __init__(self, logger=None):
        self.logger = logger
        self.logging = LoggerWrapper(self)
        self.both = BothWrapper(self)

    @property
    def has_logger(self):
        return self.logger is not None

    def print(self, *args):
        print(*args)

    def log(self, *args):
        if self.logger is not None:
            self.logger.log(*args)

    def input(self, prompt: str) -> str:
        return input(prompt)

    def print_log(self, *args):
        self.print(*args)
        self.log(*args)

    def __lshift__(self, other: Sequence | Any):
        if isinstance(other, str):
            self.print(other)
        elif isinstance(other, Sequence):
            for e in other:
                self.print(e)
        else:
            self.print(other)


class LoggerWrapper:
    def __init__(self, inner: Terminal):
        self.inner = inner

    def log(self, *args):
        self.inner.log(*args)

    def __lshift__(self, other: Sequence | Any):
        if isinstance(other, str):
            self.inner.log(other)
        elif isinstance(other, Sequence):
            for e in other:
                self.inner.log(e)
        else:
            self.inner.log(other)


class BothWrapper:
    def __init__(self, inner: Terminal):
        self.inner = inner

    def print(self, *args):
        self.inner.print(*args)

    def log(self, *args):
        self.inner.log(*args)

    def __lshift__(self, other: Sequence | Any):
        if isinstance(other, str):
            self.inner.log(other)
            self.inner.print(other)
        elif isinstance(other, Sequence):
            for e in other:
                self.inner.log(e)
                self.inner.print(e)
        else:
            self.inner.log(other)
            self.inner.print(other)


# noinspection SpellCheckingInspection
class BashTerminal(Terminal):

    def print(self, *args):
        print("|>", *args)

    def log(self, *args):
        self.logger.log(*args)

    def input(self, prompt: str) -> str:
        return input(f"|>  % {prompt}")

    def print_log(self, *args):
        self.print(*args)
        self.log(*args)


# noinspection SpellCheckingInspection
class BashTerminalWrapper(Terminal):
    """
    An example of wrapping a ternimal
    """

    def __init__(self, inner: Terminal):
        super().__init__()
        self.inner = inner

    @property
    def has_logger(self):
        return False

    def print(self, *args):
        self.inner.print("|>", *args)

    def log(self, *args):
        self.inner.log(*args)

    def input(self, prompt: str) -> str:
        return self.inner.input(f"|>  %{prompt}")

    def print_log(self, *args):
        self.print(*args)
        self.log(*args)


_lines: dict[int, str] = {}


def _get_line(length: int):
    length = max(0, length)
    if length in _lines:
        return _lines[length]
    else:
        with StringIO() as s:
            for i in range(length):
                s.write("━")
            res = s.getvalue()
            _lines[length] = res
            return res


def _line(self, length: int):
    self.print(_get_line(length))


Terminal.line = _line
