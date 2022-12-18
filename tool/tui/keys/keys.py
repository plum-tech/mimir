from typing import Union, Tuple

control_keycode_1 = 0xe0
f_keycode_1 = 0


class key:
    def __init__(self, keycode_1: int, keycode_2: int | None = None):
        self.keycode_1 = keycode_1
        self.keycode_2 = keycode_2

    def __eq__(self, other: Union["key", str, bytes, int, Tuple[int, int]]):
        if isinstance(other, key):
            if self.keycode_1 == other.keycode_1:
                if self.keycode_2 is not None and other.keycode_2 is not None:
                    return self.keycode_2 == other.keycode_2
                return True
        elif isinstance(other, str):
            keycode = ord(other)
            return self.keycode_1 == keycode
        elif isinstance(other, bytes):
            real_char = other.decode()
            return self.keycode_1 == ord(real_char)
        elif isinstance(other, int):
            return self.keycode_1 == other
        elif isinstance(other, tuple):
            other_len = len(other)
            if other_len == 1 and self.keycode_2 is None:
                return self.keycode_1 == other[0]
            elif other_len > 1 and self.keycode_2 is not None:
                return self.keycode_1 == other[0] and self.keycode_2 == other[1]
        return False

    def __repr__(self):
        return f'({self.keycode_1},{self.keycode_2})->"{to_str(self)}"'

    def __str__(self):
        return to_str(self)

    def __hash__(self):
        return hash((self.keycode_1, self.keycode_2))

    def is_printable(self) -> bool:
        if self.keycode_2 is None and self.keycode_1 != control_keycode_1 and self.keycode_1 != f_keycode_1:
            return True
        return False


class printable(key):
    def __init__(self, char_: Union[str, bytes]):
        if isinstance(char_, bytes):
            self.char = char_.decode()
        else:
            self.char = char_
        super().__init__(ord(self.char))

    def is_printable(self) -> bool:
        return True


class control(key):
    def __init__(self, keycode_2: int):
        super().__init__(control_keycode_1, keycode_2)

    def is_printable(self) -> bool:
        return False

    def __str__(self):
        return ""


class f(key):
    def __init__(self, keycode_2: int):
        super().__init__(f_keycode_1, keycode_2)

    def is_printable(self) -> bool:
        return False

    def __str__(self):
        return ""


def is_key(char: Union[str, bytes, bytearray], key: Union[str, bytes]):
    if isinstance(char, str):
        b = char.encode()
    elif isinstance(char, bytes):
        b = char
    elif isinstance(char, bytearray):
        b = bytes(bytearray)
    else:
        return False

    if isinstance(key, bytes):
        k = key
    elif isinstance(key, str):
        k = key.encode()
    else:
        return False
    return b == k


def to_str(ch: key) -> str:
    """
    Transfer a char object to a character
    :param ch:
    :return:
    """
    return chr(ch.keycode_1)


def _p(c): return printable(c)


c_a = _p('a')
c_A = _p('A')

c_b = _p('b')
c_B = _p('B')

c_c = _p('c')
c_C = _p('C')

c_d = _p('d')
c_D = _p('D')

c_e = _p('e')
c_E = _p('E')

c_f = _p('f')
c_F = _p('F')

c_g = _p('g')
c_G = _p('G')

c_h = _p('h')
c_H = _p('H')

c_i = _p('i')
c_I = _p('I')

c_j = _p('j')
c_J = _p('J')

c_k = _p('k')
c_K = _p('K')

c_l = _p('l')
c_L = _p('L')

c_m = _p('m')
c_M = _p('M')

c_n = _p('n')
c_N = _p('N')

c_o = _p('o')
c_O = _p('O')

c_p = _p('p')
c_P = _p('P')

c_q = _p('q')
c_Q = _p('Q')

c_r = _p('r')
c_R = _p('R')

c_s = _p('s')
c_S = _p('S')

c_t = _p('t')
c_T = _p('T')

c_u = _p('u')
c_U = _p('U')

c_v = _p('v')
c_V = _p('V')

c_w = _p('w')
c_W = _p('W')

c_x = _p('x')
c_X = _p('X')

c_y = _p('y')
c_Y = _p('Y')

c_z = _p('z')
c_Z = _p('Z')

c_0 = _p('0')
c_1 = _p('1')
c_2 = _p('2')
c_3 = _p('3')
c_4 = _p('4')
c_5 = _p('5')
c_6 = _p('6')
c_7 = _p('7')
c_8 = _p('8')
c_9 = _p('9')

c_space = _p(' ')
c_exclamation_mark = _p('!')
c_quotation_mark = _p('"')
c_number_sign = _p('#')
c_colon = _p(':')
c_semicolon = _p(';')
c_less_than = _p('<')
c_grave_accent = _p('`')
c_tilde = _p('~')

c_null = key(0)
c_table = key(7)  # carriage_return \r

c_backspace = key(8)
c_tab_key = key(9)  # \t
c_line_end = key(10)
c_vtable = key(11)
c_carriage_return = key(13)  # aka Vertical Tab \r\n
c_esc = key(27)
c_delete127 = key(127)

c_home = control(71)
c_up = control(72)
c_pgup = control(73)
c_left = control(75)
c_right = control(77)
c_end = control(79)
c_down = control(80)
c_pgdown = control(81)
c_insert = control(82)
c_delete = control(83)

c_f1 = f(59)
c_f2 = f(60)
c_f3 = f(61)
c_f4 = f(62)
c_f5 = f(63)
c_f6 = f(64)
c_f7 = f(65)
c_f8 = f(66)
c_f9 = f(67)
c_f10 = f(68)
c_f11 = control(133)
c_f12 = control(134)

ctrl_a = key(1)
ctrl_b = key(2)
ctrl_c = key(3)
ctrl_d = key(4)
ctrl_e = key(5)
ctrl_f = key(6)
ctrl_g = key(7)
ctrl_h = key(8)
ctrl_i = key(9)
ctrl_j = key(10)
"""Ctrl+J and Ctrl+M are the same on Linux"""
ctrl_k = key(11)
ctrl_l = key(12)
ctrl_m = key(13)
"""Ctrl+J and Ctrl+M are the same on Linux"""
ctrl_n = key(14)
ctrl_o = key(15)
ctrl_p = key(16)
ctrl_q = key(17)
"""Ctrl+Q doesn't exist on Linux"""
ctrl_r = key(18)
ctrl_s = key(19)
"""Ctrl+S doesn't exist on Linux"""
ctrl_t = key(20)
ctrl_u = key(21)
ctrl_v = key(22)
ctrl_w = key(23)
ctrl_x = key(24)
ctrl_y = key(25)
ctrl_z = key(26)
"""Ctrl+Z has a special function on Linux"""
