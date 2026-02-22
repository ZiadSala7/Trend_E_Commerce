# Google Play Submission Checklist for Trend

## 1. Create release signing key

From the project root, run:

```bash
keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
& "C:\Program Files\Java\jdk-23\bin\keytool.exe" -list -v -keystore $env:USERPROFILE\upload-keystore.jks
```

Store the keystore file and passwords securely. **If you lose them, you cannot update your app on Google Play.**

## 2. Configure signing

1. Copy `android/key.properties.example` to `android/key.properties`
2. Edit `key.properties` and set:
   - `storePassword` – password for the keystore
   - `keyPassword` – password for the key
   - `keyAlias` – `upload` (or the alias you used)
   - `storeFile` – path to the keystore, e.g. `../upload-keystore.jks` (relative to `android/`)

## 3. Build the App Bundle (AAB)

Google Play uses Android App Bundles, not APKs:

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## 4. Google Play Console setup

1. Create a [Google Play Developer](https://play.google.com/console) account ($25 one-time fee)
2. Create a new app
3. In **App content**:
   - **Privacy policy** – add a URL (required if you collect data)
   - **App access** – declare if the app is free or requires login
   - **Ads** – declare if the app contains ads (no, for this app)
4. In **Release** → **Production** → **Create new release**:
   - Upload `app-release.aab`
   - Add release notes
5. In **Store settings**:
   - **Store listing** – title, short description, full description, screenshots, icon
   - **Content rating** – complete the questionnaire
   - **Target audience** – age groups
   - **News app** – if applicable
6. Submit for review

## 5. App configuration (already done)

- Target SDK 34 (Google Play requirement)
- App name: Trend
- Version from `pubspec.yaml` (1.0.0+1)

## 6. Optional: App Bundle Explorer

To test your AAB before upload:

```bash
bundletool build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=app.apks
bundletool install-apks --apks=app.apks
```
