# 💸 SharePay

> **Exchange cash locally, instantly.**

SharePay is an iOS app that connects people who **need cash** with people who **have cash**, enabling peer-to-peer cash exchange backed by digital payment platforms (PayPal, Apple Pay, Venmo). Think *Uber for cash on demand*.

---

## 🎬 Demo Video

[![SharePay Demo] https://youtube.com/shorts/dUew1FSk_T8?feature=share

*▶️ 60-second walkthrough — click the thumbnail to watch on YouTube.*


---

## 🌟 What It Does

<img width="494" height="999" alt="image" src="https://github.com/user-attachments/assets/ec4ec2aa-178d-4266-868d-3a42011bcb03" />
<img width="466" height="991" alt="image" src="https://github.com/user-attachments/assets/7c26e5d6-b38c-4d96-a9f5-49f9a75a8850" />
<img width="487" height="1009" alt="image" src="https://github.com/user-attachments/assets/1e13e3c9-df40-4d56-852f-7a3259cbd429" />
<img width="453" height="940" alt="image" src="https://github.com/user-attachments/assets/be68163c-17c1-453b-a448-f9a7618ef5a9" />


Imagine you're at a farmer's market that only takes cash, but you only have digital money. Or you have $100 sitting in your wallet that you'd rather have in your bank account. **SharePay solves both problems at once** by matching these users locally:

- **Receivers** post a request for cash (they pay digitally)
- **Responders** browse nearby requests and exchange cash in person
- **SharePay charges a small service fee** — most of which the responder keeps as compensation

The app demonstrates a **two-sided marketplace** with a custom **hybrid fee model** designed to incentivize the cash supply side and solve the chicken-and-egg problem common to P2P platforms.

---

## ✨ Key Features

- 🔐 **Email/Password Authentication** — full Firebase Auth flow (sign-up, login, logout, error handling)
- 💵 **Cash Request CRUD** — create, view, edit, and delete cash exchange requests
- ⚡ **Live Real-Time Updates** — `@FirestoreQuery` keeps the request list synced across all devices instantly
- 🗑️ **Swipe to Delete** — native iOS gesture for managing requests
- 💰 **Live Hybrid Fee Calculator** — see the SharePay service fee + Responder/platform split update as you type
- 🎨 **Modern SwiftUI UI** — custom gradient branding, clean form inputs, dark-mode ready
- 👤 **Auto User Tagging** — every request is automatically labeled with the creator's email via Firebase Auth
- 🎯 **Custom App Icon & Launch Screen** — fully branded experience from first tap

---

## 🛠️ Tech Stack

- **SwiftUI** — declarative UI framework, iOS 17+
- **Swift 5.9** — Apple's modern, type-safe language
- **Firebase Authentication** — managed email/password user management
- **Cloud Firestore** — NoSQL real-time database with security rules
- **MVVM Architecture** — clean separation of Model, ViewModel, and View
- **Swift Package Manager** — dependency management for Firebase SDK
- **Xcode 16** — Apple's official IDE

---

## 🏗️ Project Structure

```
SharePay/
├── SharePayApp.swift          # App entry + Firebase initialization
├── LoginView.swift            # Auth UI (signup/login + alert handling)
├── ListView.swift             # Main screen — @FirestoreQuery for live data
├── DetailView.swift           # Create/Edit request with live fee preview
├── Request.swift              # Model (struct, Codable, Identifiable, @DocumentID)
├── RequestViewModel.swift     # static save() + delete() functions
├── Assets.xcassets/           # AppIcon + LaunchLogo
└── GoogleService-Info.plist   # Firebase configuration
```

The architecture follows the standard iOS MVVM pattern, adapted for SharePay's domain.

---

## 💼 Business Model — Hybrid Fee Pricing

SharePay's pricing was designed analytically to balance two competing forces in a two-sided marketplace:

```
fee = max($2.00, transaction × 2.5%)

Of which:
→ 70% goes to the Responder (cash provider)
→ 30% goes to SharePay (platform)
```

**Why this model?**

| Aspect | Reasoning |
|--------|-----------|
| **$2.00 minimum** | Protects against unprofitable micro-transactions below ~$80 |
| **2.5% above the break-even** | Scales fairly with risk and convenience |
| **70/30 split** | Incentivizes the **supply side** — responders earn real money, solving the chicken-and-egg problem |
| **vs. flat fee** | Doesn't penalize large transactions |
| **vs. pure percentage** | Doesn't make small transactions unprofitable |

A 3-phase rollout strategy was designed (Rule-Based MVP → Optimization Formula → Machine Learning Regression). The full strategic analysis is documented in `SharePay_Strategie.docx`.

---

## 🚀 Setup

### Prerequisites
- macOS with **Xcode 16+**
- A free Google account
- A Firebase project (Spark tier — no credit card needed)

### Steps
1. Clone the repo:
   ```bash
   git clone https://github.com/nick00733/SharePay.git
   cd SharePay
   ```
2. Open `SharePay.xcodeproj` in Xcode
3. **Important:** Replace `GoogleService-Info.plist` with the one from your own Firebase project (or use the included one for testing)
4. Wait for Swift Package Manager to resolve Firebase dependencies (~2 min on first build)
5. Build and run (`⌘R`) on the iOS Simulator or a real device

### Firebase Console Setup
- Enable **Email/Password** sign-in under Authentication
- Create a **Cloud Firestore** database in production mode
- Set the following security rule:
  ```
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /{document=**} {
        allow read, write: if request.auth != null;
      }
    }
  }
  ```

---

## 🤖 AI Usage

This project was developed with the assistance of **Claude (Anthropic)** for:
- Architectural design decisions (MVVM separation, Firestore data model)
- Code generation following course-recognized patterns
- Strategic business analysis (hybrid fee model derivation)
- App icon and launch screen asset generation
- Real-time debugging during the build sprint

A separate **AI usage summary video** is submitted alongside this project as part of the course requirements.

---

## 🎓 Course Attribution

Built as the final project for **BZAN 2165 — Learn to Build Apps with Swift & SwiftUI** (Spring 2026), Boston College, taught by [Prof. John Gallaugher](https://gallaugher.com).

The Firebase Auth and Firestore patterns implemented here follow:
- Snacktacular Ch. 8.1 — Firebase project setup
- Snacktacular Ch. 8.2 — Email/Password authentication
- Snacktacular Ch. 8.6 — Firestore CRUD with `@FirestoreQuery`
- Hackathon Week 12 — `@Observable` ViewModel with `static func saveData / deleteData`

---

## 👤 Contact

**Nick Nedjat** — Frankfurt School of Finance & Management, on exchange at Boston College

- 📧 **Email:** [nick.nedjat@icloud.com](mailto:nick.nedjat@icloud.com)
- 💼 **LinkedIn:** https://www.linkedin.com/in/nick-nedjat-6140082b8/
- 🐙 **GitHub:** [@nick00733](https://github.com/nick00733)

*Open to internship and full-time opportunities in iOS / mobile development, fintech, and product engineering.*

---

<sub>Built with ☕ + 🔥 + Swift in Boston, April 2026</sub>
