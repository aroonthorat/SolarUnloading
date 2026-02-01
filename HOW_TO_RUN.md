# How to Run the App with Android Studio

## Step 1: Start Android Emulator

### Option A: Using Android Studio GUI

1. **Open Android Studio**

2. **Open Device Manager**
   - Click the three dots (More Actions) on welcome screen
   - OR go to: Tools → Device Manager
   - OR click the phone icon in the top toolbar

3. **Start an Emulator**
   - If you have an existing emulator: Click the ▶ (Play) button next to it
   - If no emulator exists: Click "Create Device"
     - Select a phone (e.g., Pixel 6)
     - Click "Next"
     - Download a system image (recommend: API 34 - Android 14)
     - Click "Next" → "Finish"
     - Click ▶ to start the emulator

4. **Wait for emulator to fully boot**
   - This takes 1-2 minutes
   - You'll see the Android home screen

### Option B: Using Command Line

```powershell
# List available emulators
C:\Users\<YourUsername>\AppData\Local\Android\Sdk\emulator\emulator -list-avds

# Start an emulator (replace 'Pixel_6_API_34' with your AVD name)
C:\Users\<YourUsername>\AppData\Local\Android\Sdk\emulator\emulator -avd Pixel_6_API_34
```

---

## Step 2: Verify Device is Connected

Open PowerShell or Command Prompt and run:

```powershell
cd "e:\Codespace\Solar Unloading"
C:\flutter\bin\flutter devices
```

**Expected Output:**
```
2 connected devices:

Android SDK built for x86 (mobile) • emulator-5554 • android-x86 • Android 14 (API 34)
Chrome (web)                        • chrome        • web-javascript • Google Chrome
```

You should see your emulator listed!

---

## Step 3: Run the App

### Method 1: Using Command Line (Recommended)

```powershell
cd "e:\Codespace\Solar Unloading"
C:\flutter\bin\flutter run
```

**What happens:**
1. Flutter will build the app (first time takes 5-10 minutes)
2. App will install on the emulator
3. App will launch automatically
4. You'll see the Login screen

### Method 2: Using Android Studio

1. **Open the Project in Android Studio**
   - File → Open
   - Navigate to: `e:\Codespace\Solar Unloading`
   - Select the folder and click OK

2. **Wait for Indexing**
   - Android Studio will index the project
   - Wait for "Flutter commands" to appear

3. **Select Device**
   - Top toolbar: Select your emulator from device dropdown

4. **Run the App**
   - Click the green ▶ (Run) button
   - OR press Shift + F10

---

## Step 4: Test the App

Once the app launches:

1. **Login Screen**
   - Email: `test@example.com`
   - Password: `password123`
   - Click "Login"

2. **If login fails with "User not found":**
   - You need to create the user in Firebase Console first
   - See section below ⬇

---

## ⚠️ IMPORTANT: Create Firebase User First

Before you can login, you MUST create a test user in Firebase:

1. Go to: https://console.firebase.google.com/
2. Select project: `gen-lang-client-0579320558`
3. Click "Authentication" in left menu
4. Click "Get started" (if first time)
5. Click "Sign-in method" tab
6. Enable "Email/Password" provider
7. Click "Users" tab
8. Click "Add user"
9. Email: `test@example.com`
10. Password: `password123`
11. Click "Add user"

---

## 🐛 Troubleshooting

### "No devices found"
```powershell
# Check if emulator is running
C:\flutter\bin\flutter devices

# If not listed, restart the emulator
```

### "Gradle build failed"
```powershell
# Clean and rebuild
C:\flutter\bin\flutter clean
C:\flutter\bin\flutter pub get
C:\flutter\bin\flutter run
```

### "Firebase initialization failed"
- Make sure you enabled Firebase Authentication in console
- Check that google-services.json is in android/app/

### "Unable to locate Android SDK"
- Android Studio should have installed it
- Check: C:\Users\<YourUsername>\AppData\Local\Android\Sdk

### App builds but crashes on startup
- Check Firebase services are enabled (Auth, Firestore, Storage)
- Check Firebase security rules are in test mode

---

## 📊 Build Time Expectations

**First build:** 5-10 minutes (downloads dependencies)
**Subsequent builds:** 30-60 seconds

---

## 🎯 Quick Start Commands

```powershell
# 1. Navigate to project
cd "e:\Codespace\Solar Unloading"

# 2. Check devices
C:\flutter\bin\flutter devices

# 3. Run app
C:\flutter\bin\flutter run

# 4. After changes, hot reload
# (In the running terminal, press 'r')

# 5. Stop app
# (Press 'q' in the running terminal)
```

---

## ✅ Success Checklist

- [ ] Android Studio installed
- [ ] Emulator created and running
- [ ] `flutter devices` shows the emulator
- [ ] Firebase Authentication enabled
- [ ] Test user created in Firebase
- [ ] `flutter run` executed
- [ ] App installed on emulator
- [ ] App launches and shows login screen
- [ ] Can login with test credentials
- [ ] Can navigate to Home screen

---

**Ready to run? Execute the commands above!** 🚀

If you encounter any errors, let me know the exact error message and I'll help you fix it!
