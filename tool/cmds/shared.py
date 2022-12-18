import subprocess
from cmd import CmdContext


def print_stdout(ctx: CmdContext, proc: subprocess.Popen):
    for line in proc.stdout:
        ctx.term << line.decode("utf-8").splitlines()[0]
    for line in proc.stderr:
        ctx.term << ctx.style.error(line.decode("utf-8").splitlines()[0])
