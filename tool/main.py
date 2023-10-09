import datetime
import ntpath
import os.path
import sys
from typing import Sequence, Iterator

import build
import cmd
import fuzzy
import log
import strings
from args import Args, split_multicmd
from cmd import CommandList, CmdContext, CommandLike, CommandExecuteError, CommandArgError, CommandEmptyArgsError
from coroutine import TaskDispatcher, DispatcherState
from filesystem import File, Directory
from project import Proj, ExtraCommandsConf
from ui import Terminal, BashTerminal
from utils import useRef

version = 1

def find_project_root(start: str | Directory, max_depth=20) -> Directory | None:
    """
    find the best match of project root.
    project root always has a "pubspec.yaml" file.
    :param max_depth: how deep the finding can reach
    :param start: where to start
    :return: the project root
    """
    # Go through until upper bound
    if isinstance(start, str):
        start = Directory(start)
    max_depth = max(0, max_depth)
    layer = 0
    cur = start
    while True:
        if layer > max_depth or cur.isroot:
            return None
        import project
        if cur.sub_isfi(project.pubspec_yaml):
            return cur
        cur = cur.parent
        layer += 1


def load_cmds(*, proj: Proj, cmdlist: CommandList, t: Terminal):
    import cmds
    cmds.load_static_cmd(cmdlist)
    from cmds.help import HelpCmd
    cmdlist << HelpCmd(cmdlist)
    cmdlist.builtins = set(cmdlist.keys())
    # load extra commands
    import project
    extra = proj.settings.get(project.extra_commands, settings_type=ExtraCommandsConf)
    for name, entry in extra.name2commands.items():
        if cmdlist.is_builtin(name):
            t.both << f"builtin command<{name}> can't be overriden."
        else:
            cmdlist << cmd.CommandDelegate(name, entry.fullargs, entry.helpinfo)


_header_entry_cache = {}
_header_existence_cache = {}
_header_length = 48


def _get_header_entry(command: CommandLike) -> str:
    name = command.name
    if name in _header_entry_cache:
        return _header_entry_cache[name]
    else:
        line = strings.center_text_in_line(f">>[{name}]<<", length=_header_length, repeater="━")
        _header_entry_cache[name] = line
        return line


def _get_header_existence(command: CommandLike) -> str:
    name = command.name
    if name in _header_existence_cache:
        return _header_existence_cache[name]
    else:
        line = strings.center_text_in_line(f"<<[{name}]>>", length=_header_length, repeater="━")
        _header_existence_cache[name] = line
        return line


def _get_header_switch(pre: CommandLike, nxt: CommandLike) -> str:
    return strings.center_text_in_line(f"<<[{pre.name}]>>[{nxt.name}]<<", length=_header_length)


def clear_old_log(log_dir: Directory):
    now = datetime.datetime.now()
    log_dir.ensure()
    for logfi in log_dir.listing_fis():
        delta = now - logfi.modify_datetime
        if delta.days > 7:
            logfi.delete()


def main():
    script_path = sys.argv[0]
    script_abs_path = os.path.abspath(script_path)
    parent, _ = os.path.split(script_abs_path)
    cmdargs = sys.argv[1:] if len(sys.argv) > 1 else ()
    # finding starts with the parent folder of main.py
    root = find_project_root(start=parent)
    if root is not None:
        proj = Proj(root)
        clear_old_log(proj.kite_log_dir)
        logger = log.FileLogger(proj.kite_log)
        File.logger = logger
        Directory.logger = logger
        t = BashTerminal(logger)
        cmds = CommandList(logger=logger)
        shell(proj=proj, cmdlist=cmds, terminal=t, cmdargs=cmdargs)
    else:
        print(f"❌ project root not found")


def shell(*, proj: Proj, cmdlist: CommandList, terminal: Terminal, cmdargs: Sequence[str] | Args):
    terminal.logging << f'Project root found at "{proj.root}".'
    terminal.both << f'Build Tool v{version}'
    proj.settings.load()
    import yml
    proj.pubspec = yml.load(proj.pubspec_fi.read())
    proj.l10n = yml.load(proj.l10n_yaml.read())
    terminal.both << f'Project loaded: "{proj.name} {proj.version}".'
    terminal.both << f'Description: "{proj.desc}".'
    import mimir
    mimir.load(proj)

    def load_cmds_func():
        cmdlist.name2cmd.clear()
        load_cmds(proj=proj, cmdlist=cmdlist, t=terminal)

    load_cmds_func()
    proj.kernel.reloader.reload_cmds = load_cmds_func
    import loader
    from loader import DuplicateNameCompError
    try:
        loader.load_modules(terminal, proj)
    except DuplicateNameCompError as e:
        terminal.both << f"duplicate component<{e.comp}> of module<{e.module}> detected."
        cmd.log_traceback(terminal)
        return
    if len(cmdargs) == 0:
        interactive_mode(proj=proj, cmdlist=cmdlist, terminal=terminal)
    else:
        if isinstance(cmdargs, Args):
            fullargs = cmdargs
        else:
            fullargs = Args.by(seq=cmdargs)
        cli_mode(proj=proj, cmdlist=cmdlist, terminal=terminal, cmdargs=fullargs)
    proj.settings.save()
    terminal.both << "Build Tool exits."


def cli_mode(*, proj: Proj, cmdlist: CommandList, terminal: Terminal, cmdargs: Args):
    all_cmdargs = split_multicmd(cmdargs)
    cmd_size = len(all_cmdargs)
    if cmd_size == 0:
        terminal.both << f"no command given in CLI mode."
    elif cmd_size == 1:
        # read first args as command
        args = all_cmdargs[0]
        command, args = args.poll()
        if command.ispair:
            terminal.both << f'invalid command format "{command}".'
            return
        cmdname = command.key
        executable = cmdlist[cmdname]
        if executable is None:
            terminal.both << f'❗ command<{cmdname}> not found.'
            matched, ratio = fuzzy.match(cmdname, cmdlist.name2cmd.keys())
            if matched is not None and ratio > fuzzy.at_least:
                terminal << f'👀 do you mean command<{matched}>?'
            return
        else:
            terminal.both << _get_header_entry(executable)
            ctx = CmdContext(proj=proj, cmdlist=cmdlist, terminal=terminal, args=args)
            cmd.catch_executing(ctx, executing=lambda: executable.execute_cli(ctx))
            terminal.both << _get_header_existence(executable)
    else:
        # prepare commands to run
        exe_args = []
        # check if all of them are executable
        for command, args in (args.poll() for args in all_cmdargs):
            if command.ispair:
                terminal.both << f'invalid command format "{command}".'
                return
            cmdname = command.key
            executable = cmdlist[cmdname]
            if executable is None:
                terminal.both << f'❗ command<{cmdname}> not found.'
                return
            exe_args.append((executable, args))
        last = None
        for i, pair in enumerate(exe_args):
            executable, args = pair
            if last is None:
                terminal.both << _get_header_entry(executable)
            else:
                terminal.both << _get_header_switch(last, executable)
            ctx = CmdContext(proj=proj, cmdlist=cmdlist, terminal=terminal, args=args)
            cmd.catch_executing(ctx, executing=lambda: executable.execute_cli(ctx))
            if i == len(exe_args) - 1:
                terminal.both << _get_header_existence(executable)
            last = executable


def interactive_mode(*, proj: Proj, cmdlist: CommandList, terminal: Terminal):
    terminal.line(48)
    terminal << '[interactive] enter "#" to exit current layer.'

    # all_cmd = ', '.join(cmdlist.keys())
    # all_cmd_prompt = f"all commands = [{all_cmd}]"

    def running() -> Iterator:
        dispatcher = TaskDispatcher()
        while True:
            # terminal << all_cmd_prompt
            selected: CommandLike = useRef()
            ctx = CmdContext(proj, terminal, cmdlist)
            yield build.select_one_cmd(ctx, cmdlist.name2cmd, prompt="cmd=", fuzzy_match=True, ref=selected)
            terminal.both << _get_header_entry(selected)
            dispatcher.run(selected.execute_interactive(ctx))
            state = cmd.catch_executing(ctx, executing=lambda: dispatcher.dispatch())
            terminal.both << _get_header_existence(selected)
            if state == DispatcherState.Abort:
                yield

    global_dispatcher = TaskDispatcher()
    while True:
        global_dispatcher.run(running())
        global_state = global_dispatcher.dispatch()
        if global_state == DispatcherState.Abort:
            return


if __name__ == '__main__':
    main()
