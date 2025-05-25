import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newsapp/model/model.dart';

class BookmarkProvider extends ChangeNotifier {
  List<NewsArticle> _bookmarks = [];

  List<NewsArticle> get bookmarks => _bookmarks;

  BookmarkProvider() {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList('bookmarks');
    if (saved != null) {
      _bookmarks = saved.map((e) => NewsArticle.fromJson(json.decode(e))).toList();
      notifyListeners();
    }
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = _bookmarks.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('bookmarks', saved);
  }

  bool isBookmarked(NewsArticle article) {
    return _bookmarks.any((item) => item.url == article.url);
  }

  void toggleBookmark(NewsArticle article) {
    if (isBookmarked(article)) {
      _bookmarks.removeWhere((item) => item.url == article.url);
    } else {
      _bookmarks.add(article);
    }
    _saveBookmarks();
    notifyListeners();
  }

  void removeBookmark(NewsArticle article) {
    _bookmarks.removeWhere((item) => item.url == article.url);
    _saveBookmarks();
    notifyListeners();
  }
}
