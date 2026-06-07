import '../../models/feed_item.dart';

/// Abstract contract for the RSS articles data source.
abstract class ArticlesRepository {
  Future<List<FeedItem>> getArticles();
}
