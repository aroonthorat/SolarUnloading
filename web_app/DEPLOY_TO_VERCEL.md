# 🚀 Deploying to Vercel (Recommended)

Switching to Vercel will solve caching issues and make the app faster for workers.

## Step 1: Import to Vercel
1. Log in to [Vercel.com](https://vercel.com).
2. Click **"Add New..."** -> **"Project"**.
3. Select your GitHub repository: **`SolarUnloading`**.

## Step 2: Configure Settings (IMPORTANT)
Before clicking "Deploy", look for the **"Root Directory"** setting (click "Edit").
*   Change it from `./` to:
    **`web_app`**
    *(This tells Vercel that your website lives inside the web_app folder, not the root)*.

## Step 3: Deploy
*   Click **"Deploy"**.
*   Wait for the confetti! 🎉

## Step 4: Whitelist Domain in Firebase (CRITICAL)
Your app will fail to log in unless you tell Firebase that Vercel is safe.
1. Go to [Firebase Console](https://console.firebase.google.com/).
2. Select your project.
3. Go to **Authentication** (in the left menu).
4. Click the **Settings** tab.
5. Scroll down to **"Authorized Domains"**.
6. Click **"Add Domain"**.
7. Enter your new Vercel domain (e.g., `solar-unloading-app.vercel.app`).
8. Click **Add**.

**Done! Your app is now production-ready.**
