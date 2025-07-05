import 'package:artikate_assignment/screens/home_page.dart';
import 'package:artikate_assignment/utils/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteArticlesPage extends ConsumerWidget {
  const FavouriteArticlesPage({super.key});

  Future<List<String>> _getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsync = ref.watch(articleListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: FutureBuilder<List<String>>(
        future: _getFavoriteIds(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final favoriteIds = snapshot.data!;
          return articlesAsync.when(
            data: (articles) {
              final favoriteArticles = articles.where(
                (article) => favoriteIds.contains(article.id.toString()),
              ).toList();

              if (favoriteArticles.isEmpty) {
                return const Center(child: Text('No favorite articles yet.'));
              }

              return ListView.builder(
                itemCount: favoriteArticles.length,
                itemBuilder: (context, index) =>
                    ArticleTile(article: favoriteArticles[index]),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
      ),
    );
  }
}