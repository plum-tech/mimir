import subprocess


def gen_110n(work_dir: str):
    subprocess.Popen(args=["flutter", "gen-l10n"],
                     bufsize=-1, shell=True,
                     cwd=work_dir,
                     stdout=subprocess.DEVNULL,
                     stderr=subprocess.DEVNULL)
