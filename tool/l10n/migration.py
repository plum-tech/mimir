from . import flutter
from . import serve
from .rearrange import *
from . import resort
from datetime import datetime, date
import os.path
from . import ui
from threading import Thread
import shlex

line = "----------------------------------------------"
_workplace_path = "workplace.json"
_cache_folder = ".l10n_arb_tool"
_log_folder = "log"
logs = []
serve_thread: Thread | None = None
migration_version = 2
background_tasks = set()


def in_cache(sub: str) -> str:
    return os.path.join(_cache_folder, sub)


def log_folder():
    return in_cache(_log_folder)


def log_path():
    d = date.today().isoformat()
    return os.path.join(log_folder(), f'{d}.log')


def l10n_dir():
    return os.path.join(x.project_root, x.l10n_folder)


class Workplace:
    hidden_fields = {
        "version", "run_times"
    }

    def __init__(self):
        self.version = migration_version
        self.indent = 2
        self.prefix = "app_"
        self.l10n_folder = "lib/l10n"
        self.project_root = "."
        self.template_name = "app_en.arb"
        self.resort_method = resort.Alphabetical
        self.auto_add = True
        self.keep_unmatched_meta = False
        self.read_workplace = True
        self.auto_read_workplace = False
        self.auto_rebuild = False
        self.run_times = 0


Args = Sequence[str]
Command = Callable[[Args], None]

other_arb_paths = []

x = Workplace()
last_x = None


def workplace_path():
    return in_cache(_workplace_path)


def save_workplace(workplace: Workplace = x):
    path = workplace_path()
    j = json.dumps(vars(workplace), ensure_ascii=False, indent=2)
    write_fi(path, j)
    Log(f'workplace saved at {path}.')


# noinspection PyBroadException
def restore_workplace() -> Workplace | None:
    path = workplace_path()
    raw = try_read_fi(path)
    workplace = None
    if raw is not None:
        Log(f'workplace was found at {path}')
        try:
            j = json.loads(raw)
        except:
            Log('workplace has been corrected.')
            delete_fi(path)
            Log('workplace was deleted.')
            return None
        workplace = Workplace()
        for k, v in j.items():
            if hasattr(workplace, k):
                setattr(workplace, k, v)
    return workplace


def load_attr(k: str, v: Any, fields: dict[str, Any], *, to: Workplace):
    if k in fields:
        old_v = fields[k]
        cast = try_cast(template=old_v, attempt=v)
        if cast is None:
            D(f'invalid input, "{k}"\'s type is "{type(old_v).__name__}".')
        else:
            if hasattr(to, k):
                setattr(to, k, v)
    else:
        D(f"{k} doesn't exist.")


def D(*args):
    ui.terminal.print(*args)


def DLog(*args):
    ui.terminal.print_log(*args)


def Log(*args):
    ui.terminal.log(*args)


def C(prompt: str) -> str:
    return ui.terminal.input(prompt)


def yn(reply: str) -> bool:
    return to_bool(reply, empty_means=True)


def print_background_tasks():
    D(f'bg tasks: [{", ".join(background_tasks)}]')


class MigrationTerminal(ui.Terminal):
    def print(self, *args):
        print(f'|>', *args)

    def print_log(self, *args):
        content = ' '.join(args)
        print(f'|>', content)
        self.log(content)

    # noinspection PyBroadException
    def log(self, *args):
        content = ' '.join(args)
        now = datetime.now().strftime('%H:%M:%S')
        content = f'[{now}] {content}\n'
        if ensure_folder(log_folder()):
            try:
                append_fi(log_path(), content)
            except:
                pass
        logs.append(content)

    def input(self, prompt: str) -> str:
        return input(f'|>   {prompt}')


def template_path():
    return os.path.join(l10n_dir(), x.template_name)


def template_path_abs():
    return os.path.abspath(os.path.join(l10n_dir(), x.template_name))


def Dline(center: str = None):
    if center is None:
        print(line)
    else:
        print(f'|>-------------------{center}-------------------')


def cmd_create(args: Args = ()):
    if len(args) == 1 and args[0] == "help":
        D('create a new .arb file.')
        D('args: [name:str]')
        return
    paras = split_para(args)
    if "name" in paras:
        name = paras["name"]
    else:
        D(f'enter a file name to create. enter "#" to quit.')
        while True:
            name = C('name=')
            if name == "#":
                return
            valid = validate_file_name(name)
            if not valid:
                D(f'invalid file name "{name}", plz try again.')
            else:
                break
    name = suffix_arb(name)
    new = os.path.join(l10n_dir(), name)
    tplist, tpmap = load_arb(path=template_path())
    if x.auto_add:
        rearrange_others_saved_re([new], tplist, x.indent, x.keep_unmatched_meta, fill_blank=True)
        DLog(f'{new} was created and rearranged.')
    else:
        rearrange_others_saved_re([new], tplist, x.indent, x.keep_unmatched_meta, fill_blank=False)
        DLog(f'{new} was created.')


def rename_key(template: ArbFile, others: list[ArbFile], old: str, new: str):
    arbs = others + [template]
    for arb in arbs:
        if old in arb.pmap:
            arb.rename_key(old=old, new=new)
            Log(f'renamed "{old}" to "{new}" in "{arb.file_name()}".')
        else:
            if x.auto_add:
                p = Pair(key=new, value="")
                arb.add(p)
                Log(f'added "{new}" in "{arb.file_name()}".')

    if x.resort_method is not None:  # auto_resort is enabled
        resorted = resort.methods[x.resort_method](template.plist, template.pmap)
        template.plist = resorted
        if serve_thread is None:
            rearrange_others(others, template, fill_blank=x.auto_add)
    for arb in arbs:
        save_flatten(arb, x.indent, x.keep_unmatched_meta)
        Log(f'{arb.file_name()} saved.')
    if x.auto_rebuild:
        flutter.gen_110n(x.project_root)


def cmd_rename(args: Args = ()):
    if len(args) == 1 and args[0] == "help":
        D('rename a key in all .arb files.')
        D('args: [old:str, new:str]')
        return
    paras = split_para(args)
    if "old" in paras and "new" in paras:
        old = paras["old"]
        new = paras["new"]
        if not validate_key(old):
            D(f'the old key "{old}" is invalid.')
            return
        if not validate_key(new):
            D(f'the new key "{new}" is invalid.')
            return
        template_arb = load_arb_from(path=template_path())
        tplist, tpmap = template_arb.plist, template_arb.pmap
        if old not in tpmap.keys():
            D(f'"{old}" isn\'t in template.')
            return
        other_arbs = load_all_arb_in(paths=other_arb_paths)
        rename_key(template_arb, other_arbs, old, new)
    else:
        D(f'enter old name and then new name. enter "#" to quit.')
        while True:
            while True:
                old = C(f'old=')
                if old == "#":
                    return
                old_valid = validate_key(old)
                if old_valid:
                    break
                else:
                    D(f'the old key "{old}" is invalid, plz try again.')
                    continue
            template_arb = load_arb_from(path=template_path())
            tplist, tpmap = template_arb.plist, template_arb.pmap
            if old not in tpmap.keys():
                # try to fuzzy match
                matched, ratio = fuzzy_match(old, tpmap.keys())
                if matched is not None:
                    D(f'"{old}" isn\'t in template, do you mean "{matched}"?')
                    inputted = C(f'y/n=')
                    if inputted == "#":
                        return
                    confirmed = yn(inputted)
                    if not confirmed:
                        D('alright, let\'s start all over again.')
                        continue
                    # if confirmed, do nothing
                else:
                    D(f'"{old}" isn\'t in template, plz check typo.')
                    continue
            while True:
                # for getting the
                new = C(f'new=')
                if new == "#":
                    return
                if new == old:
                    D('a new one can\'t be identical to the old one.')
                new_valid = validate_key(new)
                if not new_valid:
                    D(f'the new key "{new}" is invalid, plz try again.')
                else:
                    break
            other_arbs = load_all_arb_in(paths=other_arb_paths)
            rename_key(template_arb, other_arbs, old, new)
            Dline('[renamed]')


def resort_and_rearrange(method: str):
    template_arb = load_arb_from(path=template_path())
    template_arb.plist = resort.methods[method](template_arb.plist, template_arb.pmap)
    save_flatten(template_arb)
    rearrange_others_saved_re(other_arb_paths, template_arb.plist,
                              x.indent, x.keep_unmatched_meta,
                              fill_blank=x.auto_add)
    D('all .arb files were resorted and rearranged.')


# noinspection PyBroadException
def cmd_resort(args: Args = ()):
    if len(args) == 1 and args[0] == "help":
        D('resort the template and rearrange others.')
        D('args: [method:str]')
        return
    paras = split_para(args)
    if "method" in paras:
        method = paras["method"]
        if method not in resort.methods:
            D(f'{method} isn\'t in [{", ".join(resort.methods.keys())}]')
        else:
            resort_and_rearrange(method)
    else:
        size = len(resort.methods)
        if size == 0:
            D('No resort available.')
            return
        for index, name in resort.id2methods.items():
            D(f'{index}: {name}')  # index 2 name
        D('enter the number of method.')
        while True:
            try:
                inputted = C('method=')
                if inputted == "#":
                    return
                i = int(inputted)
                if 0 <= i < size:
                    break
                else:
                    D(f'{i} is not in range(0<=..<{size})')
            except:
                D('input is invalid, plz try again.')
        resort_and_rearrange(resort.id2methods[i])


def cmd_log(args: Args = ()):
    if len(args) == 1 and args[0] == "help":
        D('display the current log.')
        return
    for ln in logs:
        D(ln)


def cmd_set(args: Args = ()):
    settings = x
    if len(args) == 1 and args[0] == "help":
        D('set the workplace.')
        D(f'args: [{", ".join(vars(settings).keys() - settings.hidden_fields)}]')
        return
    fields = vars(settings)
    if len(args) > 0:
        paras = split_para(args)
        for k, v in paras.items():
            if k in settings.hidden_fields:
                continue
            load_attr(k, v, fields, to=settings)
    else:
        D('set the workplace')
        D(f'enter "#" to quit [set]. enter "?" to skip one.')
        for k, v in fields.items():
            if k in settings.hidden_fields:
                continue
            D(f'{k}={v}      << former')
            while True:
                inputted = C(f'{k}=')
                if inputted == "#":
                    return
                if inputted == "?":
                    break
                cast = try_cast(template=v, attempt=inputted)
                if cast is None:
                    D(f'invalid input, "{k}"\'s type is "{type(v).__name__}".')
                else:
                    if hasattr(settings, k):
                        setattr(settings, k, v)
                    break


server_is_running = False


class NestedServerTerminal(ui.Terminal):
    def print(self, *args):
        Log(*args)

    def print_log(self, *args):
        Log(*args)

    def log(self, *args):
        Log(*args)


def stop_serve_task():
    global serve_thread, server_is_running
    server_is_running = False
    serve_thread = None
    if "serve" in background_tasks:
        background_tasks.remove('serve')
    DLog(f'server aborted.')


def start_serve_task(background=True):
    global serve_thread, server_is_running

    def serve_func():
        terminal = NestedServerTerminal()
        serve.start(template_path(), other_arb_paths,
                    x.indent, x.keep_unmatched_meta, fill_blank=True,
                    is_running=lambda: server_is_running,
                    on_acted=lambda: rebuild(terminal) if x.auto_rebuild else None,
                    terminal=terminal)

    server_is_running = True
    serve_thread = Thread(target=serve_func)
    serve_thread.daemon = background
    serve_thread.start()
    background_tasks.add('serve')
    DLog(f'server started at background.')


def cmd_serve(args: Args = ()):
    global serve_thread, server_is_running
    background = True
    if len(args) == 1:
        if args[0] == "help":
            D('start a server to detect changes and rearrange others at background.')
            D('args: [background:y/n]')
            return
        else:
            if server_is_running:
                stop_serve_task()
            else:
                paras = split_para(args)
                if "background" in paras:
                    background = yn(paras["background"])
                start_serve_task(background)
    else:
        D(f'[serve] will detect changes of "{x.template_name}" and rearrange others at background.')
        if not server_is_running:
            D(f'do you want to start the server?')
            reply = C('y/n=')
            if reply == "#":
                return
            start = yn(reply)
            if start:
                start_serve_task(background)
        else:
            D('server has been started, do you want to stop it?')
            reply = C('y/n=')
            if reply == "#":
                return
            stop = yn(reply)
            if stop:
                stop_serve_task()


def rebuild(terminal: ui.Terminal = ui.terminal):
    flutter.gen_110n(x.project_root)
    terminal.print_log('flutter gen-10n was called and .dart files were rebuild.')


def cmd_rebuild(args: Args = ()):
    if len(args) == 1 and args[0] == "help":
        D(f'run "flutter gen-l10n" at your project root "{x.project_root}".')
        D(f'flutter should be added to your {env_var_str("PATH")}.')
        return
    D(f'run "flutter gen-l10n" at your project root "{x.project_root}".')
    rebuild()


# noinspection PyUnusedLocal
def cmd_try(args: Args = ()):
    pass


cmds: dict[str, Command] = {
    "create": cmd_create,
    "rename": cmd_rename,
    "resort": cmd_resort,
    "log": cmd_log,
    "set": cmd_set,
    "serve": cmd_serve,
    "r": cmd_rebuild
}
cmd_names = list(cmds.keys())
cmd_full_names = ', '.join(cmd_names)


def run_cmd(name: str, args: Args = ()):
    Dline(f'>>[{name}]<<')
    cmds[name](args)
    Dline(f'<<[{name}]>>')


# noinspection PyUnusedLocal
def run_try(args: Args = ()):
    pass


def migrate(args: Args):
    if len(args) > 0:
        cmd = args[0]
        cmd_args = args[1:] if len(args) > 1 else ()
        if cmd in cmd_names:
            run_cmd(cmd, cmd_args)
        else:
            D(f'no such cmd {cmd}')
        return
    else:
        try_and_see_done = False
        while True:
            D(f'enter "quit" or "#" to quit migration. all cmds allow a "help" arg.')
            D(f'all cmds: [{cmd_full_names}]')
            if len(background_tasks) > 0:
                print_background_tasks()
            if x.run_times <= 0 and not try_and_see_done:
                D(f'hello! since it\'s your first time to use migration, there is a cmd that can guide you.')
                D(f'enter cmd "try" to get help about migration.')
                try_and_see_done = True
            while True:
                full_args = C('% ').strip()
                if len(full_args) > 0:
                    break
            if full_args == "quit" or full_args == "#":
                return
            parts: list[str] = shlex.split(full_args)
            if len(parts) == 0:
                D('no cmd input, plz try again')
                continue
            cmd = parts[0]
            args = parts[1:] if len(parts) > 1 else ()
            if cmd in cmd_names:
                run_cmd(cmd, args)
            else:
                # try to fuzzy match
                matched, ratio = fuzzy_match(full_args, cmd_names)
                if matched is not None:
                    D(f'cmd "{full_args}" is not found, do you mean "{matched}"?')
                    confirmed = yn(C(f'y/n='))
                    if not confirmed:
                        D('alright, let\'s start all over again.')
                    else:
                        run_cmd(matched)
                else:
                    D(f'cmd "{full_args}" is not found, plz try again.')
            Dline()


def init():
    D('initializing .arb files...')
    l10n_folder = l10n_dir()
    for f in os.listdir(l10n_folder):
        full = os.path.join(l10n_folder, f)
        if os.path.isfile(full):
            head, tail = os.path.split(full)
            if tail != x.template_name and tail.endswith('.arb') and tail.startswith(x.prefix):
                other_arb_paths.append(full)
    Dline('[workplace]')
    D(f'{x.indent=},{x.prefix=},{l10n_folder=},{x.auto_add=}')
    D(f'{x.resort_method=}')
    Dline('[workplace]')
    D(f'l10n folder locates at {os.path.abspath(l10n_folder)}')
    D(f'all .arb file paths: [')
    for p in other_arb_paths:
        D(f'{os.path.abspath(p)}')
    D(f']')
    D(f'template arb file path: "{template_path_abs()}"')
    D(f'.arb files initialized.')


# noinspection PyBroadException
def setup_indent():
    D(f'please enter indent, "{x.indent}" as default')
    while True:
        inputted = C('indent=')
        try:
            if inputted == "#":
                return 1
            if inputted != "":
                x.indent = int(inputted)
            return
        except:
            D('input is invalid, plz try again.')


def setup_project_root():
    D(f'please enter the path of project root, "{x.project_root}" as default')
    while True:
        inputted = C('project_root=')
        if inputted == "#":
            return 1
        if inputted != "":
            x.project_root = inputted
        return


def setup_l10n_folder():
    D(f'please enter path of l10n folder relative to the project root <"{x.project_root}">.')
    D(f'"{x.l10n_folder}" as default')
    while True:
        inputted = C('l10n_folder=')
        if inputted == "#":
            return 1
        if inputted != "":
            x.l10n_folder = inputted
        return


def setup_prefix():
    D(f'please enter prefix of .arb file name, "{x.prefix}" as default')
    while True:
        inputted = C('prefix=')
        if inputted == "#":
            return 1
        if inputted != "":
            x.prefix = inputted
        return


def setup_template_name():
    D(f'please enter template file name with extension, "{x.template_name}" as default')
    while True:
        inputted = C('template_name=')
        if inputted == "#":
            return 1
        if inputted != "":
            x.template_name = inputted
        return


def setup_auto_add():
    D(f'"auto_add" will add missing key automatically , "{x.auto_add}" as default')
    while True:
        inputted = C('auto_add=')
        if inputted == "#":
            return 1
        if inputted != "":
            x.auto_add = to_bool(inputted)
        return


def setup_keep_unmatched_meta():
    D(f'"keep_unmatched_meta" will keep a meta even missing a pair, "{x.keep_unmatched_meta}" as default')
    while True:
        inputted = C('keep_unmatched_meta=')
        if inputted == "#":
            return 1
        if inputted != "":
            x.keep_unmatched_meta = to_bool(inputted)
        return


# noinspection PyBroadException
def setup_auto_resort():
    D(f'"auto_resort" will resort when any change by migration, "{x.resort_method}" as default')
    while True:
        for index, name in resort.id2methods.items():
            D(f'{index}: {name}')  # index 2 name
        D(f'-1: None -- disable auto_resort')  # index 2 name
        inputted = C('id=')
        if inputted == "#":
            return 1
        try:
            i = int(inputted)
            if 0 <= i < len(resort.id2methods):
                x.resort_method = resort.id2methods[i]
            else:
                x.resort_method = None
            return
        except:
            D('input is invalid, plz try again.')


# noinspection PyBroadException
def setup_auto_rebuild():
    D(f'"auto_rebuild" will re-generate .dart file when any change by migration, "{x.auto_rebuild}" as default')
    while True:
        while True:
            inputted = C('auto_rebuild=')
            if inputted == "#":
                return 1
            if inputted != "":
                x.auto_rebuild = to_bool(inputted)
            return


all_setups: list[Callable[[], int | None]] = [
    setup_project_root,
    setup_l10n_folder,
    setup_indent,
    setup_prefix,
    setup_template_name,
    setup_auto_add,
    setup_keep_unmatched_meta,
    setup_auto_resort,
]


def wizard():
    global x
    D('hello, I\'m the migration wizard.')
    D('enter "#" to go back to previous setup.')
    last = restore_workplace()
    if last is not None and last.version == migration_version:
        if last.auto_read_workplace:
            x = last
            D(f'I restored the workplace you last used at "{workplace_path()}".')
        elif last.read_workplace:
            D(f'I found the workplace you last used at "{workplace_path()}"')
            D(f'do you want to continue this work?')
            continue_work = True
            inputted = C('y/n=')
            if inputted == "#":
                return 1
            if inputted != "":
                continue_work = yn(inputted)
            if continue_work:
                x = last
                D(f'oh nice, your workplace is restored.')
                D(f'do you want to auto restore workplace next time?')
                inputted = C('y/n=')
                auto_restore = True
                if inputted == "#":
                    return 1
                if inputted != "":
                    auto_restore = yn(inputted)
                last.auto_read_workplace = auto_restore
        return
    index = 0
    while index < len(all_setups):
        cur = all_setups[index]
        res = cur()
        if res == 1:
            index -= 2
        index += 1
        if index < 0:
            return 1
    return None


def load_workplace_from(args: Args = ()) -> Args:
    global x
    last = restore_workplace()
    if last is not None and last.version == migration_version:
        x = last
    paras = split_para(args)
    fields = vars(x)
    for k, v in paras.items():
        load_attr(k, v, fields, to=x)
    if "args" in paras:
        return shlex.split(paras["args"])
    else:
        return ()


def main(args: Args = ()):
    ui.terminal = MigrationTerminal()
    Dline()
    D(f'welcome to migration v{migration_version} !')
    D('if no input, the default value will be used.')
    D('for y/n question, the enter key means "yes".')
    wizard_res = None
    migrate_args = ()
    if len(args) == 0:
        wizard_res = wizard()
    else:
        migrate_args = load_workplace_from(args)
    Dline()
    if wizard_res is None:
        init()
        Dline()
        migrate(migrate_args)
    x.run_times += 1
    save_workplace(x)
    DLog('workplace saved')
    DLog(f'migration exited.')


if __name__ == '__main__':
    main()
