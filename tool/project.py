from enum import Enum, auto
from io import StringIO
from typing import Sequence, Literal

from dart import DartFi, DartRunner
from filesystem import Directory, File
from kernal import Kernel
from runner import Runner
from serialize import Serializer
from settings import SettingsBox

dart_tool = ".dart_tool"
kite_tool = ".kite_tool"
pubspec_yaml = "pubspec.yaml"
extra_commands = "extra_commands"
l10n_yaml = "l10n.yaml"


class Proj:
    def __init__(self, root: Directory | str):
        if isinstance(root, str):
            self.root = Directory(root)
        else:
            self.root = root
        self.pubspec = None
        self.l10n = None
        self.modules: Modules | None = None
        self.usings: dict[str, "UsingDeclare"] = {}
        self.comps: dict[str, "CompType"] = {}
        self.unmodules: set[str] = set()
        self.scripts = ScriptManger()
        self.serializer = Serializer()
        self.settings = SettingsBox(self.serializer, self.settings_fi)
        self.runner = Runner(self.root)
        self.dartRunner = DartRunner(self.runner)
        self.kernel = Kernel()

    def add_unmodule(self, name: str):
        self.unmodules.add(name)

    def add_using(self, using: "UsingDeclare"):
        self.usings[using.name] = using

    def add_comp(self, comp: "CompType"):
        self.comps[comp.name] = comp

    @property
    def name(self) -> str:
        return self.pubspec["name"]

    @property
    def version(self) -> str:
        return self.pubspec["version"]

    @property
    def desc(self) -> str:
        return self.pubspec["description"]

    @property
    def pubspec_fi(self) -> File:
        return self.root.subfi(pubspec_yaml)

    @property
    def dart_tool(self) -> Directory:
        return self.root.subdir(dart_tool)

    @property
    def kite_tool(self) -> Directory:
        return self.root.subdir(dart_tool, kite_tool)

    @property
    def scripts_dir(self) -> Directory:
        return self.root.subdir("scripts")

    @property
    def settings_fi(self) -> File:
        return self.root.subfi(dart_tool, kite_tool, "settings.json")

    @property
    def kite_log_dir(self) -> Directory:
        return self.root.subdir(dart_tool, kite_tool, "log")

    @property
    def kite_log(self) -> File:
        from datetime import date
        d = date.today().isoformat()
        return self.root.subfi(dart_tool, kite_tool, "log", f"{d}.log")

    @property
    def lib_folder(self) -> Directory:
        return self.root.subdir("lib")

    @property
    def l10n_yaml(self) -> File:
        return self.root.subfi(l10n_yaml)

    @property
    def backend_dart(self) -> DartFi:
        return DartFi.cast(self.lib_folder.subfi("backend.dart"))

    @property
    def l10n_dir(self) -> Directory:
        return self.root.subdir(self.l10n["arb-dir"])

    @property
    def template_arb_fi(self) -> File:
        return self.l10n_dir.subfi(self.l10n["template-arb-file"])

    @property
    def module_folder(self) -> Directory:
        return self.root.subdir("lib", "module")

    @property
    def android_build_gradle(self) -> File:
        return self.root.subfi("android", "app", "build.gradle")

    def __str__(self):
        if self.pubspec is None or "name" not in self.pubspec:
            return "UNLOADED PROJECT"
        else:
            return self.name

    def __repr__(self):
        return str(self)


# noinspection SpellCheckingInspection
class CompType:

    def __init__(self, name: str):
        self.name = name

    def create(self, moduledir: Directory, mode: str | Literal["file", "dir"]):
        if mode == "file":
            moduledir.createfi(f"{self.name}.dart")
        elif mode == "dir":
            moduledir.createdir(self.name).createfi(f"{self.name}.dart")
        else:
            raise Exception(f"unknown module creation mode {mode}")

    def make_page(self, file: Directory | DartFi) -> "CompPage":
        t = CompPageType.File if isinstance(file, File) else CompPageType.Dir
        return CompPage(self.name, file, t)

    def __str__(self):
        return self.name

    def __repr__(self):
        return self.name


# noinspection SpellCheckingInspection
class UsingDeclare:

    def __init__(self, name: str, refs: list[str] = None):
        self.name = name
        if refs is None:
            refs
        self.refs = refs

    # TODO: Known issue: it can't resolve the relative path of submodule
    def create(self, usingfi: File):
        with StringIO() as res:
            for ref in self.refs:
                res.write(f"export '{ref}';\n")
            usingfi.append(res.getvalue())

    def __str__(self):
        return f"{self.name},{self.refs}"

    def __repr__(self):
        return self.name


class CompPageType(Enum):
    File = auto()
    Dir = auto()


# noinspection PyTypeChecker
class CompPage:
    def __init__(self, name: str, file: Directory | DartFi, typec: CompPageType):
        self.name = name
        self.file = file
        self.type = typec

    def __str__(self):
        return f"{self.name}[{self.file}]"

    def __repr__(self):
        return str(self)


class Module:
    pinned = {"init", "using", "symbol"}

    def __init__(self, name: str):
        self.name = name
        self.components: dict[CompType, CompPage] = {}
        self.sub: dict[str, Module] = {}
        self.parent: Module | None = None
        self.init_dart: DartFi | None = None
        self.using_dart: DartFi | None = None
        self.symbol_dart: DartFi | None = None

    def try_pin(self, fi: DartFi) -> bool:
        sourcename = fi.sourcename
        if sourcename in Module.pinned:
            setattr(self, f"{sourcename}_dart", fi)
            return True
        else:
            return False

    @staticmethod
    def validate(folder: Directory) -> bool:
        return folder.sub_isfi("using.dart") or folder.sub_isfi("symbol.dart")

    def add_page(self, comp: CompType, fi: DartFi | Directory):
        self.components[comp] = comp.make_page(fi)

    @property
    def isroot(self) -> bool:
        return self.parent is None

    def __getitem__(self, item: CompType) -> CompPage | None:
        if item in self:
            return self.components[item]
        else:
            return None

    def __contains__(self, item: CompType) -> bool:
        return item in self.components

    def __str__(self):
        if len(self.sub) == 0:
            return f"{self.name}"
        else:
            return f"{self.name}[{', '.join(self.sub.keys())}]"

    def __repr__(self):
        return str(self)


Components = Sequence[CompType]
Usings = Sequence[UsingDeclare]


class ModuleCreation:
    def __init__(self, name: str, components: Components, usings: Usings, simple=False):
        self.name = name.strip()
        self.components = components
        self.usings = usings
        self.simple = simple

    def __str__(self):
        components = self.components
        usings = self.usings
        simple = self.simple
        return f"{components=},{usings=},{simple=}"

    def __repr__(self):
        return str(self)


class Modules:
    def __init__(self, proj: Proj):
        self.proj = proj
        self.name2modules = {}
        self.symbol: File | None = None

    def create(self, creation: ModuleCreation):
        name = creation.name
        if name in self.name2modules:
            raise Exception(f"module<{name}> already exists")
        moduledir = self.proj.module_folder.subdir(name)
        for component in creation.components:
            mode = "file" if creation.simple else "dir"
            component.create(moduledir, mode)
        usingfi = moduledir.subfi("using.dart")
        for using in creation.usings:
            using.create(usingfi)

    def __contains__(self, name: str):
        return name in self.name2modules

    def __str__(self):
        return f"{self.proj.name}:{len(self.name2modules)} modules"

    def __repr__(self):
        return str(self)


class KiteScript:
    def __init__(self, fi: File):
        self.file = fi


class ScriptManger:
    def __init__(self):
        self._kitescripts: dict[str, KiteScript] = {}

    def __getitem__(self, name: str) -> KiteScript | None:
        if name in self._kitescripts:
            return self._kitescripts[name]
        else:
            return None

    def add(self, fi: File):
        name = fi.name_without_extension
        script = KiteScript(fi)
        self._kitescripts[name] = script


class ExtraCommandEntry:
    def __init__(self, name="__default__", fullargs="", helpinfo=""):
        self.name = name
        self.fullargs = fullargs
        self.helpinfo = helpinfo


class ExtraCommandsConf:
    def __init__(self):
        self.name2commands: dict[str, ExtraCommandEntry] = {}

    def __setitem__(self, key: str, cmd: ExtraCommandEntry):
        self.name2commands[key] = cmd

    def __getitem__(self, key: str) -> ExtraCommandEntry | None:
        if key in self.name2commands:
            return self.name2commands[key]
        else:
            return None

    def __contains__(self, key: str) -> bool:
        return key in self.name2commands
