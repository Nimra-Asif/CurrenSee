import 'package:eproject/screens/main/bottom_bar.dart';
import 'package:eproject/services/news_articles_service.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:eproject/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsArticlesScreen extends StatefulWidget {
  const NewsArticlesScreen({Key? key}) : super(key: key);

  @override
  State<NewsArticlesScreen> createState() => _NewsArticlesScreenState();
}

class _NewsArticlesScreen extends StatefulWidget {
  const _NewsArticlesScreen({Key? key}) : super(key: key); // Add constructor

  @override
  State<NewsArticlesScreen> createState() =>
      _NewsArticlesScreenState(); // Correctly connect State
}

class _NewsArticlesScreenState extends State<NewsArticlesScreen> {
  final NewsApiService _newsApiService = NewsApiService();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _articles = [];
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialNews();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMore) {
      _fetchMoreNews();
    }
  }

  Future<void> _fetchInitialNews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final articles =
          await _newsApiService.fetchNews(query: 'currency markets');
      setState(() {
        _articles = articles;
        _hasMore = articles.length >= 18;
      });
    } catch (e) {
      print('Error fetching news: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMoreNews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final articles = await _newsApiService.fetchNews(
        query: 'currency markets',
        isNextPage: true,
      );
      setState(() {
        _articles.addAll(articles);
        _hasMore = articles.length >= 18;
      });
    } catch (e) {
      print('Error fetching news: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Bottom_Bar(
      
      child: Column(children: [
        const CustomAppBar(title: 'News & Articles'),
          Expanded(
            child: _articles.isEmpty && !_isLoading
                ? const Center(child: Text("No articles available."))
                : ListView.builder(
                    itemCount: _articles.length,
                    itemBuilder: (context, index) {
                      final article = _articles[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            // Image Section
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Image.network(
                                article['urlToImage'] ??
                                    'assets/images/default_news.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 180,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    '/images/default_news.jpg',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 180,
                                  );
                                },
                              ),
                            ),
                            // Text Section
                            ListTile(
                              title: Text(
                                article['title'] ?? 'No Title',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                article['description'] ?? 'No Description',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            // Read More Section
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: InkWell(
                                  onTap: () => _launchURL(article['url']),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      "Read More",
                                      style: TextStyle(
                                        color: AppConstant().themeColor,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          )
        ]));
  }

  void _launchURL(String? url) async {
    if (url == null || url.isEmpty) {
      // Handle missing URL gracefully
      print("Invalid URL");
      return;
    }

    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }
}
