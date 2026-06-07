import 'package:dio/dio.dart';
import 'package:xml/xml.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/feed_sources.dart';
import '../../core/utils/category_inferrer.dart';
import '../../models/feed_item.dart';

/// Fetches and parses RSS/Atom feeds from all configured [kRssFeeds] sources.
///
/// Each feed is fetched independently — a single failing feed does not abort
/// the others. Returns an empty list for any feed that errors.
class RssService {
  final Dio _dio;

  RssService(this._dio);

  /// Fetches every configured RSS feed concurrently and returns combined items.
  Future<List<FeedItem>> fetchAllFeeds() async {
    final futures = kRssFeeds.map(_fetchFeed);
    final results = await Future.wait(futures, eagerError: false);
    return results.expand((items) => items).toList();
  }

  Future<List<FeedItem>> _fetchFeed(RssFeedSource source) async {
    try {
      final response = await _dio.get<String>(
        source.url,
        options: Options(
          responseType: ResponseType.plain,
          headers: {'Accept': 'application/rss+xml, application/xml, text/xml, */*'},
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
        ),
      );
      if (response.data == null) return [];
      return _parse(response.data!, source);
    } catch (_) {
      return [];
    }
  }

  List<FeedItem> _parse(String xmlString, RssFeedSource source) {
    try {
      final document = XmlDocument.parse(xmlString);
      final root = document.rootElement;
      // Atom feeds have <feed> root; RSS 2.0 has <rss> root
      if (root.name.local == 'feed') {
        return _parseAtom(document, source);
      }
      return _parseRss2(document, source);
    } catch (_) {
      return [];
    }
  }

  // ── RSS 2.0 ────────────────────────────────────────────────────────────────

  List<FeedItem> _parseRss2(XmlDocument doc, RssFeedSource source) {
    final items = <FeedItem>[];
    for (final node in doc.findAllElements('item').take(kRssMaxItemsPerFeed)) {
      try {
        final title = _text(node, 'title');
        if (title.isEmpty) continue;

        final link = _rssLink(node);
        final raw = _text(node, 'description');
        final description = _clean(raw);
        final date = _parseDate(_text(node, 'pubDate'));
        final thumbnail = _thumbnail(node);
        final category = inferCategory(title, description, source.defaultCategory);

        items.add(FeedItem(
          id: 'rss_${source.sourceName.hashCode}_${link.hashCode}',
          title: title,
          description: description.length > 220
              ? '${description.substring(0, 220)}…'
              : description,
          imageUrl: thumbnail,
          source: source.sourceName,
          category: category,
          date: date,
          content: description,
          externalUrl: link.isNotEmpty ? link : null,
          type: 'article',
        ));
      } catch (_) {
        continue;
      }
    }
    return items;
  }

  // ── Atom ───────────────────────────────────────────────────────────────────

  List<FeedItem> _parseAtom(XmlDocument doc, RssFeedSource source) {
    final items = <FeedItem>[];
    for (final node in doc.findAllElements('entry').take(kRssMaxItemsPerFeed)) {
      try {
        final title = _text(node, 'title');
        if (title.isEmpty) continue;

        // Atom <link> is an element with href attribute
        final linkEl = _findLocal(node, 'link');
        final link = linkEl?.getAttribute('href') ?? _text(node, 'link');
        final raw = _text(node, 'summary').isNotEmpty
            ? _text(node, 'summary')
            : _text(node, 'content');
        final description = _clean(raw);
        final date = _parseDate(
          _text(node, 'published').isNotEmpty
              ? _text(node, 'published')
              : _text(node, 'updated'),
        );
        final thumbnail = _thumbnail(node);
        final category = inferCategory(title, description, source.defaultCategory);

        items.add(FeedItem(
          id: 'rss_${source.sourceName.hashCode}_${link.hashCode}',
          title: title,
          description: description.length > 220
              ? '${description.substring(0, 220)}…'
              : description,
          imageUrl: thumbnail,
          source: source.sourceName,
          category: category,
          date: date,
          content: description,
          externalUrl: link.isNotEmpty ? link : null,
          type: 'article',
        ));
      } catch (_) {
        continue;
      }
    }
    return items;
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Gets the text content of the first child element with [localName].
  String _text(XmlElement parent, String localName) {
    return _findLocal(parent, localName)?.innerText.trim() ?? '';
  }

  /// Finds a direct or deeper child element matching [localName] (ignores NS prefix).
  XmlElement? _findLocal(XmlElement parent, String localName) {
    try {
      return parent.descendants
          .whereType<XmlElement>()
          .firstWhere((e) => e.name.local == localName);
    } catch (_) {
      return null;
    }
  }

  /// Extracts <link> from RSS 2.0 — the element may hold text OR be self-closing.
  String _rssLink(XmlElement item) {
    // Standard RSS 2.0: <link>URL</link>
    final text = _text(item, 'link');
    if (text.isNotEmpty) return text;
    // Some feeds use <link rel="alternate" href="URL"/>
    final el = _findLocal(item, 'link');
    return el?.getAttribute('href') ?? '';
  }

  /// Tries several common thumbnail locations in order of preference.
  String? _thumbnail(XmlElement item) {
    for (final el in item.descendants.whereType<XmlElement>()) {
      final local = el.name.local;
      if (local == 'thumbnail') {
        final url = el.getAttribute('url');
        if (url != null && _isImage(url)) return url;
      }
      if (local == 'content') {
        final url = el.getAttribute('url');
        if (url != null && _isImage(url)) return url;
      }
      if (local == 'enclosure') {
        final type = el.getAttribute('type') ?? '';
        if (type.startsWith('image/')) {
          return el.getAttribute('url');
        }
      }
    }
    // Last resort: pull first <img src> from content:encoded
    final encoded = item.descendants
        .whereType<XmlElement>()
        .where((e) => e.name.local == 'encoded')
        .firstOrNull
        ?.innerText ?? '';
    final m = RegExp(r'''<img[^>]+src=["']([^"']+)["']''').firstMatch(encoded);
    return m?.group(1);
  }

  bool _isImage(String url) {
    final l = url.toLowerCase();
    return l.contains('.jpg') ||
        l.contains('.jpeg') ||
        l.contains('.png') ||
        l.contains('.webp') ||
        l.contains('.gif');
  }

  /// Strips HTML tags and decodes common entities from RSS descriptions.
  String _clean(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Parses RFC 822 ("Mon, 01 Jan 2024 00:00:00 +0000") and ISO 8601 dates.
  DateTime _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return DateTime.now();
    // ISO 8601 (Atom)
    try {
      return DateTime.parse(raw.trim());
    } catch (_) {}
    // RFC 822 (RSS 2.0)
    try {
      const months = {
        'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4,
        'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8,
        'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
      };
      final str = raw.trim().replaceFirst(RegExp(r'^[A-Za-z]+,\s*'), '');
      final parts = str.split(RegExp(r'\s+'));
      if (parts.length >= 4) {
        final day = int.parse(parts[0]);
        final month = months[parts[1]] ?? 1;
        final year = int.parse(parts[2]);
        final time = parts[3].split(':');
        final hour = int.parse(time[0]);
        final min = time.length > 1 ? int.parse(time[1]) : 0;
        final sec = time.length > 2 ? int.parse(time[2]) : 0;
        return DateTime.utc(year, month, day, hour, min, sec);
      }
    } catch (_) {}
    return DateTime.now();
  }
}
