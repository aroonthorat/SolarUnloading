# Solar Unloading - Field Logging System

## 🌐 Live Web App
Access the app at: https://aroonthorat.github.io/SolarUnloading/web_app/

## 📱 Mobile-Responsive Web Application

A simple, mobile-friendly application for logging solar pump material unloading and installations.

### Features:
- ✅ Email/Password Authentication
- ✅ Unloading Log with Photo Upload
- ✅ Installation Log with Photo Upload
- ✅ Firebase Backend (Firestore + Storage)
- ✅ Mobile-Optimized Interface
- ✅ Works on All Browsers

### Login Credentials:
- **Email:** test@example.com
- **Password:** password123

### Technology Stack:
- Pure HTML/JavaScript
- Firebase (Auth, Firestore, Storage)
- No build tools required
- Mobile-first design

### Project Structure:
```
web_app/
├── index.html         # Login page
├── home.html          # Dashboard
├── unloading.html     # Unloading log form
└── installation.html  # Installation log form
```

### Firebase Configuration:
- **Project:** gen-lang-client-0579320558
- **Collections:** unloading_log, installation_log
- **Storage:** Firebase Storage for images

### Usage:
1. Open the web app URL
2. Login with test credentials
3. Create unloading or installation logs
4. Photos automatically upload to Firebase
5. Check Firebase Console to view data

### Development:
This is a standalone web application that can be:
- Deployed to GitHub Pages
- Hosted on any web server
- Deployed to Netlify/Vercel
- Used with Firebase Hosting

Uses Firebase SDK 10.7.1 via CDN (no npm install needed).

### Future Plans:
- Android app version (Flutter - in progress)
- Offline support
- QR code scanning
- Data export features

---

**Created for field workers to log solar pump installations efficiently from mobile browsers.**
