# Test Daily — V2

A clean, fast, and beautiful mobile app for software testers, QA engineers, and students. Your daily companion for QA excellence — now with **live RSS articles and YouTube videos**.

---

## Features

| Tab | Screen | Features |
|-----|--------|----------|
| 1 | **Home** | YouTube videos — large thumbnails, play overlay, YouTube app deep-link, category filter, pull-to-refresh, offline cache |
| 2 | **Articles** | RSS blog articles — category filter, pull-to-refresh, opens in browser, offline cache |
| 3 | **Categories** | 8 categories in a 2-column grid; detail view shows both YouTube + RSS for the category |
| 4 | **Bookmarks** | Save any item offline via Hive, full-text search, swipe to delete |
| 5 | **AI Assistant** | ChatGPT-style chat with DeepSeek + Groq APIs, automatic fallback |
| — | **Splash** | Animated logo, connectivity check, auto-redirect |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI | Flutter 3.x + Material 3 |
| State | Riverpod (AsyncNotifier) |
| Navigation | GoRouter (ShellRoute) |
| HTTP | Dio 5 |
| RSS Parsing | `xml` package |
| Local Storage | Hive 2 (bookmarks + feed cache + chat history) |
| Secure Keys | flutter_secure_storage (Keystore / Keychain) |
| Image Cache | cached_network_image |
| Deep Links | url_launcher |

---

## Setup

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Configure the YouTube API Key

The YouTube integration requires a **YouTube Data API v3** key from Google Cloud Console.

**Steps:**
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a project (or select an existing one)
3. Enable the **YouTube Data API v3** under *APIs & Services → Library*
4. Create an API Key under *APIs & Services → Credentials*
5. (Optional but recommended) Restrict the key to *YouTube Data API v3* only

**Add the key to the app:**

Open the app → tap the **AI Assistant** tab → tap the **key icon** in the top-right → scroll to the **YouTube API Key** field → paste your key → tap **Save Keys**.

The key is stored securely in Android Keystore / iOS Keychain via `flutter_secure_storage`.

> **Without a YouTube API key** the feed will show RSS articles only. No crash, just graceful degradation.

### 3. Run

```bash
flutter run
```

---

## How to Add a New RSS Feed

1. Open `lib/core/constants/feed_sources.dart`
2. Add an entry to `kRssFeeds`:

```dart
RssFeedSource(
  url: 'https://your-blog.com/feed/',
  sourceName: 'Your Blog Name',   // shown on the card
  defaultCategory: 'automation',  // fallback if keyword detection misses
),
```

Supported `defaultCategory` values match the `TestingCategory` enum names:
`automation`, `apiTesting`, `performance`, `security`, `mobileTesting`, `interviewPrep`, `aiTesting`, `accessibility`

Both **RSS 2.0** and **Atom** formats are supported automatically.

---

## How to Add a New YouTube Channel

1. Find the channel's **Channel ID**:
   - Visit the channel page on YouTube
   - In the browser URL bar you'll see `youtube.com/@handle` — click *More* → *Share* → *Copy channel ID*, **or**
   - View the page source and search for `"channelId"`

2. Open `lib/core/constants/feed_sources.dart` and add an entry to `kYoutubeChannels`:

```dart
YoutubeChannelConfig(
  channelId: 'UCxxxxxxxxxxxxxxxxxx',   // the ID you copied
  channelName: 'Channel Display Name',
  defaultCategory: 'automation',
),
```

---

## Category Inference

Articles and videos are automatically assigned a category based on keywords in the title and description. The logic lives in `lib/core/utils/category_inferrer.dart` — edit the regex patterns there to tune detection.

---

## Offline Support

The full feed is cached in a dedicated Hive box (`feed_cache`) every time a successful fetch completes. When the device is offline (or both sources fail), the app renders the cached feed. The first install before any fetch shows the built-in mock data.

---

## Architecture

```
lib/
├── app/              — AppRoot, GoRouter (5-tab ShellRoute), Material 3 theme
├── core/
│   ├── constants/    — API endpoints, Hive keys, feed_sources (RSS + YouTube config)
│   ├── network/      — Dio singleton
│   └── utils/        — Date formatter, connectivity, category_inferrer
├── data/
│   ├── mock/         — Dev fallback (15 curated items)
│   ├── repositories/ — feed (YouTube), articles (RSS), bookmarks, AI
│   └── services/     — Hive, secure storage, AI, RSS, YouTube
├── features/
│   ├── home/         — YouTube video feed
│   ├── articles/     — RSS article feed (NEW)
│   ├── categories/   — Category grid + detail (shows both videos + articles)
│   ├── bookmarks/    — Saved items
│   ├── ai_assistant/ — Chat interface
│   ├── shell/        — 5-tab persistent navigation bar
│   └── splash/       — Launch screen
├── models/           — FeedItem (Hive, type=video|article), ChatMessage, Category
└── providers/        — feed, articles, bookmarks, AI, category, theme
```

### Data flow

```
Home tab  ──► feedProvider  ──► FeedRepositoryImpl  ──► YoutubeService → YouTube API
                                                     └─► Hive feed_cache (offline)

Articles  ──► articlesProvider ──► ArticlesRepositoryImpl ──► RssService → RSS feeds
                                                          └─► Hive articles_cache (offline)

Categories detail ──► feedProvider + articlesProvider (merged by category)
```

---

## Environment Notes

- **YouTube quota**: the free tier grants 10 000 units/day. Each `search.list` call costs 100 units. With 4 channels × 5 videos that's 400 units per full refresh — well within the free tier for development and light production use.
- **RSS**: no quota; fetched directly over HTTPS.

---

## Adding More AI Providers

The AI assistant uses DeepSeek (primary) with Groq as automatic fallback. Both are free-tier compatible. Keys are entered in-app via the AI Assistant → key icon.
