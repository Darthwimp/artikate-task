import 'package:artikate_assignment/models/article.dart';
import 'package:dio/dio.dart';
class NetworkCall {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36',
        'Accept': 'application/json',
        'Accept-Encoding': 'identity', // Prevent Dio from using gzip
        'Connection': 'keep-alive',
      },
      validateStatus: (status) => status! < 500, // So we can catch 403 manually
    ),
  );

  Future<List<Article>> fetchArticles() async {
    try {
      final response = await _dio.get('/posts');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => Article.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Dio error: ${e.response?.statusCode} - ${e.message}');
      rethrow;
    }
  }
}