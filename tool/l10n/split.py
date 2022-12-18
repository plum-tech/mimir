from io import StringIO


def split_key(key: str) -> list[str]:
    """
    possible formats:
    ftype_expenseTracker

    possible separators:
    underscore, uppercase char
    """
    li = []
    s = StringIO()
    for part in key.split("_"):  # check underscore
        for c in part:
            if s.closed:
                s = StringIO()
            if not c.isupper():
                s.write(c)
            else:
                li.append(s.getvalue().lower())
                s.close()
                s = StringIO()
                s.write(c)
        if not s.closed:
            li.append(s.getvalue().lower())
            s.close()
    if not s.closed:
        li.append(s.getvalue().lower())
        s.close()
    return li
