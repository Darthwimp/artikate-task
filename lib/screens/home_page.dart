import 'package:artikate_assignment/models/article.dart';
import 'package:artikate_assignment/screens/detail_page.dart';
import 'package:artikate_assignment/screens/favourite_articles_page.dart';
import 'package:artikate_assignment/utils/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  Future<void> _onRefresh() async {
    ref.refresh(articleListProvider);
    await Future.delayed(const Duration(milliseconds: 800));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final articlesAsync = ref.watch(articleListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Articles',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavouriteArticlesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: articlesAsync.when(
        loading: () => Center(
          child: Lottie.asset(
            'asset/page_loading_animation.json',
            height: 200,
            width: 200,
            fit: BoxFit.contain,
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (articles) {
          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            header: CustomHeader(
              height: 100,
              builder: (context, mode) {
                return Center(
                  child: Lottie.asset(
                    'asset/refresh_loading_animation.json',
                    height: 80,
                    repeat: true,
                  ),
                );
              },
            ),
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ArticleTile(article: articles[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class ArticleTile extends StatelessWidget {
  final Article article;

  const ArticleTile({super.key, required this.article});

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        capitalize(article.title),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        capitalize(
          article.body.length > 60
              ? '${article.body.substring(0, 60)}...'
              : article.body,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        '#${article.id}',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleDetailScreen(article: article),
          ),
        );
      },
    );
  }
}
