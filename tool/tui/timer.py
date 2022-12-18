from time import time, sleep


def nowMs() -> int:
    return int(round(time() * 1000))


def nowSec() -> float:
    return time()


class Timer:
    def __init__(self, interval: float):
        self.start_time = 0
        self.interval = interval

    @staticmethod
    def byMs(ms: float):
        return Timer(ms / 1000)

    @staticmethod
    def byFps(fps: float):
        return Timer(1 / fps)

    def reset(self):
        self.start_time = nowSec()

    def delay(self):
        duration = nowSec() - self.start_time
        sleep_time = self.interval - duration
        if sleep_time > 0:
            sleep(sleep_time)
        self.reset()

    @property
    def isEnd(self) -> bool:
        duration = nowSec() - self.start_time
        return self.interval - duration >= 0
