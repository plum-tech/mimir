from datetime import datetime

from filesystem import File


class Logger:
    """
    Logger is a protocol, you don't need to inherit it,
    So DO NOT check the hierarchy of any logger.
    """

    def log(self, *args):
        pass


class FileLogger(Logger):

    def __init__(self, path: str | File):
        self.path = path
        self.fi = None

    def get_fi(self) -> File:
        if self.fi is None:
            self.fi = File.cast(self.path)
        return self.fi

    def log(self, *args):
        content = ' '.join(str(arg) for arg in args)
        now = datetime.now().strftime("%H:%M:%S")
        content = f"[{now}] {content}\n"
        logfi = File.cast(self.path)
        if logfi.ensure():
            try:
                logfi.append(content, silent=True)
            except:
                pass


class StdoutLogger(Logger):

    def log(self, *args):
        content = ' '.join(str(arg) for arg in args)
        print(content)
