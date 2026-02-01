# App Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     SOLAR UNLOADING APP                      │
│                    Mobile-First Android                      │
└─────────────────────────────────────────────────────────────┘

┌──────────────────────┐
│   LOGIN SCREEN       │
│                      │
│  🔐 Email            │
│  🔑 Password         │
│  [ Login Button ]    │
│                      │
│  Firebase Auth       │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   HOME SCREEN        │
│                      │
│  User: user@mail.com │
│  [Logout]            │
│                      │
│  Select Action:      │
│                      │
│  ┌────────────────┐  │
│  │ 🚚 Add         │  │
│  │   Unloading    │  │
│  └────────────────┘  │
│                      │
│  ┌────────────────┐  │
│  │ 🔧 Add         │  │
│  │   Installation │  │
│  └────────────────┘  │
└──────┬───────┬───────┘
       │       │
       │       └──────────────────────────┐
       │                                  │
       ▼                                  ▼
┌──────────────────────┐      ┌──────────────────────┐
│ UNLOADING LOG SCREEN │      │ INSTALLATION LOG     │
│                      │      │      SCREEN          │
│ 📅 Date: Auto        │      │                      │
│                      │      │ 📅 Date: Auto        │
│ 👤 Farmer Name/ID    │      │                      │
│    [______________]  │      │ 👤 Farmer Name/ID    │
│                      │      │    [______________]  │
│ 📦 Material Type     │      │                      │
│    [______________]  │      │ 🔢 Serial Number     │
│                      │      │    [______________]  │
│ [Scan QR Code] 📷    │      │                      │
│                      │      │ 📷 Installation      │
│ 🔢 Serial Number     │      │    Photos *          │
│    [Auto from QR]    │      │    (MANDATORY)       │
│                      │      │ [Add Photos (0)]     │
│ QR Image: ✅         │      │ [img][img][img]      │
│ [QR CODE IMAGE]      │      │                      │
│                      │      │ ⚠️  Issue Photos     │
│ 📸 Unloading Photos  │      │    (Optional)        │
│ [Add Photos (0)]     │      │ [Add Photos (0)]     │
│ [img][img][img]      │      │ [img][img]           │
│                      │      │                      │
│ [  Save Log  ]       │      │ [  Save Log  ]       │
│                      │      │                      │
└──────┬───────────────┘      └──────┬───────────────┘
       │                             │
       ▼                             ▼
  ┌─────────────┐              ┌─────────────┐
  │  FIRESTORE  │              │  FIRESTORE  │
  │             │              │             │
  │ unloading_  │              │installation_│
  │    log      │              │    log      │
  │             │              │             │
  │ + Photos in │              │ + Photos in │
  │   Storage   │              │   Storage   │
  └─────────────┘              └─────────────┘
```

## QR Scanner Flow

```
Unloading Screen
      │
      ▼
[Scan QR Code] button pressed
      │
      ▼
┌──────────────────┐
│  QR SCANNER      │
│                  │
│  ┌────────────┐  │
│  │            │  │
│  │  📷 Camera │  │
│  │   Viewfinder│ │
│  │            │  │
│  │  [  QR  ]  │  │
│  │            │  │
│  └────────────┘  │
│                  │
│  Scanning...     │
└────────┬─────────┘
         │
         ▼ (QR detected)
    Capture Image
         │
         ▼
    Auto-fill Serial Number
    Save QR Image
         │
         ▼
    Return to Unloading Screen
```

## Data Flow

```
APP                FIREBASE              STORAGE
───                ────────              ───────

User Login  ──────▶ Auth
                   ✓ Authenticated
                   │
                   ▼
Capture     ──────▶ Upload Images ─────▶ /unloading/
Photos                                   /installation/
                   │
                   ▼
                Get URLs
                   │
                   ▼
Save Form  ──────▶ Firestore
Data              (with URLs)
                   │
                   ▼
              unloading_log
              installation_log
```

## Database Schema

### Collection: unloading_log
```
{
  "date": Timestamp(2026-02-01),
  "farmer": "John Doe / FRM001",
  "materialType": "Solar Pump XYZ",
  "serialNumber": "SN123456789",
  "qrImageUrl": "https://storage.../unloading/12345.jpg",
  "unloadingPhotoUrls": [
    "https://storage.../unloading/12346.jpg",
    "https://storage.../unloading/12347.jpg"
  ],
  "enteredBy": "user@example.com",
  "createdAt": ServerTimestamp
}
```

### Collection: installation_log
```
{
  "date": Timestamp(2026-02-01),
  "farmer": "Jane Smith / FRM002",
  "serialNumber": "SN987654321",
  "installationPhotoUrls": [
    "https://storage.../installation/56781.jpg",
    "https://storage.../installation/56782.jpg"
  ],
  "issuePhotoUrls": [
    "https://storage.../installation/56783.jpg"
  ],
  "enteredBy": "user@example.com",
  "createdAt": ServerTimestamp
}
```

## Permissions Required

```
AndroidManifest.xml
├── CAMERA           (for QR scanning & photo capture)
├── INTERNET         (for Firebase connectivity)
├── READ_EXTERNAL_STORAGE  (for gallery access)
└── WRITE_EXTERNAL_STORAGE (for saving images - API <33)
```

## Tech Stack Summary

```
┌─────────────────────────────────────┐
│         PRESENTATION LAYER          │
│  Flutter UI (Material Design 3)     │
│  - Login Screen                     │
│  - Home Screen                      │
│  - Unloading Log Screen             │
│  - Installation Log Screen          │
│  - QR Scanner Screen                │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         BUSINESS LOGIC              │
│  - Form Validation                  │
│  - Image Picker Logic               │
│  - QR Code Scanner Logic            │
│  - Firebase Upload Logic            │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         DATA/SERVICES               │
│  - Firebase Auth Service            │
│  - Firestore Database Service       │
│  - Storage Upload Service           │
│  - QR Scanner Plugin                │
│  - Image Picker Plugin              │
└─────────────────────────────────────┘
```

## MVP Features Checklist

✅ **Login**
  - Email/password authentication
  - Firebase Auth integration

✅ **Home Dashboard**
  - User info display
  - Navigate to Unloading
  - Navigate to Installation
  - Logout

✅ **Unloading Log**
  - Auto date
  - Farmer input
  - Material type input
  - QR code scanner
  - Serial number (auto/manual)
  - QR image capture
  - Multiple photo upload
  - Save to Firestore

✅ **Installation Log**
  - Auto date
  - Farmer input
  - Serial number input
  - Installation photos (mandatory)
  - Issue photos (optional)
  - Save to Firestore

✅ **Image Management**
  - Upload to Firebase Storage
  - Store URLs in Firestore
  - Support multiple images

✅ **QR Scanning**
  - Camera-based scanning
  - Auto-capture QR image
  - Auto-fill serial number

## Not Included (Per Requirements)

❌ AI logic
❌ Reports/Analytics
❌ PDF/Excel export
❌ Dashboards
❌ User roles/permissions
❌ Advanced validation
❌ Offline sync
❌ Edit/Delete logs
❌ Search functionality

---

This is a **SIMPLE MVP** focused on reliable data capture in the field.
