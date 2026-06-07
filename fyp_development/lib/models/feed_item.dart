import 'package:hive/hive.dart';
import '../core/constants/hive_constants.dart';

part 'feed_item.g.dart';

/// Represents a single item in the daily feed — either an RSS article or a YouTube video.
/// Stored in Hive for offline bookmarking and feed caching.
@HiveType(typeId: kFeedItemTypeId)
class FeedItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String? imageUrl;

  /// Publisher name (e.g. "LambdaTest Blog", "Naveen AutomationLabs")
  @HiveField(4)
  final String source;

  /// Category identifier matching [TestingCategory] enum name
  @HiveField(5)
  final String category;

  @HiveField(6)
  final DateTime date;

  /// Full article text or video description for offline reading
  @HiveField(7)
  final String content;

  /// Link to the original article or YouTube watch URL
  @HiveField(8)
  final String? externalUrl;

  /// 'article' for RSS items, 'video' for YouTube items.
  @HiveField(9)
  final String type;

  /// YouTube video ID — used to build the deep link `youtube://watch?v=<videoId>`.
  /// Null for RSS articles.
  @HiveField(10)
  final String? videoId;

  /// Human-readable video duration (e.g. "12:34"). Null for articles.
  @HiveField(11)
  final String? duration;

  FeedItem({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.source,
    required this.category,
    required this.date,
    required this.content,
    this.externalUrl,
    this.type = 'article',
    this.videoId,
    this.duration,
  });

  bool get isVideo => type == 'video';

  FeedItem copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? source,
    String? category,
    DateTime? date,
    String? content,
    String? externalUrl,
    String? type,
    String? videoId,
    String? duration,
  }) {
    return FeedItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      category: category ?? this.category,
      date: date ?? this.date,
      content: content ?? this.content,
      externalUrl: externalUrl ?? this.externalUrl,
      type: type ?? this.type,
      videoId: videoId ?? this.videoId,
      duration: duration ?? this.duration,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is FeedItem && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
