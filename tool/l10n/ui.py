class Terminal:

    def print(self, *args):
        print(*args)

    def log(self, *args):
        pass

    def input(self, prompt: str) -> str:
        return input(prompt)

    def print_log(self, *args):
        self.print(*args)
        self.log(*args)


terminal = Terminal()