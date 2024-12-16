import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  final String _apiKey = '5ee84060f9dd4e768dc150bce63399ef';
  final String _baseUrl = 'https://newsapi.org/v2/everything';
  int _currentPage = 1;
  final int _pageSize = 18;

  Future<List<dynamic>> fetchNews({required String query, bool isNextPage = false}) async {
    if (isNextPage) {
      _currentPage++;
    } else {
      _currentPage = 1;
    }

    final url = Uri.parse(
      '$_baseUrl?q=$query&page=$_currentPage&pageSize=$_pageSize&apiKey=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}