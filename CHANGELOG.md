# Changelog

## 2.6.4
- Redesigned edu email inbox page and mail details page.

## 2.6.3
- Migration of new storage structure of timetable and palette.
- Added UUID in timetables, timetable palette, and game records.
- Clear game records on start up.
- Permission requests.
- Access SIT YWB and electricity bypass VPN.
- Detecting OA password changed outside the app.
- [Demo mode] one demo accounts with games, and another one without.

## 2.6.2
- Users are required to accept *Privacy Policy* and *Terms of Services* at the first use.
- Added *Privacy Policy* and *Terms of Services* versioning.
- Added CN bureau advice for games.

## 2.6.1
- Users are required to accept *Privacy Policy* and *Terms of Services* on login page.
- Added Edu email settings page.
- Improved i18n of settings pages.

## 2.6.0
- Renamed URL scheme to `sitlife`.
- Fixed timetable importing issues for postgraduate.
- Controlled by App Feature.
- Updated ICP licence.
- [Android] Support of `x86` and `x86_64` was back.
- More tips when logging in, especially for freshmen.
- Added Topping up in expense records.
- Bumped Minimum macOS support to 10.15.
- Updated Apple Developer Program.
- [tools] Avoiding build failure due to upgrading more than 1 build number but less than 3 at once.
- Timetable files can be opened with the app on both Android and iOS.
- Sync the timetable to the latest, and auto-sync.
- Improved the logic of proxy settings.
- Updated APK signature.
- Agreements are required to be accepted before use.
- Redesign timetable prefab patch set card.
- Reset version to 2.6.1+1.
- No collecting device info off debug mode and dev mode.

## v2.5.2
- Remember selected semester info only in current session.
- Introduced Mimir User agent.
- A convenient theme mode switcher in the timetable palette editor was added.
- Updated the built-in timetable palettes with inverse text color.
- A new deep link handler, Go route, to navigate to an in-app route.
Usage: `sitlife://go/any-route`. And in FeaturedMarkdownWidget, it has a shorthand, `/any-route`.
- Sign in Ing Account.
- Renamed routes.
- Updated campus timetable on Fengxian campus and the first teaching building.
- Timetable patch recommendations.
- Unified the swipe-to-delete action on both TimetablePatch and TimetablePatchSet.
- Keep html and markdown widgets alive to improve performance.
- A new deep link handler, Open webview, to open a page in the in-app webview.
Usage: `sitlife://webview/https://www.mysit.life`.
- Redesigned the style of AppCard.
- Rewrote the SSO authorization logic of Undergrad registration session and SSO session.
- Open SIT YWB application in webview or browser.

## v2.5.1
- Revealed the `game` navigation.
- Redesigned details pages of OA announcement and second class activity.
- Added Forum page.
- Added bulletin, temporarily display on the forum app card.
- Settings for hiding `game` navigation.
- Checking connectivity of the school server.
- Display disqualified tag on exam card.
- Display exam result and arrangement in descending order.

## v2.4.3
- Fixed 2048 not working on portrait mode.
- [Android] support predictive back gesture.
- Fixed color issues of Wordle on light mode
- Fixed translucent colors in timetable palette not working with theme harmonization.
- [Android] drop the support of `x86` and `x86_64`.
- Changed default locale to `zh_Hans`.
- The support to reset Sudoku game.
- Importing timetable form the next school year was allowed.
- Display check connectivity sheet when importing timetable.
- Display the best score and the max value of 2048 on app card.

## v2.4.2
- Introduced Sudoku game.
- Introduced a new navigation page, Game. (dev mode only)
- Improved visual effects of minesweeper.
- Game will pause when putting app into background.
- Game records: play again & share the game with QR code.
- Introduced Wordle game. (dev mode only)
- Save image of QR code.
- Timetable built-in start date and related student ID.
- [macOS] Deep link supports.
- Fixed authentication issue of undergraduate registration.

## v2.4.1
- Changed the custom URL and provided backward compatibility:
  - scheme: from `life.mysit` to `sit-life`.
  - Added host, `timetable`, for timetable-related data.
- Changed timetable file format and provided backward compatibility.
- Fixed QR code scanner issue.
- [Dev] Added debug deep link tile in developer options.
- Timetable *Out of Range* issue.

## v2.4.0
- Redesigned the expense statistics page.
- Redesigned the network tool page.
- Changed duration of skipping update up to 7 days.
- Changed web icons.
- Timetable background support on web.
- Fixed: Gif image not working in timetable wallpaper
- Allowed to join QQ group on desktop and web.
- [Demo mode] Attended activity mock service in class 2nd.
- Timetable issue inspection.
- Prompt user to save changes before quit.
- Timetable courses can be hidden now.
- Toggle haptic feedback in game settings.
- Toggle quick look lesson on tap feature in timetable settings.
- Improved zh-Hans and zh-Hant localization.
- Timetable patch for moving, copying, swapping and removing lessons of days.
- Shrunk the size of .ics file exported from timetable.
- Redesigned entities of proxy.
- [BREAKING CHANGES] New QR code formats of timetable palette and proxy.
- Share timetable in QR code.
- [Migration] Proxy settings and timetable background.
- [iOS] Shortcut for importing .ics file to Calendar app.
- Redesigned pull down menu.

## v2.3.0
- The 2048 game supports save/load feature.
- You can add, delete, and edit courses in the timetable.
- The Timetable is now more colorful than ever.
- Improved "Classic" timetable color palette.
- A new page for customizing theme colors has been added.
- You can withdraw applications of second class activities.
- The Cache is no longer cleared when the device runs out of storage space.
- Other minor UI improvements and localizations.

## v2.2.0
- The Minesweeper game was introduced.
- Login-related error dialogs now have detailed description.
- [Bug fix] Wrong localization text.
- UI and performance improvement.

## v2.1.3
- More types of OA login errors can be recognized.
- Except for iOS and macOS, the app automatically checks update on startup.
- By following school changes, electricity price rises from 0.61 to 0.636.
- [iOS] It's supported to scan QR code generated from this app with Camera app.
- [Bug fix] In some cases, OA captcha is infinitely asking for input, but the login doesn't work.

## v2.1.2
- GPA calculator was added.
- Library searching and borrowing list were added.
- HTTP and HTTPS proxy settings page was added.
- The UI of some pages was redesigned.
- ICP licence was added.
- [Bug Fix] Applying for a second classroom activity would make a double-application.
- [Bug Fix] In some cases, it is not possible to load the activities already attended in the second class.
