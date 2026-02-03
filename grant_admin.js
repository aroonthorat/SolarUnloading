/*
  grant_admin.js
  Run this with Node.js to grant Admin privileges to a user.

  USAGE:
  1. Download 'serviceAccountKey.json' from:
     Firebase Console -> Project Settings -> Service Accounts -> Generate New Private Key
  2. Place the file in this folder (rename it to serviceAccountKey.json).
  3. Run: npm install firebase-admin
  4. Run: node grant_admin.js <YOUR_EMAIL>
*/

const admin = require('firebase-admin');

// Check for Service Account Key
if (!require('fs').existsSync('./serviceAccountKey.json')) {
    console.error("ERROR: 'serviceAccountKey.json' not found!");
    console.error("Please download it from Firebase Console -> Service Accounts and place it here.");
    process.exit(1);
}

const serviceAccount = require('./serviceAccountKey.json');

const email = process.argv[2];
if (!email) {
    console.error("Please provide an email: node grant_admin.js <EMAIL>");
    process.exit(1);
}

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

console.log(`Granting Admin Role to: ${email}...`);

admin.auth().getUserByEmail(email)
    .then(user => {
        return admin.auth().setCustomUserClaims(user.uid, {
            admin: true
        });
    })
    .then(() => {
        console.log(`\n✅ Success! ${email} is now an Admin.`);
        console.log("ℹ️  NOTE: You MUST Sign Out and Sign In again on the dashboard to refresh your admin token.");
        process.exit(0);
    })
    .catch(error => {
        console.error("\n❌ Error granting admin:", error.message);
        if (error.code === 'auth/user-not-found') {
            console.error("   User not found. Please sign up with this email first.");
        }
        process.exit(1);
    });
