import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newsapp/model/model.dart';

class NewsController {
  Future<List<NewsArticle>> fetchNewsArticles() async {
    final url = Uri.parse(
        'https://gnews.io/api/v4/search?q=latest&lang=en&country=us&max=10&apikey=57829ebf5e84c50f966c7a7e55c2f9b4');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List articles = jsonData['articles'];
      return articles.map((item) => NewsArticle.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
