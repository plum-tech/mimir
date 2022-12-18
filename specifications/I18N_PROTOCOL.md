# I18n and L10n

## Toolchain

Mímir
utilized [flutter_localizations](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
and [intl](https://github.com/dart-lang/intl) for internationalization and localization.

By running the commands blow, the mapped-classes of all languages will be generated.

``` shell
% flutter gen-l10n
```

And then the mapped-classes will be found in this [dart-generated](../.dart_tool/flutter_gen/gen_l10n)
folder.

To reference them, you should import those dart files first:

``` dart
import 'package:mimir/l10n/extension.dart';
```

And then access any translation key you want:

``` dart
var response = i18n.yes;
response = i18n.no;
```

You can also add, remove, modify or even support a new language in the [l10n](../l10n) folder.

The [app_en.arb](../l10n/app_en.arb) is the template localization, hereinafter referred to
as `template`, which means any structural change will affect other languages.

There is a tool for i10n that will be mentioned later, please check
its [homepage](https://github.com/liplum/L10nArbTool) on GitHub.

More readings:

- https://phrase.com/blog/posts/flutter-localization
- https://blog.logrocket.com/internationalization-flutter-apps
- https://localizely.com/flutter-arb
- https://medium.com/@angga.arifandi/flutter-localization-with-arb-made-simple-c03da609dcaf
- https://plugins.jetbrains.com/plugin/13666-flutter-intl

## Internationalization Protocol

I18n aims to build a flexible and low coupling system/scaffold for the collaboration of programming
and localization.

### Naming the Translation Key

1️⃣ Generally, keep the translation key following
the [dart variable naming convention](https://dart.dev/guides/language/effective-dart/style).

``` json
// Good
"id": "ID",
"phoneNumber" : "Phone Number"

// Bad
"Address": "Address",
"TEL": "Tel."
```

2️⃣ For frequent words and phrases used in real life or computer specification, use them in naming
unambiguously.

``` json
// Good
"foodNotFoundInListError": "Sorry, what you chosen isn't found in this list."

// Bad
"findFoodWrongInList": "Sorry, what you chosen isn't found in this list."
```

3️⃣ Use the common abbreviation instead of a long phrase or any word that has a conventional
abbreviation.

Please check [the abbreviation](ABBREVIATION.md) Mímir used.

``` json
// Good
"food4Cat":"The food for cats",
"copy2clipboard" : "Copy to Clipboard",
"displayPwd": "Show password"

// Bad
"AddInformation" "Add Information", // use "Info" instead
""
```

4️⃣ Avoid third-person singular verbs and plural nouns under unnecessary circumstances.

``` json
// Good
"opNotSupport" : "This operation doesn't support",
"catNumber": "Number of cats",

// Bad
"operationDoesntSupport" : "This operation doesn't support",
"catsNumber": "Number of cats"
```

5️⃣ Use formal words instead of phrases all the time, unless there is a frequent word short enough.

``` json
// Good
"remove" : "Remove",
"popeleNumber" : "Number of people",

// Bad
"getRidOf" : "Remove",
"numberOfPeople" : "Number of people",
```

### Used in controls

1️⃣ For the `toast`, `pop-up`, `tooltip` and `flash`, suffix the translation key with:

- `Tip`: If users did well. To tip users something. e.g.: `changedPwdTip`, `unsavedChangeTip`
- `Tooltip`: e.g.: `buttonTooltip`.
- `Warn`: If users did something wrong. e.g.: `phoneNumberInputEmptyWarn`.
- `Error`: If an error appeared. e.g.: `disconnectedError`,`networkTimeoutError`.

**Purpose:** It's free to switch the form of expression without any change of translation key.

2️⃣ For any `request dialog`, suffix the translation key with:

- `Request`: If app wants users to do something. e.g.: `changePwdRequest`
  ,`addPersonalInfoRequest`

**Purpose:** It emphasizes the right tone in front of users.

3️⃣ For `Button`, `Label`, `Title` and other controls, suffix the translation key with the current
layer.

- Such as `freshmanProfileTitle`, `freshmanAddInfoTitle`, `addInfoButton`.
- For `Subtitle`, use a short name: `settingsLanguageSub`
  **Purpose:** It's clear to find the corresponding control in a layer-based UI.

4️⃣ For grouping, prefix the key with its group name.

- `settings`, such as `settingsLanguage`, `settingsDarkMode`.
- For any function type, such as `expenseTrackerHistory`.

### Formatting Overloading

When it comes to overload placeholder functions, suffix with the abbreviation of its parameter
signature in alphabetical order, for example:

``` json
"dormitoryDetailed_bbcr": "Room {room} Bed {bed} {building} {campus}",
"dormitoryDetailed_bbr": "Room {room} Bed {bed} {building}",
"dormitoryDetailed_br": "Room {room} {building}",
"dormitoryDetailed_bcr": "Room {room} {building} {campus}"
```

The best practice is to add the first alphabet in lowercase for each parameter sequentially after an
underscore.

## Localization Protocol

I10n is designed to assist translation workers to understand in a comprehensive manner, which comes
with a new workflow.

### Language style

#### For English

- Perform formal and standard wording.
- For long words, prefer to use emoji and keep it clear.

#### For Simplified Chinese

- Perform friendly and cute wording.
- Perform a bit of Internet slang.

- 使用 "你" 代替 "您"

#### For Traditional Chinese

- Perform more localized wording

- 用可爱的句末语气词

#### Wording

Reduce the programming specific terms and help users understand what happened more clearly.

``` kotlin
// Good
"""
The network seems in trouble.
Your application for suspension isn't sent. Please try again later.
"""

"""
Something is wrong. Please try again later.
"""

// Bad
"""
ConnectionTimeoutException at stacktrace....
Your Operation failed.
"""

"""
Unknown exception. Your opeartion was cancelled.
"""
```

### Editing .arb File

1️⃣ Keep the order of other l10n files identical to the `template`.

2️⃣ It'd be better to attach a description for every translation entry, as mentioned below,
in `template`
to hint localization workers and programmer the usage of those entries.

``` json
"cantLaunchQqSo2Clipboard": "QQ number has been copied because QQ isn't available.",
"@cantLaunchQqSo2Clipboard": {
  "description": "Used in Freshman vCard when QQ.app can't be launched."
}
```

3️⃣ Use string-format syntax to help workers organize the word order for all languages, such as
English, Chinese and Japanese.

``` json
"dormitoryDetailed": "Room {room} Bed {bed} {building}",
"@dormitoryDetailed": {
  "placeholders": {
    "room": {
      "type": "int",
      "example": "401"
    },
    "bed": {
      "type": "String",
      "example": "4"
    },
    "building": {
      "type": "String"
    }
  }
}
```

4️⃣ Do not copy `description` and `placeholders` from meta keys, prefixed with `@`, in `template` to
a concrete language one.

## Localization Arb Tool

[L10ArbTool](https://github.com/liplum/L10nArbTool)
allows you to edit and manage .arb files with an interactive CLI.

```shell
git clone https://github.com/liplum/L10nArbTool.git
cd L10nArbTool
python main.py migration
```
