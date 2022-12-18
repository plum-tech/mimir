from typing import Union, Optional, Sequence

from filesystem import File, Pathable

import subprocess

from runner import Runner


class DartFi(File):
    sourcename: str

    def __init__(self, path: Union[str, Pathable]):
        super().__init__(path)
        name = self.name
        if name.endswith(".g.dart"):
            self.sourcename = name.removesuffix(".g.dart")
        else:
            self.sourcename = name.removesuffix(".dart")

    @property
    def is_gen(self) -> bool:
        return self.endswith(".g.dart")

    @staticmethod
    def is_dart(fi: File) -> bool:
        return fi.extendswith("dart")

    @staticmethod
    def cast(fi: File) -> Optional["DartFi"]:
        if DartFi.is_dart(fi):
            return DartFi(fi)
        else:
            return None


class DartFormatConf:
    def __init__(self):
        self.length = 120


class DartRunner:
    def __init__(self, runner: Runner):
        self.runner = runner

    def format(self, config: DartFormatConf) -> subprocess.Popen:
        args = ["dart", "format", "."]
        length = config.length
        if length is not None:
            args.append("-l")
            args.append(str(length))
        return self.runner.run(seq=args)

    def flutter(self, args: Sequence[str]) -> subprocess.Popen:
        return self.runner.run(seq=["flutter"] + list(args))
