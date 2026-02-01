# Firebase Setup Checklist

## Step-by-Step Firebase Configuration

### 1. Create Firebase Project

- [ ] Go to https://console.firebase.google.com/
- [ ] Click "Add project"
- [ ] Enter project name (e.g., "Solar Unloading")
- [ ] Disable Google Analytics (optional, to keep it simple)
- [ ] Click "Create project"

### 2. Add Android App

- [ ] Click "Add app" button
- [ ] Select Android icon
- [ ] Enter package name: `com.solarunloading.solar_unloading_app`
- [ ] App nickname: "Solar Unloading App"
- [ ] Leave SHA-1 blank (not needed for basic auth)
- [ ] Click "Register app"

### 3. Download google-services.json

- [ ] Download `google-services.json` file
- [ ] Save it to: `android/app/google-services.json`
- [ ] Verify the file is in the correct location

### 4. Get Firebase Configuration

From Firebase Console → Project Settings → Your apps (scroll down):

- [ ] Copy the following values:
  - apiKey: `_______________________________`
  - appId: `_______________________________`
  - messagingSenderId: `_______________________________`
  - projectId: `_______________________________`
  - storageBucket: `_______________________________`

- [ ] Update `lib/firebase_options.dart` with these values

### 5. Enable Authentication

- [ ] Go to Authentication → Get started
- [ ] Click "Sign-in method" tab
- [ ] Enable "Email/Password"
- [ ] Click "Save"
- [ ] Go to "Users" tab
- [ ] Click "Add user"
- [ ] Add test user:
  - Email: `test@example.com`
  - Password: `password123`

### 6. Enable Firestore Database

- [ ] Go to Firestore Database
- [ ] Click "Create database"
- [ ] Select "Start in test mode"
- [ ] Choose location (e.g., asia-south1 for India)
- [ ] Click "Enable"

**Security Rules (Test Mode):**
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2026, 3, 1);
    }
  }
}
```

⚠️ **WARNING:** Test mode rules expire after 30 days. Update before production.

### 7. Enable Firebase Storage

- [ ] Go to Storage
- [ ] Click "Get started"
- [ ] Start in "Test mode"
- [ ] Use default location
- [ ] Click "Done"

**Security Rules (Test Mode):**
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.time < timestamp.date(2026, 3, 1);
    }
  }
}
```

### 8. Verify Setup

- [ ] Confirm google-services.json is in `android/app/`
- [ ] Confirm firebase_options.dart has correct values
- [ ] Confirm Authentication is enabled with Email/Password
- [ ] Confirm Firestore Database is created
- [ ] Confirm Storage is enabled
- [ ] Test user is created in Authentication

### 9. Run Flutter App

```bash
flutter pub get
flutter run
```

- [ ] App launches successfully
- [ ] Can login with test user credentials
- [ ] Can navigate to Home screen
- [ ] Can access Unloading Log screen
- [ ] Can access Installation Log screen

## Collections Will Be Auto-Created

When you save your first log, Firestore will automatically create these collections:

- `unloading_log`
- `installation_log`

No manual setup needed for collections!

## Production Security Rules (Update Later)

### Firestore (Production)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /unloading_log/{document} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    match /installation_log/{document} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

### Storage (Production)
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /unloading/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    match /installation/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## Troubleshooting

### "Default FirebaseApp is not initialized"
- Verify google-services.json is in android/app/
- Check that plugin is applied in android/app/build.gradle
- Run `flutter clean` and `flutter pub get`

### "User not authenticated"
- Verify Email/Password is enabled in Authentication
- Check test user exists
- Try creating a new user in Firebase Console

### "Permission denied" on Firestore/Storage
- Verify you're in Test Mode
- Check that test mode hasn't expired
- Make sure user is logged in

---

✅ Once all checkboxes are complete, your Firebase setup is ready!
