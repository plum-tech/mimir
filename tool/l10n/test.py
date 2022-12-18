from . import resort
from . import rearrange
from . import serve


def test_resort():
    f = "../../l10n/app_en.arb"
    txt = open(f, mode="r", encoding="UTF-8").read()
    resort.resort(
        target=txt,
        method=resort.do_tags_sort,
    )


def test_rearrange():
    l10n_dir = "../../l10n"
    prefix = "app_"
    rearrange.rearrange(l10n_dir, prefix, template_suffix="en.arb")


def test_serve():
    l10n_dir = "../../l10n"
    prefix = "app_"
    serve.serve(l10n_dir, prefix, template_suffix="en.arb")
