import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/constant/colors.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> dummyArticles = List.generate(
      5,
      (index) => {
            'title': 'News Title $index',
            'description': 'Short description of news article number $index.',
            'source': 'News Source $index',
            'imageUrl': 'https://via.placeholder.com/150',
            'url': 'https://example.com',
            'publishedAt': DateTime.now().subtract(Duration(days: index)),
          });

  final List<Map<String, dynamic>> bookmarks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          _selectedIndex == 0 ? 'News' : 'Bookmarks',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _selectedIndex == 0 ? _buildNewsPage() : _buildBookmarksPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor:
            AppColors.primaryColor, 
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle:
            TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }

  Widget _buildNewsPage() {
    return ListView.builder(
      itemCount: dummyArticles.length,
      itemBuilder: (context, index) {
        final article = dummyArticles[index];
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: Image.network(article['imageUrl'],
                width: 80, fit: BoxFit.cover),
            title: Text(article['title'],
                maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article['description'],
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                Text(
                    '${article['source']} • ${DateFormat("d MMMM, y").format(article['publishedAt'])}')
              ],
            ),
            trailing: IconButton(
              icon: Icon(bookmarks.contains(article)
                  ? Icons.bookmark
                  : Icons.bookmark_border),
              onPressed: () {
                setState(() {
                  if (bookmarks.contains(article)) {
                    bookmarks.remove(article);
                  } else {
                    bookmarks.add(article);
                  }
                });
              },
            ),
            // onTap: () => Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (_) => WebViewPage(url: article['url'])),
            // ),
          ),
        );
      },
    );
  }

  Widget _buildBookmarksPage() {
    return bookmarks.isEmpty
        ? const Center(child: Text('No bookmarks yet.'))
        : ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final article = bookmarks[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: Image.network(article['imageUrl'],
                      width: 80, fit: BoxFit.cover),
                  title: Text(article['title'], maxLines: 2),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => setState(() => bookmarks.remove(article)),
                  ),
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => WebViewPage(url: article['url'])),
                  // ),
                ),
              );
            },
          );
  }
}
