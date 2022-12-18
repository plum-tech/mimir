import platform

sysinfo = platform.system()


def test_renderer():
    from timer import Timer
    from datetime import datetime
    from render.canvas import FG, BG
    from render import setupColors
    setupColors()
    if sysinfo == "Windows":
        from render.win import WinRender
        renderer = WinRender()
    else:
        renderer = None
    renderer.initialize()
    canvas = renderer.getCanvas()
    start = datetime.now()
    x, y = 0, 0
    tps = Timer.byFps(10)
    tps.reset()
    try:
        while (datetime.now() - start).seconds <= 3:
            canvas.setColor(x, y, bg=BG.White)
            canvas.setChar(x, y, char="a")
            x += 1
            y += 1
            if canvas.shouldRerender:
                renderer.render(canvas)
            tps.delay()
    finally:
        renderer.dispose()


if __name__ == '__main__':
    test_renderer()
