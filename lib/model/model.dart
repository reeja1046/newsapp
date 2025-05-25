class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String sourceName;
  final DateTime publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.sourceName,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['image'] ?? '',
      sourceName: json['source']['name'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'url': url,
        'image': imageUrl,
        'source': {'name': sourceName},
        'publishedAt': publishedAt.toIso8601String(),
      };
}
