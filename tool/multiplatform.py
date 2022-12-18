import platform

system_type = platform.system()

isWindows = platform.system() == "Windows"
isUnix = not isWindows


def envvar(var: str):
    if isWindows:
        return f"%{var}%"
    else:
        return f"${var}"
