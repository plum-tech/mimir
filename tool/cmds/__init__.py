from cmds.add_module import AddModuleCmd
from cmds.lint import LintCmd
from cmds.run import RunCmd
from cmds.alias import AliasCmd
from cmds.l10n import L10nCmd
from cmds.cli import CliCmd
from cmds.native_cmd import NativeCmd
from cmd import CommandList


def load_static_cmd(cmdlist: CommandList):
    cmdlist << AddModuleCmd
    # cmdlist << RunCmd
    cmdlist << LintCmd
    cmdlist << AliasCmd
    cmdlist << L10nCmd
    cmdlist << CliCmd
    cmdlist << NativeCmd("git")
    cmdlist << NativeCmd("flutter")
    cmdlist << NativeCmd("dart")
