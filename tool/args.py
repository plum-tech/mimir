import re
import shlex
from io import StringIO
from typing import Sequence, Iterable, Optional, Union, TypeVar, Callable, Generic

from indexed import IndexedOrderedDict

_empty_args = ()
T = TypeVar("T")


class Arg:
    def __init__(self, full: str, key: str, value: str = None):
        self.full = full
        self.key = key.strip()
        if value is not None:
            value = value.strip()
        self.value = value
        self.parent: Optional["Args"] = None
        self.parent_index = 0

    def __copy__(self) -> "Arg":
        new = Arg(full=self.full, key=self.key, value=self.value)
        new.parent = self.parent
        new.parent_index = self.parent_index
        return new

    def copy(self, **kwargs) -> "Arg":
        cloned = self.__copy__()
        for k, v in kwargs.items():
            setattr(cloned, k, v)
        return cloned

    @property
    def name(self) -> str:
        return self.key

    @property
    def ispair(self) -> bool:
        return self.value is not None

    def startswith(self, prefix: str) -> bool:
        return self.key.startswith(prefix)

    def endswith(self, suffix: str) -> bool:
        return self.key.endswith(suffix)

    def removeprefix(self, prefix) -> str:
        return self.key.removeprefix(prefix)

    def removesuffix(self, suffix) -> str:
        return self.key.removesuffix(suffix)

    @staticmethod
    def by(arg: str) -> "Arg":
        parts = arg.split("=")
        if len(parts) == 1:
            return Arg(full=arg, key=parts[0])
        else:
            if len(parts[0]) == 0:
                return Arg(full=arg, key=parts[1])
            else:
                return Arg(full=arg, key=parts[0], value=parts[1])

    def __str__(self):
        return self.full

    def __repr__(self):
        return str(self)

    @property
    def root(self) -> Optional["Args"]:
        if self.parent is None:
            return None
        return self.parent.root

    @property
    def raw_index(self) -> int:
        if self.parent is None:
            return 0
        else:
            return self.parent_index + self.parent.total_loffset

    # noinspection PyProtectedMember
    def __add__(self, args: "Args") -> "Args":
        """
        plus operator overloading
        :param args:  added at last
        :return: a new Args object with no parent
        """
        inner = list(args._args)
        inner.insert(0, self)
        res = Args.lateinit()
        res._args = res.copy_args(inner)
        return res

    def __eq__(self, b):
        if isinstance(b, Arg):
            return self.key == b.key and \
                   self.value == b.value and \
                   self.parent == b.parent and \
                   self.parent_index == b.parent_index
        else:
            return False


class ArgPosition:
    def __init__(self, start: int, end: int):
        self.start = start
        self.end = end


TArg = TypeVar("TArg", bound=Arg)


# noinspection SpellCheckingInspection
class Args(Iterable[TArg]):
    """
    Args is a pure data class whose fields are immutable
    and all methods are pure that return a new Args object.

    You should never change the inner list [Args.ordered].
    """

    def __init__(self, args: Sequence[Arg]):
        """
        :param args: [lateinit] whose parent and parent_index should be initialized to this.
        """
        self._args = args
        self.parent: Args | None = None
        self.loffset = 0
        """
        the left offset relative to the parent
        """
        self.roffset = 0
        """
        the right offset relative to the parent
        """

    @staticmethod
    def empty() -> "Args":
        return Args(_empty_args)

    def sub(self, start: int, end: int) -> "Args":
        """
        :param start: included
        :param end: excluded
        """
        subargs = []
        sub = Args.lateinit()
        for i, arg in enumerate(self._args[start:end]):
            subargs.append(arg.copy(parent=sub, parent_index=i))
        sub._args = subargs
        sub.parent = self
        sub.loffset = start
        sub.roffset = len(self._args) - end
        return sub

    def __getitem__(self, item: slice | int) -> Union["Args", Arg, None]:
        size = len(self._args)
        if size == 0:
            if isinstance(item, slice) and item.start is None and item.stop is None and item.step is None:
                return self.sub_empty()
            elif isinstance(item, int):
                return None
            else:
                return self.sub_empty()
        if isinstance(item, slice):
            start = 0 if item.start is None else item.start
            start = max(0, start)
            end = size if item.stop is None else item.stop
            end = min(end, size)
            if start < end:
                return self.sub(start, end)
            else:
                return self.sub_empty()
        elif isinstance(item, int):
            index = item % size
            return self._args[index]
        raise Exception(f"unsupported type {type(item)}")

    @property
    def total_loffset(self) -> int:
        total = 0
        cur = self
        while cur is not None:
            total += cur.loffset
            cur = cur.parent
        return total

    @property
    def total_roffset(self) -> int:
        total = 0
        cur = self
        while cur is not None:
            total += cur.roffset
            cur = cur.parent
        return total

    @staticmethod
    def by(*, full: str = None, seq: Sequence[str] = None) -> "Args":
        if full is not None:
            args = shlex.split(full)
        elif seq is not None:
            args = seq
        else:
            raise ValueError("neither full nor seq is given")
        res = Args.lateinit()
        res._args = res.gen_args(args)
        return res

    def sub_empty(self) -> "Args":
        sub = Args(_empty_args)
        sub.parent = self
        return sub

    @staticmethod
    def lateinit() -> "Args":
        return Args(_empty_args)

    def gen_args(self, raw: Sequence[str]) -> Sequence[Arg]:
        res = []
        for i, s in enumerate(raw):
            arg = Arg.by(s)
            arg.parent = self
            arg.parent_index = i
            res.append(arg)
        return res

    def copy_args(self, args: Sequence[Arg]) -> Sequence[Arg]:
        res = []
        for i, arg in enumerate(args):
            res.append(arg.copy(parent=self, parent_index=i))
        return res

    @property
    def size(self):
        return len(self)

    @property
    def isempty(self) -> bool:
        return len(self) == 0

    def __len__(self):
        return len(self._args)

    @property
    def hasmore(self):
        return self.size > 0

    def poll(self) -> tuple[Arg | None, "Args"]:
        """
        consume the head
        """
        if len(self._args) == 0:
            return None, self.sub_empty()
        else:
            return self[0], self[1:]

    def polling(self) -> Iterable[tuple[Arg, "Args"]]:
        """
        consuming the head
        """
        for i in range(len(self._args)):
            yield self[i], self[i + 1:]

    def pop(self) -> tuple[Arg | None, "Args"]:
        """
        consume the last
        """
        if len(self._args) == 0:
            return None, self.sub_empty()
        else:
            return self[-1], self[0:-1]

    def popping(self) -> Iterable[tuple[Arg, "Args"]]:
        """
        consuming the last
        """
        for i in range(len(self._args)):
            yield self[-i], self[0:-i]

    def __add__(self, arg: Arg | str) -> "Args":
        """
        plus operator overloading
        :param arg: added at last
        :return: a new Args object with no parent
        """
        if isinstance(arg, str):
            arg = Arg.by(arg)
        inner = list(self._args)
        inner.insert(0, arg)
        res = Args.lateinit()
        res._args = res.copy_args(inner)
        return res

    def __iter__(self):
        return iter(self._args)

    def peekhead(self) -> Arg | None:
        if self.hasmore:
            return self[0]
        else:
            return None

    def located_full(self, target: int) -> tuple[str, ArgPosition]:
        if self.isroot:
            return _join_pos(self._args, target, mapping=str)
        else:
            raise Exception(f"{self} isn't a root args")

    def full(self) -> str:
        if self.isroot:
            return _join(self._args, mapping=str)
        else:
            raise Exception(f"{self} isn't a root args")

    def compose(self) -> Sequence[str]:
        return tuple(arg.full for arg in self._args)

    def __str__(self):
        return _join(self._args, mapping=str)

    def __repr__(self):
        return str(self)

    @property
    def isroot(self):
        return self.parent is None

    @property
    def root(self) -> Optional["Args"]:
        cur = self
        while cur.parent is not None:
            cur = cur.parent
        return cur


def _join(split_command, mapping: Callable[[T], str] = None):
    """Return a shell-escaped string from *split_command*."""
    return ' '.join(_quote(arg) if mapping is None else _quote(mapping(arg)) for arg in split_command)


def _join_pos(split_command: Sequence[T], target: int, mapping: Callable[[T], str] = None) -> tuple[str, ArgPosition]:
    """
    Return a tuple:

    [0] = shell-escaped string from *split_command*

    [1] = the *target* argument position
    """
    size = len(split_command)
    start = 0
    end = 0
    counter = 0
    with StringIO() as s:
        for i, arg in enumerate(split_command):
            if i == target:
                start = counter
            if mapping is not None:
                arg = mapping(arg)
            quoted = _quote(arg)
            counter += len(quoted)
            if i == target:
                end = counter
            s.write(quoted)
            if i < size - 1:
                s.write(' ')
                counter += 1
        return s.getvalue(), ArgPosition(start, end)


_find_unsafe = re.compile(r'[^\w@%+=:,./-]', re.ASCII).search


def _quote(s):
    """Return a shell-escaped version of the string *s*."""
    if not s:
        return "''"
    if _find_unsafe(s) is None:
        return s

    # use single quotes, and put single quotes into double quotes
    # the string $'b is then quoted as '$'"'"'b'
    return "'" + s.replace("'", "'\"'\"'") + "'"


def split_multicmd(full: Args, separator="+") -> Sequence[Args]:
    """
    split multi-cmd by [separator].
    :return: a list of cmd args with no parent
    """
    res = []
    queue = []
    args = Args.lateinit()
    total = 0
    for i, arg in enumerate(full):
        if not arg.ispair and arg.key == separator:
            if len(queue) > 0:
                args._args = queue
                res.append(args)
                args = Args.lateinit()
                queue = []
        else:
            queue.append(arg.copy(parent=args, parent_inex=total - i))
        total += 1
    if len(queue) > 0:
        args._args = queue
        res.append(args)
    return res


def _get_or(di: dict, key, fallback) -> T:
    if key in di:
        return di[key]
    else:
        v = fallback()
        di[key] = v
        return v


def _append_group(di, group, args):
    grouped: list[Args] = _get_or(di, group, fallback=list)
    grouped.append(args)


class ArgsList:
    """
    ArgsList can't be empty.
    """

    def __init__(self, *, first: Args):
        """
        :param first: inevitably initialize the ArgsList with at least one Args
        """
        self.argslist: list[Args] = [first]
        """
        all args in the list.
        """

    def __getitem__(self, index: int) -> Args:
        return self.argslist[index]

    def add(self, args: Args):
        """
        add the args only if it's not empty
        """
        if not args.isempty:
            self.argslist.append(args)

    @property
    def not_only_one(self) -> Arg | None:
        """
        check whether the argslist has 2+ args.

        You can directly check the return value in the if-statement as a bool
        :return: the first arg in the second args if argslist has 2+,
         otherwise, None will be returned.
        """
        if len(self.argslist) == 1:
            return None
        else:
            return self.argslist[1][0]

    def __str__(self):
        return str(self.argslist)

    def __repr__(self):
        return repr(self.argslist)

    def compose(self) -> list[Arg]:
        return flatten_args(self.argslist)


class ArgGroup:
    def __init__(self, name: str, raw: Arg):
        self.name = name
        self.raw = raw

    @staticmethod
    def by(raw: Arg, prefix: str = "--") -> "ArgGroup":
        return ArgGroup(raw.key.removeprefix(prefix), raw)


class ArgsGroups:
    def __init__(self):
        self.name2argslist: dict[str, ArgsList] = IndexedOrderedDict()
        """
        group name corresponds to all args in the group.
        """
        self.name2group: dict[str, Arg] = IndexedOrderedDict()
        """
        group name corresponds to its arg.
        Only the first-come group leader arg is recorded. 
        """
        self.ungrouped: Args | None = None
        """
        None means there is nothing ungrouped.
        """

    def add_group(self, leader: Arg, body: Args, head: str = "--"):
        name = leader.key.removeprefix(head)
        if name not in self.name2group:
            self.name2group[name] = leader
        if not body.isempty:
            if name not in self.name2argslist:
                argslist = ArgsList(first=body)
                self.name2argslist[name] = argslist
            else:
                self.name2argslist[name].add(body)

    def has_ungrouped(self) -> bool:
        return self.ungrouped is not None

    @property
    def groups_size(self) -> int:
        return len(self.name2group)

    @property
    def argslist_size(self) -> int:

        return len(self.name2argslist)

    def get_args(self, name: str) -> Sequence[Arg]:
        if name in self.name2argslist:
            return self.name2argslist[name].compose()
        else:
            return ()

    # noinspection PyUnresolvedReferences
    def __getitem__(self, item: str | int) -> Arg:
        if isinstance(item, str):
            return self.name2group[item]
        else:
            return self.name2group.values()[item]

    def has(self, *, group: str = None, args: str = None) -> bool:
        if group is not None:
            return group in self.name2group
        elif args is not None:
            return args in self.name2argslist
        else:
            raise Exception('no "group" or "args" given')

    def __str__(self):
        with StringIO() as s:
            s.write("[")
            if self.ungrouped is not None:
                s.write("ungrouped")
                s.write(",")
            size = len(self.name2group)
            for i, group_name in enumerate(self.name2group.keys()):
                s.write(group_name)
                if i < size - 1:
                    s.write(",")
            s.write("]")
            return s.getvalue()

    def __repr__(self):
        return self.__str__()


def it_ungrouped(args: Args, group_head: str = "--") -> Iterable[Arg]:
    for arg in args:
        if not arg.startswith(group_head):
            yield arg
        else:
            break


def it_grouped(args: Args, group_head: str = "--") -> Iterable[Arg]:
    enable = False
    for arg in args:
        if enable or arg.startswith(group_head):
            enable = True
            yield arg


def separate_grouped_or_not(args: Args, group_head: str = "--") -> tuple[Args, Args]:
    """
    :return: grouped, ungrouped
    """
    for i, arg in enumerate(args):
        if not arg.ispair and arg.startswith(group_head):
            return args[i:], args[0:i]
    return args.sub_empty(), args[0:]


def indexing_groups(grouped: Args, group_head: str = "--") -> tuple[int, int]:
    start = 0
    init_group = grouped[0]
    cur_group = init_group
    for i, arg in enumerate(grouped):
        if not arg.ispair and arg.startswith(group_head):
            if cur_group != arg:
                cur_group = arg
                yield start, i
                start = i
    if init_group == cur_group:
        yield 0, grouped.size
    else:
        yield start, grouped.size


def group_args2(args: Args, group_head: str = "--") -> ArgsGroups:
    """
    grouped by "--xxx" as default.
    """
    groups = ArgsGroups()
    grouped, ungrouped = separate_grouped_or_not(args)
    if ungrouped.size > 0:
        groups.ungrouped = ungrouped
    if grouped.size > 0:
        for start, end in indexing_groups(grouped):
            group_leader = grouped[start]
            group_body = grouped[start + 1:end]
            groups.add_group(group_leader, group_body, group_head)
    return groups


def group_args(args: Args, group_head: str = "--") -> dict[str | None, list[Args]]:
    """
    DEPRECATED, see [group_args2]

    grouped by "--xxx" as default.
    :return: {*group_name:[*matched_args],None:[ungrouped]}
    """
    res = {}
    group = None
    grouped_start = -1
    cur_group_start = 0
    for i, arg in enumerate(args):
        if not arg.ispair and arg.startswith(group_head):
            if grouped_start < 0:
                grouped_start = i
            # it's a group. now group up the former.
            if group is not None:
                # plus 1 to ignore group name itself
                _append_group(res, group, args[cur_group_start + 1:i])
            group = arg.removeprefix(group_head)
            cur_group_start = i
    if group is not None:
        _append_group(res, group, args[cur_group_start + 1:args.size])
    if grouped_start < 0:
        grouped_start = args.size
    _append_group(res, None, args[0:grouped_start])
    return res


def flatten_args(
        argslist: list[Args],
        mapping: Callable[[Arg], T] = lambda arg: arg
) -> list[T]:
    return [(item if mapping is None else mapping(item)) for sublist in argslist for item in sublist]
