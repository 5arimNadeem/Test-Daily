import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/dio_client.dart';
import '../core/utils/connectivity_service.dart';
import '../data/repositories/ai_repository.dart';
import '../data/repositories/ai_repository_impl.dart';
import '../data/repositories/articles_repository.dart';
import '../data/repositories/articles_repository_impl.dart';
import '../data/repositories/bookmark_repository.dart';
import '../data/repositories/bookmark_repository_impl.dart';
import '../data/repositories/feed_repository.dart';
import '../data/repositories/feed_repository_impl.dart';
import '../data/services/ai_service.dart';
import '../data/services/hive_service.dart';
import '../data/services/rss_service.dart';
import '../data/services/secure_storage_service.dart';
import '../data/services/youtube_service.dart';

// ─── Infrastructure ───────────────────────────────────────────────────────────

final dioProvider = Provider<Dio>((ref) => DioClient.instance);

final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);

final aiServiceProvider = Provider<AiService>(
  (ref) => AiService(ref.read(dioProvider)),
);

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService(),
);

final rssServiceProvider = Provider<RssService>(
  (ref) => RssService(ref.read(dioProvider)),
);

final youtubeServiceProvider = Provider<YoutubeService>(
  (ref) => YoutubeService(
    ref.read(dioProvider),
    ref.read(secureStorageProvider),
  ),
);

// ─── Repositories ─────────────────────────────────────────────────────────────

/// YouTube videos repository — powers the Home feed.
final feedRepositoryProvider = Provider<FeedRepository>(
  (ref) => FeedRepositoryImpl(
    youtubeService: ref.read(youtubeServiceProvider),
    hiveService: ref.read(hiveServiceProvider),
    connectivityService: ref.read(connectivityServiceProvider),
  ),
);

/// RSS articles repository — powers the Articles feed.
final articlesRepositoryProvider = Provider<ArticlesRepository>(
  (ref) => ArticlesRepositoryImpl(
    rssService: ref.read(rssServiceProvider),
    hiveService: ref.read(hiveServiceProvider),
    connectivityService: ref.read(connectivityServiceProvider),
  ),
);

final bookmarkRepositoryProvider = Provider<BookmarkRepository>(
  (ref) => BookmarkRepositoryImpl(ref.read(hiveServiceProvider)),
);

final aiRepositoryProvider = Provider<AiRepository>(
  (ref) => AiRepositoryImpl(
    ref.read(aiServiceProvider),
    ref.read(secureStorageProvider),
  ),
);
