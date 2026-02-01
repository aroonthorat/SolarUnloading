# Solar Unloading App - Development Notes

## Quick Start Commands

### First Time Setup
```bash
# Navigate to project
cd "e:\Codespace\Solar Unloading"

# Get dependencies
flutter pub get

# Run app (with connected device/emulator)
flutter run
```

### Development Commands
```bash
# Check Flutter installation
flutter doctor

# Clean build files
flutter clean

# Get dependencies
flutter pub get

# Run in debug mode
flutter run

# Run in release mode
flutter run --release

# Build APK
flutter build apk --release

# View logs
flutter logs
```

## Project Structure

```
Solar Unloading/
├── lib/
│   ├── main.dart                      # Entry point
│   ├── firebase_options.dart          # Firebase config
│   └── screens/
│       ├── login_screen.dart          # Login
│       ├── home_screen.dart           # Home dashboard
│       ├── unloading_log_screen.dart  # Unloading + QR scanner
│       └── installation_log_screen.dart # Installation
├── android/                           # Android native code
├── pubspec.yaml                       # Dependencies
├── README.md                          # Main documentation
├── FIREBASE_SETUP.md                  # Firebase setup guide
└── DEV_NOTES.md                       # This file
```

## Key Dependencies

- **firebase_core** - Firebase initialization
- **firebase_auth** - User authentication
- **cloud_firestore** - NoSQL database
- **firebase_storage** - Image storage
- **qr_code_scanner** - QR code scanning
- **image_picker** - Image selection
- **intl** - Date formatting

## Firebase Configuration

Before running, you must:

1. Create Firebase project
2. Download `google-services.json` → place in `android/app/`
3. Update `lib/firebase_options.dart` with your Firebase config
4. Enable Authentication (Email/Password)
5. Enable Firestore Database
6. Enable Storage

See `FIREBASE_SETUP.md` for detailed steps.

## Testing

### Test User Credentials
Create in Firebase Console → Authentication → Users:
- Email: `test@example.com`
- Password: `password123`

### Test Flow
1. Launch app
2. Login with test credentials
3. Navigate to "Add Unloading"
4. Fill form fields
5. Scan QR code (or enter serial manually)
6. Add photos
7. Save
8. Check Firestore Console for new document
9. Check Storage Console for uploaded images

## Common Issues

### Flutter not found
- Install Flutter SDK
- Add to PATH
- Run `flutter doctor`

### Firebase initialization error
- Check `google-services.json` location
- Verify `firebase_options.dart` has correct values
- Run `flutter clean` && `flutter pub get`

### Camera permission denied
- Grant camera permission in device settings
- Check AndroidManifest.xml has permissions

### QR scanner black screen
- Ensure camera permission is granted
- Check device has working camera
- Try on physical device (emulator cameras can be buggy)

### Image upload fails
- Check internet connection
- Verify Firebase Storage is enabled
- Check Storage rules allow write access

## MVP Scope

**INCLUDED:**
- Login (Email/Password)
- Unloading log with QR scan
- Installation log
- Image capture & upload
- Data save to Firestore

**NOT INCLUDED:**
- Reports
- Export (PDF/Excel)
- Dashboards
- User roles
- Offline sync
- Advanced validation
- AI features

## Future Enhancements (Post-MVP)

- [ ] View saved logs
- [ ] Search/filter logs
- [ ] Export to Excel
- [ ] Offline mode
- [ ] Push notifications
- [ ] Multi-user roles
- [ ] Dashboard analytics

## Performance Tips

- Use release mode for testing performance: `flutter run --release`
- Images are compressed before upload (handled by Firebase)
- Firestore indexes are auto-created for simple queries

## Security Notes

⚠️ **Test Mode Security Rules Expire**
- Firestore and Storage rules set to test mode
- Expire after 30 days
- Update to production rules before deploying

Production rules require authentication:
```
allow read, write: if request.auth != null;
```

## Deployment Checklist

- [ ] Update Firebase security rules (production mode)
- [ ] Test with multiple users
- [ ] Test on different Android devices/versions
- [ ] Build release APK: `flutter build apk --release`
- [ ] Test release APK on device
- [ ] Create user documentation
- [ ] Train field workers

## Support

For Flutter issues: https://flutter.dev/docs  
For Firebase issues: https://firebase.google.com/docs  

---

Built with Flutter 💙 and Firebase 🔥
