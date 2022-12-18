# Structure of Kite App

## Module

`Module` is a unit of Kite app, independent of each other.

A module has several parts in general:
- `Entity`: sharing a uniform type system via network communication or serialization.
- `Service`: including the networking, serialization


## Root
- The GitHub-related folder: `.github`
- Each platform specific subproject, such as `winodws`,`linux`, `iOS` ,`macOS`, `android` and `web`.
- The `l10n` folder for localization-related files.
- The `tool` folder.
- The `test` folder for testing dart code.
- The `lib` folder contains most codes of Kite App.
- The `resource` folder contains several fonts.
- The `assets` folder contains the images, icons and fonts.

## Folder lib
The following are in alphabetical order.
