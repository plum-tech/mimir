import os
from datetime import datetime
from pathlib import Path
from typing import Union, Iterable, Callable


class Pathable:
    path: Path

    def __init__(self, path: Union[str, Path, "Pathable"]):
        if isinstance(path, Path):
            self.path = path
        elif isinstance(path, Pathable):
            self.path = path.path
        else:
            self.path = Path(path)

    def __eq__(self, other) -> bool:
        if isinstance(other, str):
            return self.path.absolute() == Path(other).absolute()
        elif isinstance(other, Pathable):
            return self.path.absolute() == other.path.absolute()
        elif isinstance(other, Path):
            return self.path.absolute() == other.absolute()
        return False

    def __repr__(self):
        return repr(self.path)

    def __str__(self):
        return str(self.path)

    @property
    def raw(self) -> str:
        return str(self.path)

    @property
    def name(self) -> str:
        return self.path.name


class FileStat:
    def __init__(self, stat: os.stat_result):
        self.stat = stat

    @property
    def modify_time(self) -> float:
        """
        :return: time of last modification
        """
        return self.stat.st_mtime

    @property
    def access_time(self) -> float:
        """
        :return: time of last access
        """
        return self.stat.st_atime

    @property
    def file_size(self) -> int:
        """
        :return: file size in bytes
        """
        return self.stat.st_size


# noinspection SpellCheckingInspection,PyBroadException
class File(Pathable):
    logger = None

    def exists(self):
        return self.path.is_file()

    def __eq__(self, other) -> bool:
        if isinstance(other, str):
            return self.path.absolute() == Path(other).absolute()
        elif isinstance(other, File):
            return self.path.absolute() == other.path.absolute()
        elif isinstance(other, Path):
            return self.path.absolute() == other.absolute()
        return False

    @property
    def parent(self) -> "Directory":
        return Directory(self.path.absolute().parent)

    @property
    def extension(self) -> str:
        return self.path.suffix

    @property
    def extensions(self) -> list[str]:
        return self.path.suffixes

    @property
    def name_without_extension(self) -> str:
        return self.path.stem

    def extendswith(self, extension: str) -> bool:
        if not extension.startswith("."):
            extension = f".{extension}"
        return self.extension == extension

    def endswith(self, ending: str) -> bool:
        return str(self.path).endswith(ending)

    @staticmethod
    def cast(path: Union[str, Path, "File"]) -> "File":
        if isinstance(path, File):
            return path
        else:
            return File(path)

    def read(self, mode="r", silent=False) -> str:
        with open(self.raw, mode=mode, encoding="UTF-8") as f:
            File.log(f"file[{self.path}] was read.", silent=silent)
            return f.read()

    def try_read(self, mode="r", fallback: str | None = None, silent=False) -> None | str:
        if self.exists():
            try:
                return self.read(mode, silent=silent)
            except:
                File.log(f"file[{self.path}] can't be read.", silent=silent)
                return fallback
        else:
            File.log(f"file[{self.path}] isn't a file to read.", silent=silent)
            return fallback

    def write(self, content: str, mode="w", silent=False):
        if not self.exists():
            File.log(f"file[{self.path}] will be created for writing.", silent=silent)
        with open(self.raw, mode=mode, encoding="UTF-8") as f:
            f.write(content)
            File.log(f"file[{self.path}] was written smth.", silent=silent)

    def append(self, content: str, mode="a", silent=False):
        self.write(content, mode, silent)

    def ensure(self):
        self.parent.ensure()

    def delete(self, silent=False) -> bool:
        if self.exists():
            try:
                self.path.unlink(missing_ok=True)
                File.log(f"file[{self.path}] was deleted.", silent=silent)
                return True
            except Exception as e:
                File.log(f"file[{self.path}] can't deleted.", e, silent=silent)
                return False
        else:
            File.log(f"file[{self.path}] doesn't exists or has been deleted.", silent=silent)
            return True

    @staticmethod
    def log(*args, **kwargs):
        silent = kwargs["silent"] if "silent" in kwargs else False
        if File.logger is not None and not silent:
            File.logger.log(*args)

    @property
    def stat(self) -> FileStat:
        return FileStat(os.stat(self.raw))

    @property
    def modify_time(self) -> float:
        """
        :return: time of last modification
        """
        return os.stat(self.raw).st_mtime

    @property
    def modify_datetime(self) -> datetime:
        """
        :return: time of last modification
        """
        return datetime.fromtimestamp(self.modify_time)

    @property
    def access_time(self) -> float:
        """
        :return: time of last access
        """
        return os.stat(self.path).st_atime

    @property
    def access_datetime(self) -> datetime:
        """
        :return: time of last access
        """
        return datetime.fromtimestamp(self.access_time)

    @property
    def file_size(self) -> int:
        """
        :return: file size in bytes
        """
        return os.stat(self.raw).st_size


# noinspection SpellCheckingInspection
class Directory(Pathable):
    logger = None

    def exists(self):
        return self.path.exists()

    @property
    def parent(self) -> "Directory":
        return Directory(self.path.absolute().parent)

    def lists(self) -> tuple[list[File], list["Directory"]]:
        files = []
        dirs = []
        for f in self.path.iterdir():
            if f.is_file():
                files.append(self.subfi(f))
            elif f.is_dir():
                dirs.append(self.subdir(f))
        return files, dirs

    def lists_fis(self) -> list[File]:
        res = []
        for f in self.path.iterdir():
            if f.is_file():
                res.append(self.subfi(f))
        return res

    def lists_dirs(self) -> list["Directory"]:
        res = []
        for f in self.path.iterdir():
            if f.is_dir():
                res.append(self.subdir(f))
        return res

    def listing_fis(self) -> Iterable[File]:
        for f in self.path.iterdir():
            if f.is_file():
                yield self.subfi(f)

    def listing_dirs(self) -> Iterable["Directory"]:
        for f in self.path.iterdir():
            if f.is_dir():
                yield self.subdir(f)

    def subfi(self, *name) -> File:
        return File(self.path.joinpath(*name))

    def createfi(self, *name) -> File:
        fi = self.subfi(*name)
        self.ensure()
        fi.write("")
        return fi

    def createdir(self, *name) -> "Directory":
        folder = self.subdir(*name)
        folder.ensure()
        return folder

    def subdir(self, *name) -> "Directory":
        return Directory(self.path.joinpath(*name))

    def sub_isdir(self, *name) -> bool:
        return self.path.joinpath(*name).is_dir()

    def sub_isfi(self, *name) -> bool:
        return self.path.joinpath(*name).is_file()

    @staticmethod
    def cast(path: Union[str, Path, "Directory"]) -> "Directory":
        if isinstance(path, Directory):
            return path
        else:
            return Directory(path)

    def ensure(self, silent=False) -> "Directory":
        if not self.path.exists():
            self.path.mkdir(parents=True, exist_ok=True)
            Directory.log(f"dir[{self.path}] was created.", silent=silent)
        return self

    def delete(self, silent=False) -> bool:
        if self.path.is_dir():
            try:
                self.path.unlink(missing_ok=True)
                Directory.log(f"dir[{self.path}] was deleted.", silent=silent)
                return True
            except Exception as e:
                Directory.log(f"dir[{self.path}] can't deleted.", e, silent=silent)
                return False
        else:
            Directory.log(f"dir[{self.path}] doesn't exists or has been deleted.", silent=silent)
            return True

    @staticmethod
    def log(*args, **kwargs):
        silent = kwargs["silent"] if "silent" in kwargs else False
        if Directory.logger is not None and not silent:
            Directory.logger.log(*args)

    def walking(self, when: Callable[[File], bool] = lambda _: True) -> Iterable[File]:
        for root, dirs, files in os.walk(self.path, topdown=False):
            for name in files:
                fi = File(Path(root, name))
                if when(fi):
                    yield fi

    @property
    def isroot(self):
        return self.path.absolute() == self.path.absolute().parent

    def __eq__(self, other) -> bool:
        if isinstance(other, str):
            return self.path.absolute() == Path(other).absolute()
        elif isinstance(other, Directory):
            return self.path.absolute() == other.path.absolute()
        elif isinstance(other, Path):
            return self.path.absolute() == other.absolute()
        return False
