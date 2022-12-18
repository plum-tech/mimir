import platform

system_type = platform.system()

isWindows = platform.system() == "Windows"
isUnix = not isWindows


def setup():
    if isWindows:
        pass
    else:
        import curses
        curses.noecho()
        curses.cbreak()


def dispose():
    if isWindows:
        pass
    else:
        import curses
        curses.endwin()


# noinspection PyUnresolvedReferences
def createCursesWindow() -> "curses.window":
    import curses
    w = curses.initscr()
    w.keypad(True)
    w.nodelay(True)
    return w
