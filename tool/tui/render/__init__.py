import platform
from .canvas import FG, BG

system_type = platform.system()


# noinspection DuplicatedCode
def setupColors():
    if system_type == "Windows":
        from win32console import BACKGROUND_RED, BACKGROUND_BLUE, BACKGROUND_GREEN, FOREGROUND_BLUE, FOREGROUND_RED, \
            FOREGROUND_GREEN
        BG.Blue = BACKGROUND_BLUE
        BG.Green = BACKGROUND_GREEN
        BG.Red = BACKGROUND_RED
        BG.Yellow = BACKGROUND_RED | BACKGROUND_GREEN
        BG.Violet = BACKGROUND_RED | BACKGROUND_BLUE
        BG.Cyan = BACKGROUND_BLUE | BACKGROUND_GREEN
        BG.Black = 0
        BG.White = BACKGROUND_RED | BACKGROUND_BLUE | BACKGROUND_GREEN

        FG.Blue = FOREGROUND_BLUE
        FG.Green = FOREGROUND_GREEN
        FG.Red = FOREGROUND_RED
        FG.Yellow = FOREGROUND_RED | FOREGROUND_GREEN
        FG.Violet = FOREGROUND_RED | FOREGROUND_BLUE
        FG.Cyan = FOREGROUND_GREEN | FOREGROUND_BLUE
        FG.Black = 0
        FG.White = FOREGROUND_GREEN | FOREGROUND_BLUE | FOREGROUND_RED

    else:
        from curses import COLOR_RED, COLOR_GREEN, COLOR_BLUE, COLOR_WHITE, COLOR_BLACK, COLOR_YELLOW, COLOR_CYAN, \
            COLOR_MAGENTA
        BG.Blue = COLOR_BLUE
        BG.White = COLOR_WHITE
        BG.Yellow = COLOR_YELLOW
        BG.Green = COLOR_GREEN
        BG.Cyan = COLOR_CYAN
        BG.Red = COLOR_RED
        BG.Violet = COLOR_MAGENTA
        BG.Black = COLOR_BLACK

        FG.Blue = COLOR_BLUE
        FG.White = COLOR_WHITE
        FG.Yellow = COLOR_YELLOW
        FG.Green = COLOR_GREEN
        FG.Cyan = COLOR_CYAN
        FG.Red = COLOR_RED
        FG.Violet = COLOR_MAGENTA
        FG.Black = COLOR_BLACK

    BG.AllColors = [
        BG.Blue, BG.Green, BG.Yellow, BG.Red, BG.Cyan, BG.Violet, BG.White, BG.Black
    ]
    FG.AllColors = [
        FG.Blue, FG.Green, FG.Yellow, FG.Red, FG.Cyan, FG.Violet, FG.White, FG.Black
    ]

    if system_type == "Windows":
        pass
    else:
        from .unix import toColorPair
        import curses
        curses.start_color()
        for fg in FG.AllColors:
            for bk in BG.AllColors:
                pairID = toColorPair(bk, fg)
                if pairID == 0:
                    continue
                curses.init_pair(pairID, fg, bk)
