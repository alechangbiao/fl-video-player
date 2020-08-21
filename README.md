# V2 Player Flutter App

Xcode version: 11.5

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

### Usage

Generate .arb files from AppLocalization class:

```
flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/localization/locales lib/localization/localization.dart
```

Generate Message classes from .arb files:

```
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/localization/locales --no-use-deferred-loading lib/localization/localization.dart lib/localization/locales/intl_*.arb
```

## Issues & Solutions

## Todos
