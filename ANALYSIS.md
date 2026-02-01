# Analysis Document

## Project Overview

**Name:** Solar Unloading App  
**Type:** Mobile-First Android Application  
**Purpose:** Field work logging for solar pump material unloading and installation  
**Framework:** Flutter  
**Backend:** Firebase (Free Tier)  
**Status:** MVP Ready for Firebase Configuration  

## Architecture

### Frontend (Flutter)
- **Framework:** Flutter 3.x
- **Language:** Dart
- **UI:** Material Design 3
- **Platform:** Android (API 21+)

### Backend (Firebase)
- **Authentication:** Firebase Auth (Email/Password)
- **Database:** Cloud Firestore (NoSQL)
- **Storage:** Firebase Storage (for images)
- **Hosting:** Not required (mobile app)

### Key Technologies
- `qr_code_scanner` - QR code scanning via camera
- `image_picker` - Image selection from camera/gallery
- `intl` - Date formatting
- Firebase Flutter plugins for all Firebase services

## Database Design

### Collection 1: `unloading_log`

**Purpose:** Store unloading records with QR codes and photos

**Schema:**
```typescript
{
  date: Timestamp,              // Auto-generated (today)
  farmer: String,               // Farmer name or ID
  materialType: String,         // Type of material
  serialNumber: String,         // From QR or manual entry
  qrImageUrl: String,           // URL to QR code image in Storage
  unloadingPhotoUrls: Array<String>, // URLs to photos in Storage
  enteredBy: String,            // Email of logged-in user
  createdAt: Timestamp          // Server timestamp
}
```

**Indexes:** None required for MVP (Firestore auto-indexes)

**Security Rules:**
```javascript
match /unloading_log/{document} {
  allow read, write: if request.auth != null;
}
```

### Collection 2: `installation_log`

**Purpose:** Store installation records with mandatory and optional photos

**Schema:**
```typescript
{
  date: Timestamp,              // Auto-generated (today)
  farmer: String,               // Farmer name or ID
  serialNumber: String,         // Serial number
  installationPhotoUrls: Array<String>, // MANDATORY photos
  issuePhotoUrls: Array<String>,        // OPTIONAL issue photos
  enteredBy: String,            // Email of logged-in user
  createdAt: Timestamp          // Server timestamp
}
```

**Validation:** At least 1 installation photo required (enforced in app)

**Security Rules:**
```javascript
match /installation_log/{document} {
  allow read, write: if request.auth != null;
}
```

## Storage Structure

```
firebase-storage/
├── unloading/
│   ├── 1738408194123.jpg    (QR code images)
│   ├── 1738408194456.jpg    (unloading photos)
│   └── ...
│
└── installation/
    ├── 1738408298789.jpg    (installation photos)
    ├── 1738408299012.jpg    (issue photos)
    └── ...
```

**Naming Convention:** `{timestamp}.jpg`  
**Storage Rules:** Authenticated users can read/write

## User Flow

```
┌─────────────┐
│   Launch    │
│     App     │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    Login    │
│   Screen    │
└──────┬──────┘
       │ (authenticated)
       ▼
┌─────────────┐
│    Home     │
│   Screen    │
└──┬───────┬──┘
   │       │
   │       └────────────────┐
   │                        │
   ▼                        ▼
┌──────────────┐    ┌──────────────┐
│  Unloading   │    │Installation  │
│     Log      │    │     Log      │
└──────┬───────┘    └──────┬───────┘
       │                   │
       ▼                   ▼
   [QR Scan]          [Pick Photos]
       │                   │
       ▼                   ▼
  [Add Photos]         [Validate]
       │                   │
       ▼                   ▼
   [Save to              [Save to
    Firestore]            Firestore]
       │                   │
       ▼                   ▼
   [Upload to            [Upload to
    Storage]              Storage]
```

## Feature Breakdown

### 1. Authentication
- ✅ Email/Password login via Firebase Auth
- ✅ Session management
- ✅ Logout functionality
- ❌ Registration (admin creates users in console)
- ❌ Password reset

### 2. Unloading Log
- ✅ Auto-fill date (current date)
- ✅ Text input for farmer name/ID
- ✅ Text input for material type
- ✅ QR code scanner with camera
- ✅ Auto-fill serial number from QR
- ✅ Auto-capture QR image when scanned
- ✅ Multiple photo upload
- ✅ Save creates NEW record (no updates)
- ❌ Edit existing records
- ❌ Delete records

### 3. Installation Log
- ✅ Auto-fill date (current date)
- ✅ Text input for farmer name/ID
- ✅ Text input for serial number
- ✅ Mandatory installation photos (min 1)
- ✅ Optional issue photos
- ✅ Save creates NEW record
- ❌ Edit existing records
- ❌ Delete records

### 4. Image Management
- ✅ Camera capture
- ✅ Gallery selection
- ✅ Multiple image selection
- ✅ Image preview before upload
- ✅ Upload to Firebase Storage
- ✅ Store URLs in Firestore
- ❌ Image compression (Firebase handles)
- ❌ Offline caching

### 5. QR Code Scanning
- ✅ Live camera view
- ✅ Detect QR codes
- ✅ Extract serial number
- ✅ Capture QR image
- ❌ Barcode support
- ❌ Batch scanning

## NOT Included (MVP Scope)

The following features are explicitly excluded:

- ❌ AI/ML features
- ❌ Reports/Analytics
- ❌ PDF/Excel export
- ❌ Dashboards
- ❌ User management/roles
- ❌ Advanced validation
- ❌ Offline sync
- ❌ Data editing
- ❌ Data deletion
- ❌ Search functionality
- ❌ Filtering
- ❌ Sorting
- ❌ Pagination
- ❌ Push notifications
- ❌ Multi-language support
- ❌ Dark mode

## Performance Considerations

### Image Upload
- Images uploaded sequentially
- UI shows loading indicator
- Network failures show error message
- No retry logic (user must re-submit)

### Database Operations
- Each save is a new document (no updates)
- No optimization for duplicate data
- No data validation beyond mandatory fields

### Scalability
- Free tier limits:
  - Firestore: 50k reads, 20k writes/day
  - Storage: 5 GB total, 1 GB/day download
  - Auth: 10k verifications/month
- Estimated capacity: ~100-200 daily logs with 5 photos each

## Security Analysis

### Current (Test Mode)
```javascript
// Firestore & Storage
allow read, write: if request.time < timestamp.date(2026, 3, 1);
```
⚠️ **WARNING:** Anyone can read/write for 30 days

### Recommended (Production)
```javascript
// Firestore
match /unloading_log/{document} {
  allow read: if request.auth != null;
  allow create: if request.auth != null 
                && request.resource.data.enteredBy == request.auth.token.email;
  allow update, delete: if false;
}

// Storage
match /unloading/{filename} {
  allow read: if request.auth != null;
  allow write: if request.auth != null 
               && request.resource.size < 10 * 1024 * 1024  // 10MB limit
               && request.resource.contentType.matches('image/.*');
}
```

### Authentication Security
- Email/password only
- No password reset flow (admin manages)
- Session tokens managed by Firebase SDK
- Auto-logout on token expiry

## Deployment Requirements

### Developer Environment
1. ✅ Flutter SDK installed
2. ✅ Android SDK (API 34)
3. ✅ Android device or emulator
4. ✅ Firebase project created
5. ✅ google-services.json downloaded
6. ✅ firebase_options.dart configured

### Firebase Setup
1. ✅ Firebase project created
2. ✅ Android app registered
3. ✅ Authentication enabled (Email/Password)
4. ✅ Firestore database created
5. ✅ Storage enabled
6. ✅ Test user created
7. ⚠️ Security rules set (test mode for now)

### Build & Deploy
```bash
# Development
flutter run

# Release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

## Testing Strategy (Manual)

### Test Case 1: Login
1. Launch app
2. Enter test credentials
3. Click login
4. ✅ Should navigate to home screen
5. ✅ Should show user email

### Test Case 2: Unloading Log
1. Click "Add Unloading"
2. Fill farmer name
3. Fill material type
4. Click "Scan QR Code"
5. Scan a QR code
6. ✅ Serial number auto-filled
7. ✅ QR image captured
8. Add unloading photos
9. Click save
10. ✅ Success message shown
11. ✅ Navigate back to home
12. ✅ Check Firestore for new document
13. ✅ Check Storage for uploaded images

### Test Case 3: Installation Log
1. Click "Add Installation"
2. Fill farmer name
3. Fill serial number
4. Add installation photos
5. Add issue photos (optional)
6. Click save
7. ✅ Success message shown
8. ✅ Navigate back to home
9. ✅ Check Firestore for new document
10. ✅ Check Storage for uploaded images

### Test Case 4: Validation
1. Try to save without filling required fields
2. ✅ Should show validation errors
3. Try to save installation log without photos
4. ✅ Should show error: "Installation photos are mandatory"

## Known Limitations

1. **No Offline Support:** Requires internet connection
2. **No Data Editing:** Can only create new records
3. **No Image Compression:** Large images consume storage quickly
4. **Sequential Upload:** Slow for many images
5. **No Retry Logic:** Failed uploads require re-submission
6. **Test Mode Security:** Must update before production use
7. **No User Registration:** Admin must create users in console

## Cost Estimation (Firebase Free Tier)

**Scenario:** 50 field workers, 5 logs/day each, 3 images/log

- **Daily Operations:**
  - Logins: 50/day = 1,500/month ✅ (under 10k limit)
  - Writes: 250/day ✅ (under 20k limit)
  - Images: 750/day × 2 MB = 1.5 GB/day ⚠️ (exceeds 1 GB limit)
  - Storage: 750/day × 2 MB × 30 days = 45 GB/month ❌ (exceeds 5 GB)

**Recommendation:** May need paid plan if usage exceeds estimates

## File Structure

```
Solar Unloading/
├── android/                    # Android native code
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   └── kotlin/...      # MainActivity
│   │   ├── build.gradle
│   │   └── google-services.json ⚠️ REQUIRED
│   ├── build.gradle
│   ├── settings.gradle
│   └── gradle.properties
│
├── lib/
│   ├── main.dart               # Entry point
│   ├── firebase_options.dart   # ⚠️ UPDATE THIS
│   └── screens/
│       ├── login_screen.dart
│       ├── home_screen.dart
│       ├── unloading_log_screen.dart
│       └── installation_log_screen.dart
│
├── pubspec.yaml                # Dependencies
├── README.md                   # Main docs
├── FIREBASE_SETUP.md          # Setup guide
├── DEV_NOTES.md               # Dev notes
├── APP_FLOW.md                # Flow diagrams
├── QUICK_REFERENCE.md         # Quick ref
├── ANALYSIS.md                # This file
└── .gitignore
```

## Next Steps

1. ✅ Code structure created
2. ⚠️ User must install Flutter
3. ⚠️ User must create Firebase project
4. ⚠️ User must download google-services.json
5. ⚠️ User must update firebase_options.dart
6. ⚠️ User must create test user in Firebase
7. ⚠️ User must run `flutter pub get`
8. ⚠️ User must run `flutter run`

## Conclusion

This is a **simple, functional MVP** that meets all stated requirements:

✅ Android mobile app  
✅ Firebase integration (Auth, Firestore, Storage)  
✅ 4 screens (Login, Home, Unloading, Installation)  
✅ QR code scanning  
✅ Image capture and upload  
✅ Proper database structure  
✅ Minimal features only  

The app is **ready for Firebase configuration** and testing.
