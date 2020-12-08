# V2 Player Flutter App

<br />

## Localization

### Install Dependencies

Edit `pubspec.yaml`:

```
dependencies:
  ...
  flutter_localizations:
    sdk: flutter

dev_dependencies:
  intl_translation:
  ...
```

<br />

### Usage

**STEP 1** - Generate .arb files from AppLocalization class:

```
flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/localization/locales lib/localization/localization.dart
```

<br />

**STEP 2** - Generate Message classes from .arb files:

```
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/localization/locales --no-use-deferred-loading lib/localization/localization.dart lib/localization/locales/intl_*.arb
```

<br />

### _Notice_

DO NOT edit files in `lib/localization/locales`

<br /><br />

## Enable File Sharing for iOS

cd into `ios/Runner/Info.plist` and add:

```
<key>UIFileSharingEnabled</key>
<true/>
```

<br /><br />

## Issues & Solutions

- Lorem issues
- ...
- ...
- Ipsum Solutions

<br /><br />

## Todos

- Add Lisence file
- Multi-select & bulk action feature
  - Multi delete or move
  - High light folder section (dim light rest)
  - Shake folders (optional)
- Folder icon long press to show dropdown menu
- **Air Drop** file from Mac to iPhone/iPad
- **Air Drop** file from iPhone/iPad to Mac
- Share file from app to other app
- iPad layout optimization **(important)**
