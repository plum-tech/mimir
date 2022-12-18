from dart import DartFi
from filesystem import Directory
from project import Module, Proj, Modules
from ui import Terminal


def load_modules(t: Terminal, proj: Proj):
    modules = Modules(proj)
    for folder in proj.module_folder.listing_dirs():
        name = folder.name
        if name not in proj.unmodules:
            if Module.validate(folder):
                module = load(t, proj, module_name=name, parent=folder)
                modules.name2modules[name] = module
    t.logging << f"modules loaded: [{', '.join(modules.name2modules.keys())}]"
    proj.modules = modules


def load(t: Terminal, proj: Proj, module_name: str, parent: Directory) -> Module:
    """
    :param module_name:
    :param proj:
    :param t:
    :param parent: lib or parent module
    :return:
    :except DuplicateNameCompError: if a component is already here
    """
    module = Module(module_name)
    files, dirs = parent.lists()
    for fi in files:
        dart = DartFi.cast(fi)
        if dart is None or dart.is_gen:
            continue
        name = dart.sourcename
        if name in proj.comps:
            # the file is a component
            comp = proj.comps[name]
            if comp in module.components:
                raise DuplicateNameCompError(module.name, comp.name)
            module.add_page(comp, dart)
        else:
            module.try_pin(dart)
    for folder in dirs:
        name = folder.name
        if name in proj.comps:
            # the folder is a component
            comp = proj.comps[name]
            if comp in module.components:
                raise DuplicateNameCompError(module.name, comp.name)
            module.add_page(comp, folder)
        elif Module.validate(folder):
            # the folder is a submodule
            sub = load(t, proj, module_name=name, parent=folder)
            sub.parent = module
            module.sub[name] = sub
    return module


class DuplicateNameCompError(Exception):

    def __init__(self, module: str, comp: str, *args: object) -> None:
        super().__init__(*args)
        self.module = module
        self.comp = comp
