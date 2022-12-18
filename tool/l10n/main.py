import sys
from . import resort
from . import rearrange
from . import serve
from . import migration

tittle = """
   ██╗   ██╗   █████╗   ███╗   ██╗
   ██║  ███║  ██╔══██╗  ████╗  ██║
   ██║  ╚██║  ╚█████╔╝  ██╔██╗ ██║
   ██║   ██║  ██╔══██╗  ██║╚██╗██║
   ██║   ██║  ╚█████╔╝  ██║ ╚████║
   ╚═╝   ╚═╝   ╚════╝   ╚═╝  ╚═══╝
By Liplum (https://github.com/liplum)
Input with argument \"help\" to get help info
"""

help_txt = """
* means optional
--------------------------
help: display help info.
--------------------------
resort: resort a .arb file.
args:
    target: .arb file path
        type: str
    *method: how to resort this file
        options: [
            alphabetical : sort in alphabetical order,
            -alphabetical : sort in alphabetical order with a reversed key,
            lexicographical : sort in lexicographical order,
            tags : sort by weighted tags
        ]
        default: alphabetical 
    *keep_unmatched_meta: keep a meta even missing a pair 
        options: [y,n]
        default: n
    *indent: indent of json output
        type: int
        default: 2
---------------------
rearrange: rearrange other .arb files in the same order of the template.
args:
    prefix: the prefix of all .arb file
    template: template path
    *fill_blank: fill all missing l10n pairs
        options: [y,n]
        default: n
    *indent: indent of json output
          default: 2
    *keep_unmatched_meta : keep a meta even missing a pair
        default: n
---------------------
serve: auto-rearrange other .arb files when any key changed in template.
args:
    prefix: the prefix of all .arb file
    template: template path
    *fill_blank: fill all missing l10n pairs
        default: y
    *indent: indent of json output
           default: 2
    *keep_unmatched_meta: keep a meta even missing a pair
        default: n
---------------------
migrate: an interactive migration tool with a wizard setup. 
args:
    you can specify arguments used in the wizard.
--------------------------
"""

all_tasks = {
    "help": lambda _: print(help_txt),
    "resort": resort.wrapper,
    "rearrange": rearrange.wrapper,
    "serve": serve.wrapper,
    "migration": migration.main,
}


def main():
    if len(sys.argv) == 1:
        print(tittle)
        return
    args = sys.argv[1:]
    arg0 = args[0]
    if arg0 in all_tasks.keys():
        params = args[1:] if len(args) > 0 else []
        task = all_tasks[arg0]
        task(params)
    else:
        print(f"no such command: \"{arg0}\", please check \"help\"")


if __name__ == '__main__':
    main()
