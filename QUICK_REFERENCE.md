# Quick Reference Card - Solar Unloading App

## 🚀 Quick Commands

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Build release APK
flutter build apk --release
```

## 📱 App Flow

```
Login → Home → [Unloading Log] / [Installation Log] → Save → Firestore
```

## 🔑 Default Test Credentials

**Create in Firebase Console:**
- Email: `test@example.com`
- Password: `password123`

## 📋 Unloading Log Fields

| Field | Type | Notes |
|-------|------|-------|
| Date | Auto | Current date |
| Farmer Name/ID | Text | Required |
| Material Type | Text | Required |
| Serial Number | Text | From QR or manual |
| QR Image | Image | Auto-captured |
| Photos | Images | Multiple allowed |

**Button:** Scan QR Code → Auto-fills serial number + captures QR image

## 🔧 Installation Log Fields

| Field | Type | Notes |
|-------|------|-------|
| Date | Auto | Current date |
| Farmer Name/ID | Text | Required |
| Serial Number | Text | Required |
| Installation Photos | Images | **MANDATORY** |
| Issue Photos | Images | Optional |

## 🗄️ Firestore Collections

### `unloading_log`
```javascript
{
  date: timestamp,
  farmer: string,
  materialType: string,
  serialNumber: string,
  qrImageUrl: string,
  unloadingPhotoUrls: array,
  enteredBy: string,
  createdAt: timestamp
}
```

### `installation_log`
```javascript
{
  date: timestamp,
  farmer: string,
  serialNumber: string,
  installationPhotoUrls: array,
  issuePhotoUrls: array,
  enteredBy: string,
  createdAt: timestamp
}
```

## 📂 Firebase Storage Structure

```
/unloading/
  ├── 1234567890.jpg  (QR images)
  ├── 1234567891.jpg  (unloading photos)
  └── ...

/installation/
  ├── 9876543210.jpg  (installation photos)
  ├── 9876543211.jpg  (issue photos)
  └── ...
```

## 🔐 Firebase Setup (One-Time)

1. **Create Firebase Project** → console.firebase.google.com
2. **Add Android App** → Package: `com.solarunloading.solar_unloading_app`
3. **Download** `google-services.json` → Place in `android/app/`
4. **Update** `lib/firebase_options.dart` with config values
5. **Enable Services:**
   - Authentication (Email/Password) ✓
   - Firestore Database ✓
   - Storage ✓
6. **Create Test User** in Authentication

## 🛠️ Troubleshooting

| Problem | Solution |
|---------|----------|
| Flutter not found | Install Flutter SDK + add to PATH |
| Firebase init error | Check `google-services.json` location |
| Camera not working | Grant camera permission in device settings |
| QR scanner black | Test on physical device (not emulator) |
| Upload fails | Check internet + Storage enabled |

## 📦 Dependencies

```yaml
firebase_core: ^2.24.2      # Firebase init
firebase_auth: ^4.16.0      # Authentication
cloud_firestore: ^4.14.0    # Database
firebase_storage: ^11.6.0   # File storage
qr_code_scanner: ^1.0.1     # QR scanning
image_picker: ^1.0.7        # Photo selection
intl: ^0.18.1               # Date formatting
```

## 🎯 Features Included

✅ Email/Password Login  
✅ QR Code Scanning  
✅ Image Capture & Upload  
✅ Unloading Logs  
✅ Installation Logs  
✅ Firebase Integration  

## ⛔ NOT Included (MVP)

❌ Reports  
❌ Export (PDF/Excel)  
❌ Dashboards  
❌ User Roles  
❌ Offline Sync  
❌ Edit/Delete  

## 📊 Firebase Free Tier Limits

- **Auth:** 10,000 verifications/month
- **Firestore:** 50,000 reads, 20,000 writes/day
- **Storage:** 5 GB stored, 1 GB/day download

**Good for:** ~100+ daily logs with photos

## 🔒 Security Rules (Test Mode)

**Expires:** 30 days after creation  
**Action:** Update to production rules before deploying

```javascript
// Production: Require authentication
allow read, write: if request.auth != null;
```

## 📱 App Screens

1. **Login** - Email + Password
2. **Home** - Navigation buttons
3. **Unloading Log** - Form with QR scanner
4. **Installation Log** - Form with photo requirements

## 🎨 Design Principles

- **Mobile-First** - Optimized for phone screens
- **Field-Friendly** - Works in field conditions
- **Minimal Clicks** - Fast data entry
- **Reliable** - Simple, proven tech stack

## 📄 Key Files

```
lib/
├── main.dart                      # Entry point
├── firebase_options.dart          # ⚠️ UPDATE THIS
└── screens/
    ├── login_screen.dart
    ├── home_screen.dart
    ├── unloading_log_screen.dart
    └── installation_log_screen.dart

android/app/
└── google-services.json           # ⚠️ DOWNLOAD FROM FIREBASE
```

## 🚦 Deployment Checklist

- [ ] Update Firebase security rules (production)
- [ ] Test on multiple Android devices
- [ ] Build release APK
- [ ] Test release APK
- [ ] Train field workers
- [ ] Deploy

## 📞 Support Resources

- **Flutter Docs:** https://flutter.dev/docs
- **Firebase Docs:** https://firebase.google.com/docs
- **QR Scanner:** Check device camera permissions

---

**Version:** 1.0.0  
**Platform:** Android (API 21+)  
**License:** Internal Use  
