import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'core/constants/hive_constants.dart';
import 'models/feed_item.dart';
import 'models/chat_message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Hive Initialization ──────────────────────────────────────────────────
  await Hive.initFlutter();

  Hive.registerAdapter(FeedItemAdapter());    // typeId: 0
  Hive.registerAdapter(ChatMessageAdapter()); // typeId: 1

  await Future.wait([
    Hive.openBox<FeedItem>(kBookmarkBoxName),
    Hive.openBox<ChatMessage>(kChatHistoryBoxName),
    Hive.openBox<FeedItem>(kFeedCacheBoxName),
    Hive.openBox<FeedItem>(kArticlesCacheBoxName),
    Hive.openBox<dynamic>(kMetaBoxName),
  ]);

  runApp(const ProviderScope(child: AppRoot()));
}
