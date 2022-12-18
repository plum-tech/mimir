from io import StringIO
from typing import TypeVar, Protocol, runtime_checkable, Callable, Any, Iterator

T = TypeVar("T")


@runtime_checkable
class InputConverter(Protocol[T]):
    bound_type: type

    def from_str(self, raw: str) -> T | None:
        pass

    def to_str(self, raw: T) -> str:
        pass


class EasyConverter(InputConverter):
    def __init__(self, bound_type: type):
        self.bound_type = bound_type

    # noinspection PyBroadException
    def from_str(self, raw: str) -> T | None:
        try:
            return self.bound_type(raw)
        except:
            return None

    def to_str(self, raw: T) -> str:
        return str(raw)


class DirectConverter(InputConverter):
    def __init__(self, bound_type: type):
        self.bound_type = bound_type

    # noinspection PyBroadException
    def from_str(self, raw: str) -> T | None:
        return raw

    def to_str(self, raw: T) -> str:
        return raw


class ListConverter(InputConverter):
    # noinspection PyDefaultArgument
    def __init__(
            self, bound_type: type,
            converter: InputConverter
    ):
        self.bound_type = bound_type
        self.converter = converter

    def from_str(self, raw: str) -> T | None:
        res = []
        if raw.startswith("[") and raw.endswith("]"):
            raw = raw.removeprefix("[").removesuffix("]")
            for elem in raw.split(","):
                res.append(self.converter.from_str(elem))
            return self.bound_type(res)
        else:
            return None

    def to_str(self, raw: T) -> str:
        with StringIO() as s:
            s.write("[")
            size = len(raw)
            for i, elem in enumerate(raw):
                s.write(self.converter.to_str(elem))
                if i < size - 1:
                    s.write(",")
            s.write("]")
            return s.getvalue()


int_cnvt = EasyConverter(int)
float_cnvt = EasyConverter(float)
bool_cnvt = EasyConverter(bool)
str_cnvt = DirectConverter(str)

builtins: dict[type, "InputConverter"] = {
    int: int_cnvt,
    float: float_cnvt,
    bool: bool_cnvt,
    str: str_cnvt,
}
Type2Converters = dict[type, InputConverter]
