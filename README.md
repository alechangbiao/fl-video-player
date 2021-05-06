# V2 Player Flutter App

<br />

## Documentation

- [Configure Localization](#localization)

  - [Installation](#install-dependencies)
  - [How to use it](#usage)

- [File Sharing Permissions](#enable-file-sharing-for-iOS)
- [Image-Picker-Configuration](#image-picker)
- [Issues & Solutions](#issues-&-solutions)
- [Todos](#todos)

<br /><br />

## Localization

### Install Dependencies

Edit `pubspec.yaml`:

```yaml
# Add denpendecies
dependencies:
  ...
  flutter_localizations:
    sdk: flutter
  intl: ^0.17.0-nullsafety.2
  ...

# Enable code generation support for Localization
flutter:
  ...
  generate: true
```

<br />

### Usage

**STEP 1** - Create `${FLUTTER_PROJECT}/l10n.ymal` for localization configuration

<br />

**STEP 2** - Create `${FLUTTER_PROJECT}/lib/l10n` for input files

<br />

**STEP 3** - In `${FLUTTER_PROJECT}/lib/l10n`, add the `app_en.arb` template file:

```json
{
  "helloWorld": "Hello World!",
  "@helloWorld": {
    "description": "The conventional newborn programmer greeting"
  }
}
```

<br />

**STEP 4** - Generate localization code

```sh
flutter pub get
```

<br /><br />

## Enable File Sharing for iOS

cd into `ios/Runner/Info.plist` and add:

```xml
<key>UIFileSharingEnabled</key>
<true/>
```

<br />

## Image Picker

### Install Dependencies

Edit `pubspec.yaml`:

```yaml
dependencies:
  ...
  image_picker:
```

Add the following keys to your Info.plist file, located in `<PROJECT_ROOT>/ios/Runner/Info.plist`:

`NSPhotoLibraryUsageDescription` - describe why app needs permission for the photo library. It's called _Privacy - Photo Library Usage Description_ in the visual editor.

`NSCameraUsageDescription` - describe why your app needs access to the camera. It's called _Privacy - Camera Usage Description_ in the visual editor.

`NSMicrophoneUsageDescription` - describe why app needs access to the microphone, if intend to record videos. It's called _Privacy - Microphone Usage Description_ in the visual editor.

<br /><br />

## Issues & Solutions

### iOS Local Network Permissions for Debug

For detailed information [click here](https://flutter.dev/docs/development/add-to-app/ios/project-setup#local-network-privacy-permissions)

<br />

### Unsound null safety

Testing or running mixed-version programs

```sh
flutter run --no-sound-null-safety -v
```

Alternatively, set the language version in the entrypoint — the file that contains main() function — to 2.9. In Flutter apps, this file is often named lib/main.dart. In command-line apps, this file is often named bin/<packageName>.dart. You can also opt out files under test, because they are also entrypoints.

`lib/main.dart:`

```dart
// @dart=2.9
import 'src/my_app.dart';
import ...

main() {
  //...
}
```

For more information [click here](https://dart.dev/null-safety/unsound-null-safety)

<br /><br />

## Todos

- Add Lisence file
- Add snakbar to withdraw moving/deleting files
- Add triggers when new files are added to app from AirDrop/MacBook/etc.
- Multi-select & bulk action feature
  - Multi delete or move
  - High light folder section (dim light rest)
  - Shake folders (optional)
- Folder icon long press to show dropdown menu
- **Air Drop** file from Mac to iPhone/iPad
- **Air Drop** file from iPhone/iPad to Mac
- Share file from app to other app
- Integrate with 'File' app on iOS
- Add file or directory to 'File' app on iOS
- iPad layout optimization **(important)**

## Steps to Migrate Project from Scratch

1. Create project `flutter create <name>`
2. Copy `README.md` & `.gitignore` file from old project
3. Open `ios/Runner.xcworkspace` and edit _Bundle Identifier_ to `com.v2player.flutter.app`
4. Copy dependencies & edit configs from `pubsepc.ymal`
5. Copy & edit configs from `ios/Runner/Info.plist`
6. Debug once to make permissions to take effect
7. Copy `l10n.yaml` file, `assets` `lib` & `test` directory to project and run `flutter pub get`
