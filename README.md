<div align="center">

# 🏡 Stayzee

### *Unlock the World, Safe & Shared.*

**A trusted peer-to-peer community travel platform connecting budget travelers with verified local hosts across India.**

[![Live Demo](https://img.shields.io/badge/Live%20Demo-Netlify-00C7B7?style=for-the-badge&logo=netlify)](https://thriving-clafoutis-5e349a.netlify.app)
[![GitHub](https://img.shields.io/badge/GitHub-SouravkumarX-181717?style=for-the-badge&logo=github)](https://github.com/SouravkumarX/Stayzee.com)
[![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?style=for-the-badge&logo=supabase)](https://supabase.com)
[![HTML](https://img.shields.io/badge/Frontend-HTML%2FCSS%2FJS-E34F26?style=for-the-badge&logo=html5)](https://developer.mozilla.org/en-US/docs/Web/HTML)

</div>

---

## 🌟 What is Stayzee?

Stayzee bridges the gap between **expensive hotels** and **risky free stays** by building a community-first platform where every user is 100% verified. Travelers can find affordable, authentic stays with locals who share their interests — and hosts can earn extra income by listing their spare rooms.

> *"We don't just list rooms — we connect people."*

### The Problem We Solve
| Pain Point | How Stayzee Fixes It |
|---|---|
| 💼 Hotels are too expensive | Stays at a fraction of hotel prices |
| 😞 Commercial stays are impersonal | Match with locals by shared interests & values |
| ⚠️ Cheap alternatives feel unsafe | 100% Aadhaar/Passport + AI Face Verification |

---

## ✨ Features

### 🔐 Auth & Profiles
- Email/password signup & login
- Google OAuth (one-click login)
- Password reset via email
- Auto profile creation on signup (DB trigger)
- Avatar upload to Supabase Storage
- Aadhaar/Passport + Selfie upload for ID verification

### 🏠 Host Features
- Create, edit, delete listings
- Multi-image drag & drop upload
- Set price per night, room type, gender filter
- 12 amenity chips (WiFi, Kitchen, AC, etc.)
- Accept / Decline / Complete booking requests
- Host earnings dashboard (80% of completed bookings)

### 🧭 Guest Features
- Search & filter listings by city, price, room type, gender
- Listing detail page with photo gallery + price breakdown
- Date picker with automatic price + 20% service fee calculation
- Star ratings & written reviews after completed stays
- Booking history with status tracking

### 📊 Dashboard
- Live stats: total bookings, earnings, listings, reviews
- Pending booking requests alert banner
- Quick access to all features

### 🛡️ Safety
- 100% user verification (Aadhaar/Passport + AI Face Match)
- Female-only filter for listings
- In-app SOS & 24/7 support (coming soon)
- Row Level Security on all database tables

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Frontend** | HTML5, CSS3, Vanilla JavaScript |
| **Backend** | Supabase (PostgreSQL + Auth + Storage) |
| **Authentication** | Supabase Auth (Email + Google OAuth) |
| **Database** | PostgreSQL with Row Level Security |
| **Storage** | Supabase Storage (listing images + avatars) |
| **Hosting** | Netlify (drag & drop deploy) |
| **Fonts** | Syne (headings) + Outfit (body) via Google Fonts |

---

## 📁 Project Structure

```
stayzee/
├── index.html                  ← Landing page (marketing site)
├── _redirects                  ← Netlify routing config
├── schema.sql                  ← Full PostgreSQL schema + RLS policies
├── css/
│   └── styles.css              ← Shared design system
├── js/
│   └── supabase.js             ← All Supabase helpers (auth, DB, storage)
└── pages/
    ├── login.html              ← Login, Signup, Password Reset
    ├── dashboard.html          ← Stats, host requests, guest bookings
    ├── explore.html            ← Search & filter listings
    ├── listing.html            ← Listing detail + booking form
    ├── host.html               ← Create/edit/delete listings + image upload
    ├── host-bookings.html      ← Accept/decline requests + earnings
    ├── bookings.html           ← Guest bookings + star reviews
    └── profile.html            ← Edit profile + ID verification upload
```

---

## 🗄️ Database Schema

| Table | Purpose |
|---|---|
| `profiles` | User profiles, verification status, is_host flag |
| `listings` | Properties with images[], amenities[], pricing, gender_filter |
| `bookings` | Status: pending / confirmed / cancelled / completed |
| `reviews` | Star ratings + comments, unique per booking + reviewer |
| `messages` | In-app messaging between hosts and guests |

### Storage Buckets
| Bucket | Access | Purpose |
|---|---|---|
| `listing-images` | Public | Property photos |
| `avatars` | Public | Profile photos + ID docs |

### Row Level Security
- Listings → **public read**, owner write
- Bookings → **host + guest only**
- Profiles → **public read**, owner write
- Reviews → **public read**, reviewer write
- Messages → **sender + receiver only**

---

## 🚀 Getting Started

### Prerequisites
- A free [Supabase](https://supabase.com) account
- A code editor (VS Code recommended)

### Step 1 — Clone the repo
```bash
git clone https://github.com/SouravkumarX/Stayzee.com.git
cd Stayzee.com
```

### Step 2 — Set up Supabase
1. Go to [supabase.com](https://supabase.com) → **New Project**
2. Name it `Stayzee`, set a strong DB password
3. Wait ~2 minutes for initialization

### Step 3 — Run the database schema
1. In Supabase → **SQL Editor**
2. Paste the entire contents of `schema.sql`
3. Click **Run** → you should see "Success. No rows returned"

### Step 4 — Add your API keys
Open `js/supabase.js` and replace:
```js
const SUPABASE_URL = 'https://YOUR_PROJECT_ID.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR_ANON_PUBLIC_KEY';
```
Find these at: **Supabase Dashboard → Settings → API**

### Step 5 — Enable Google OAuth (optional)
1. Supabase → **Authentication → Providers → Google** → Toggle ON
2. Add your Google OAuth credentials from [Google Cloud Console](https://console.cloud.google.com)
3. Add redirect URI: `https://YOUR_PROJECT_ID.supabase.co/auth/v1/callback`
4. Add your site URL in **Authentication → URL Configuration**

### Step 6 — Deploy
**Netlify (recommended — easiest):**
> Drag and drop the project folder at [app.netlify.com/drop](https://app.netlify.com/drop)

**GitHub Pages:**
> Settings → Pages → Deploy from `main` branch → root `/`

**Vercel:**
```bash
npx vercel
```

---

## 💰 Revenue Model

```
Primary:   20% commission per successful booking
Host keeps: 80% of each booking value

Host Upsells (coming soon):
  • Home Meals    — Hosts cook dinner for guests
  • Experiences   — Local tours & activities
  • Vehicle Rental — Bikes/cars with verified docs
```

---

## 📱 Features Status

| Feature | Status |
|---|---|
| Email/password auth | ✅ Live |
| Google OAuth | ✅ Live |
| Password reset | ✅ Live |
| Host listing CRUD | ✅ Live |
| Multi-image upload | ✅ Live |
| Search & filter | ✅ Live |
| Booking system | ✅ Live |
| Price breakdown (20% fee) | ✅ Live |
| Host accept/decline | ✅ Live |
| Guest star reviews | ✅ Live |
| ID verification upload | ✅ Live |
| Host earnings dashboard | ✅ Live |
| Responsive design | ✅ Live |
| Razorpay payments | 🔜 Coming Soon |
| AI face verification | 🔜 Coming Soon |
| Realtime messaging | 🔜 Coming Soon |
| Google Maps integration | 🔜 Coming Soon |
| Push notifications | 🔜 Coming Soon |

---

## 🗺️ Go-to-Market Strategy

| Phase | Target | Goal |
|---|---|---|
| **Phase 1 — Pilot** | Chandigarh | 50 hosts, 0% commission to build supply |
| **Phase 2 — Students** | Exam Corridor | Target students with spare beds & travel needs |
| **Phase 3 — Scale** | 10 Tier-2 Cities | Replicate playbook across India |

---

## 👤 About the Builder

**Sourav Kumar**
- 📧 sourav.works2718@gmail.com
- 📱 +91 9304090553
- 🐙 [github.com/SouravkumarX](https://github.com/SouravkumarX)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<div align="center">

Built with ❤️ by **Sourav Kumar** · © 2025 Stayzee

*Making every trip an opportunity for connection.*

</div>
