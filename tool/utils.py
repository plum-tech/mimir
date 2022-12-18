from typing import Generic, TypeVar, Any, Callable, Iterable, Tuple

T = TypeVar("T")


class Ref(Generic[T]):
    def __init__(self, obj=None):
        self.obj = obj

    def deref(self) -> T:
        return self.obj

    def __lshift__(self, other):
        if isinstance(other, Ref):
            return self.obj.__lshift__(other.obj)
        else:
            return self.obj.__lshift__(other)

    def __rshift__(self, other):
        if isinstance(other, Ref):
            return self.obj.__rshift__(other.obj)
        else:
            return self.obj.__rshift__(other)

    def __add__(self, other):
        if isinstance(other, Ref):
            return self.obj.__add__(other.obj)
        else:
            return self.obj.__add__(other)

    def __sub__(self, other):
        if isinstance(other, Ref):
            return self.obj.__sub__(other.obj)
        else:
            return self.obj.__sub__(other)

    def __mul__(self, other):
        if isinstance(other, Ref):
            return self.obj.__mul__(other.obj)
        else:
            return self.obj.__mul__(other)

    def __mod__(self, other):
        if isinstance(other, Ref):
            return self.obj.__mod__(other.obj)
        else:
            return self.obj.__mod__(other)

    def __and__(self, other):
        if isinstance(other, Ref):
            return self.obj.__and__(other.obj)
        else:
            return self.obj.__and__(other)

    def __or__(self, other):
        if isinstance(other, Ref):
            return self.obj.__or__(other.obj)
        else:
            return self.obj.__or__(other)

    def __len__(self):
        return self.obj.__len__()

    def __float__(self):
        return self.obj.__float__()

    def __floor__(self):
        return self.obj.__floor__()

    def __floordiv__(self, other):
        if isinstance(other, Ref):
            return self.obj.__floordiv__(other.obj)
        else:
            return self.obj.__floordiv__(other)

    def __ceil__(self):
        return self.obj.__ceil__()

    def __ge__(self, other):
        if isinstance(other, Ref):
            return self.obj.__ge__(other.obj)
        else:
            return self.obj.__ge__(other)

    def __le__(self, other):
        if isinstance(other, Ref):
            return self.obj.__le__(other.obj)
        else:
            return self.obj.__le__(other)

    def __lt__(self, other):
        if isinstance(other, Ref):
            return self.obj.__lt__(other.obj)
        else:
            return self.obj.__lt__(other)

    def __next__(self):
        return self.obj.__next__()

    def __int__(self):
        return self.obj.__int__()

    def __setitem__(self, key, value):
        if isinstance(value, Ref):
            return self.obj.__setitem__(key, value.obj)
        else:
            return self.obj.__setitem__(key, value)

    def __getitem__(self, item):
        if isinstance(item, Ref):
            return self.obj.__getitem__(item.obj)
        else:
            return self.obj.__getitem__(item)

    def __ne__(self, other: object) -> bool:
        if isinstance(other, Ref):
            return self.obj.__ne__(other.obj)
        else:
            return self.obj.__ne__(other)

    def __str__(self) -> str:
        return self.obj.__str__()

    def __repr__(self) -> str:
        return self.obj.__repr__()

    def __hash__(self) -> int:
        return self.obj.__hash__()

    def __format__(self, format_spec: str) -> str:
        return self.obj.__format__(format_spec)

    def __delattr__(self, name: str) -> None:
        self.obj.__delattr__(name)

    def __sizeof__(self) -> int:
        return self.obj.__sizeof__()

    def __reduce__(self) -> str | Tuple[Any, ...]:
        return self.obj.__reduce__()

    def __reduce_ex__(self, protocol) -> str | Tuple[Any, ...]:
        return self.obj.__reduce_ex__(protocol)

    def __dir__(self) -> Iterable[str]:
        return self.obj.__dir__()

    def __eq__(self, other):
        if isinstance(other, Ref):
            return self.obj.__eq__(other.obj)
        else:
            return self.obj.__eq__(other)

    def __getattr__(self, item):
        return getattr(self.obj, item)

    def __setattr__(self, key, value):
        if key == "obj":
            super(Ref, self).__setattr__("obj", value)
        else:
            setattr(self.obj, key, value)

    def __bool__(self) -> bool:
        return self.obj.__bool__()

    def __iter__(self):
        return self.obj.__iter__()

    def __call__(self, *args, **kwargs):
        return self.obj.__call__(*args, **kwargs)


def useRef(obj=None) -> Any | Ref: return Ref(obj)


# noinspection PyBroadException
def cast_int(s: str) -> int | None:
    try:
        return int(s)
    except:
        return None


# noinspection PyBroadException
def cast_float(s: str) -> float | None:
    try:
        return float(s)
    except:
        return None


true_list = {
    "y", "yes", "true", "yep", "yeah", "ok"
}


def cast_bool(s: str) -> bool:
    return s.lower() in true_list


def flatten(li: Iterable[Iterable[T]], mapping: Callable[[T], Any] = None) -> list[T] | list[Any]:
    return [(item if mapping is None else mapping(item)) for sublist in li for item in sublist]
