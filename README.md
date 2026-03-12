# 🏡 Stayzee — Full Stack Setup Guide

## Tech Stack
- **Frontend**: Pure HTML, CSS, JavaScript (no build tools needed)
- **Backend**: Supabase (Auth + PostgreSQL + Storage)

---

## 📁 Project Structure

```
stayzee/
├── index.html              ← Main landing page
├── css/
│   └── styles.css          ← Shared styles
├── js/
│   └── supabase.js         ← All Supabase helpers
├── schema.sql              ← Run this in Supabase SQL Editor
└── pages/
    ├── login.html          ← Login & Signup
    ├── dashboard.html      ← User dashboard
    ├── explore.html        ← Search & browse listings
    ├── listing.html        ← Listing detail + booking form
    ├── host.html           ← Host: manage listings + image upload
    ├── host-bookings.html  ← Host: manage booking requests
    ├── bookings.html       ← Guest: my bookings + reviews
    └── profile.html        ← Profile + ID verification
```

---

## 🚀 Setup in 5 Steps

### Step 1: Create a Supabase Project
1. Go to [supabase.com](https://supabase.com) → New Project
2. Name it "Stayzee", set a strong DB password
3. Wait for project to initialize (~2 minutes)

### Step 2: Run the Database Schema
1. Go to **SQL Editor** in your Supabase dashboard
2. Open `schema.sql` from this project
3. Paste the entire file and click **Run**
4. This creates: `profiles`, `listings`, `bookings`, `reviews`, `messages` tables + storage buckets

### Step 3: Configure Your Keys
Open `js/supabase.js` and replace:
```js
const SUPABASE_URL = 'https://YOUR_PROJECT_ID.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR_ANON_PUBLIC_KEY';
```
Find these in: **Settings → API → Project URL & anon public key**

### Step 4: Enable Google OAuth (optional)
1. Supabase Dashboard → **Authentication → Providers → Google**
2. Add your Google OAuth credentials
3. Add your site URL to the redirect list

### Step 5: Deploy
**Option A — Free hosting on Netlify:**
```bash
# Drag and drop the stayzee/ folder at netlify.com/drop
```

**Option B — Vercel:**
```bash
npm install -g vercel
cd stayzee/
vercel
```

**Option C — GitHub Pages:**
Push to a GitHub repo → Settings → Pages → Deploy from main branch

---

## 🗄️ Database Schema Overview

| Table     | Purpose |
|-----------|---------|
| `profiles` | User profiles, verification status, host flag |
| `listings` | Property listings with images, amenities, pricing |
| `bookings` | Booking requests with status (pending/confirmed/completed/cancelled) |
| `reviews`  | Guest reviews with star ratings |
| `messages` | In-app messaging between hosts and guests |

## 🪣 Storage Buckets

| Bucket | Purpose |
|--------|---------|
| `listing-images` | Property photos (public) |
| `avatars` | User profile photos + ID verification docs |

---

## 🔐 Row Level Security (RLS)
All tables have RLS enabled:
- Listings are **public** (anyone can view)
- Bookings are **private** (only host/guest can see)
- Profiles are **public to view**, private to edit
- Messages are **private** (only sender/receiver)

---

## 💰 Revenue Model Implemented
- Bookings calculate **20% service fee** automatically
- Host earnings show **80% of completed booking totals**

---

## 📱 Features Checklist
- ✅ Email/password auth
- ✅ Google OAuth
- ✅ Password reset
- ✅ Auto profile creation on signup
- ✅ Host listing management (create, edit, delete)
- ✅ Multi-image upload with drag & drop
- ✅ Search & filter listings
- ✅ Booking requests with date picker
- ✅ Price breakdown with service fee
- ✅ Host booking management (accept/decline)
- ✅ Guest reviews with star ratings
- ✅ ID verification upload
- ✅ Avatar upload
- ✅ Dashboard with stats & earnings
- ✅ Responsive design (mobile friendly)

---

## 🛠️ Next Steps (Production)
- [ ] Add Razorpay/Stripe payment gateway
- [ ] Implement real AI face verification (e.g. AWS Rekognition)
- [ ] Add Supabase Realtime for live messaging
- [ ] Email notifications (Supabase handles transactional emails)
- [ ] Add Google Maps integration for listing locations
- [ ] Push notifications for mobile

---

Built with ❤️ by Sourav Kumar | sourav.works2718@gmail.com
