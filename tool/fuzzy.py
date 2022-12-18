from difflib import SequenceMatcher
from typing import Iterable

at_least = 0.4


def match(target: str, candidates: Iterable[str]) -> tuple[str, float]:
    largest = None
    largest_num = 0.0
    for candidate in candidates:
        matcher = SequenceMatcher(isjunk=None, a=target, b=candidate)
        ratio = matcher.ratio()
        if largest is None or ratio > largest_num:
            largest = candidate
            largest_num = ratio
    return largest, largest_num
