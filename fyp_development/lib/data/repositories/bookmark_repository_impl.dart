import '../../models/feed_item.dart';
import '../services/hive_service.dart';
import 'bookmark_repository.dart';

/// Hive-backed implementation of [BookmarkRepository].
/// All data persists offline between app launches.
class BookmarkRepositoryImpl implements BookmarkRepository {
  final HiveService _hiveService;

  BookmarkRepositoryImpl(this._hiveService);

  @override
  List<FeedItem> getAll() => _hiveService.getAllBookmarks();

  @override
  Future<void> save(FeedItem item) => _hiveService.saveBookmark(item);

  @override
  Future<void> remove(String id) => _hiveService.deleteBookmark(id);

  @override
  bool contains(String id) => _hiveService.isBookmarked(id);
}
