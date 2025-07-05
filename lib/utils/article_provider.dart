import 'package:artikate_assignment/models/article.dart';
import 'package:artikate_assignment/utils/network_call.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<NetworkCall>((ref) => NetworkCall());

final articleListProvider = FutureProvider<List<Article>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return api.fetchArticles();
});