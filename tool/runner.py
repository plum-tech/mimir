import shlex
import subprocess
from typing import Sequence

from filesystem import Directory


class Runner:
    def __init__(self, root: Directory):
        self.root = root

    def run(self, *, full: str = None, seq: Sequence[str] = None) -> subprocess.Popen:
        if full is not None:
            args = shlex.split(full)
        elif seq is not None:
            args = seq
        else:
            raise Exception("no full or seq given as command line args")
        return subprocess.Popen(
            args=args,
            bufsize=-1, shell=True,
            cwd=str(self.root),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
