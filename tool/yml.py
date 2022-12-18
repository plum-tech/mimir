import ruamel.yaml as yaml

shared = yaml.YAML()


def load(content: str):
    return shared.load(content)
