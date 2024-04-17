# Contribution Guide

Please also check:

- [The terms](TERM.md)
- [The project structure](STRUCTURE.MD)
- [The abbreviations](ABBREVIATION.md)
- [The internationalization protocol](I18N_PROTOCOL.md)

## Getting Started

Clone the repository to a local folder.
Note: you have to put it in a folder named as `mimir`.

``` shell
git clone https://github.com/Liplum/Mimir mimir
```

Then run the necessary build steps.

``` shell
flutter pub get
flutter pub run build_runner build
```

Finally, build the SIT Life based on your platform.

```shell
# For Android
flutter build apk       # build for Android
# For Windows
flutter build winodws   # build for Windows
# For macOS
flutter build macos     # build for macOS
flutter build ios       # build for iOS
# For Linux
flutter build linux     # build for Linux
```

### iOS Build

SIT Life for iOS requires `Xcode 13.4.1`, the latest Xcode 13.
You can download it [here](https://developer.apple.com/download/all/?q=Xcode%2013.4.1).

Be aware that Xcode 14 or higher doesn't work due to the compatibility issue of some dependencies.

## Dependency

## Code Style

### Dart

As to formatting, please follow what `dart format` does.
The dedicated configuration for Kite is `line length: 120`.
You can run the command below to format the whole project by this principle.

```shell
dart format . -l 120
```

As to naming principle, please follow
the [official naming convention](https://dart.dev/guides/language/effective-dart/style).

To be flexible and easy to reconstruct,
`relative import` should be applied, meanwhile, `absolute import` should be applied outside.

### Json

As to formatting, the indent is 2 spaces.

As to naming, please keep the key `lowerCamelCase`,
which can be mapped to a valid dart variable name.

### Build Tool

Build tool always works on the latest python.
Requirements:

```
ruamel.yaml
#IF Windows
    pywin32
#ELSE
    curses
#ENDIF
```

The [entry point](/tool/main.py) is located in [tool folder](/tool).

If the current working directory is [the root of project](..).

```shell
python ./tool/main.py
```

Build tool will locate the project automatically,
so you can run the [main.py](/tool/main.py) anywhere.


### Web icon
Generated on https://realfavicongenerator.net/
