import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:flutter/material.dart';

class Bottom_Bar extends StatefulWidget {
  final Widget child;

  const Bottom_Bar({super.key, required this.child});

  @override
  State<Bottom_Bar> createState() => _Bottom_BarState();
}

class _Bottom_BarState extends State<Bottom_Bar> {
  final List<String> routes = [
    '/historyScreen',
    '/thresholdRate',
    '/home',
    '/news',
  ];

  int _page = 0;

  void _onMoreSelected(String value) {
    switch (value) {
      case 'Help Center':
        Navigator.pushNamed(context, '/contactSupport');
        break;
      case 'Supported Currencies':
        Navigator.pushNamed(context, '/supportedCurrencies');
        break;
      case 'Notifications':
        Navigator.pushNamed(context, '/notifications');
        break;
      case 'FAQ':
        Navigator.pushNamed(context, '/FAQ');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.purple[200]!,
        animationDuration: const Duration(milliseconds: 200),
        index: _page,
        items: [
          CurvedNavigationBarItem(
              icon: Icon(
                Icons.history,
                size: 25,
                color: AppConstant().themeColor,
              ),
              label: "History"),
          CurvedNavigationBarItem(
              icon: Icon(Icons.trending_up,
                  size: 25, color: AppConstant().themeColor),
              label: "Threshold Rate"),
          CurvedNavigationBarItem(
              icon: Icon(Icons.swap_horiz,
                  size: 25, color: AppConstant().themeColor),
              label: "Converter"),
          CurvedNavigationBarItem(
              icon: Icon(Icons.article_outlined,
                  size: 25, color: AppConstant().themeColor),
              label: "News"),
          CurvedNavigationBarItem(
            icon: PopupMenuButton<String>(
              onSelected: _onMoreSelected,
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'Help Center',
                  child: Row(
                    children: [
                      Icon(
                        Icons.contact_page_outlined,
                        size: 25,
                        color: AppConstant().themeColor,
                      ),
                      const SizedBox(width: 10),
                      const Text('Help Center'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'Supported Currencies',
                  child: Row(
                    children: [
                      Icon(
                        Icons.list,
                        size: 25,
                        color: AppConstant().themeColor,
                      ),
                      const SizedBox(width: 10),
                      const Text('Supported Currencies'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'Notifications',
                  child: Row(
                    children: [
                      Icon(
                        Icons.notification_add_outlined,
                        size: 25,
                        color: AppConstant().themeColor,
                      ),
                      const SizedBox(width: 10),
                      const Text('Notifications'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'FAQ',
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        size: 25,
                        color: AppConstant().themeColor,
                      ),
                      const SizedBox(width: 10),
                      const Text('FAQ'),
                    ],
                  ),
                ),
              ],
              child: const Icon(Icons.more_horiz, size: 25),
            ),
            label: "More",
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
          if (index < routes.length) {
            Navigator.pushReplacementNamed(context, routes[index]);
          }
        },
      ),
    );
  }
}