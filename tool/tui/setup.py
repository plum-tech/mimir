# !/usr/bin/env python
import platform

try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup
system_type = platform.system()

isWindows = platform.system() == "Windows"

reqs = []
if isWindows:
    reqs += [
        "pywin32"
    ]
else:
    reqs += [
        "curses"
    ]

setup(name='pytui',
      version='0.0.1',
      description='Text user interface in Python',
      author='Liplum',
      author_email='Li_plum@outlook.com',
      url='https://github.com/liplum/pytui',
      py_modules=[
          "timer",
          "filesystem",
          "multiplatform"
      ],
      packages=[
          'render',
          "input",
          'keys',
          "colortxt",
      ],
      install_requires=reqs
      )
