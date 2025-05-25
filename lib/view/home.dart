import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/constant/colors.dart';
import 'package:newsapp/controller/provider.dart';
import 'package:newsapp/controller/service.dart';
import 'package:newsapp/model/model.dart';
import 'package:newsapp/view/webview.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<NewsArticle>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = NewsController().fetchNewsArticles();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text('News App', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.article), text: 'News'),
              Tab(icon: Icon(Icons.bookmark), text: 'Bookmarks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNewsPage(),
            _buildBookmarksPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsPage() {
    return FutureBuilder<List<NewsArticle>>(
      future: futureArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No news available.'));
        } else {
          final articles = snapshot.data!;
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                 leading: SizedBox(
  width: 80,
  height: 80,
  child: Image.network(
    article.imageUrl,
    fit: BoxFit.cover,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        // Image is fully loaded
        return child;
      }
      // While loading, show CircularProgressIndicator centered
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              : null,
        ),
      );
    },
    errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.broken_image),
  ),
),

                  title: Text(article.title,
                      maxLines: 2, overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(article.description,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      Text(
                          '${article.sourceName} • ${DateFormat("d MMMM, y").format(article.publishedAt)}'),
                    ],
                  ),
                  trailing: Consumer<BookmarkProvider>(
                    builder: (context, bookmarkProvider, _) {
                      final bookmarked = bookmarkProvider.isBookmarked(article);
                      return IconButton(
                        icon: Icon(
                          bookmarked ? Icons.bookmark : Icons.bookmark_border,
                        ),
                        onPressed: () {
                          bookmarkProvider.toggleBookmark(article);
                        },
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(url: article.url),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildBookmarksPage() {
    return Consumer<BookmarkProvider>(
      builder: (context, bookmarkProvider, _) {
        final bookmarks = bookmarkProvider.bookmarks;
        if (bookmarks.isEmpty) {
          return const Center(child: Text('No bookmarks yet.'));
        }
        return ListView.builder(
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            final article = bookmarks[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: Image.network(article.imageUrl,
                    width: 80, fit: BoxFit.cover),
                title: Text(article.title, maxLines: 2),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(article.description,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text(
                        '${article.sourceName} • ${DateFormat("d MMMM, y").format(article.publishedAt)}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    bookmarkProvider.removeBookmark(article);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(url: article.url),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
