import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';
import 'package:curved_navigation_bar_with_label/nav_custom_painter.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:flutter/material.dart';

class demo extends StatefulWidget {
  final Widget child;

  const demo({super.key, required this.child});

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  // Routes for navigation items
  final List<String> routes = [
    '/historyScreen',
    '/thresholdRate',
    '/home',
    '/news',
  ];

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  void _onMoreSelected(String value) {
    switch (value) {
      case 'Contact Support':
        Navigator.pushNamed(context, '/contactSupport');
        break;
      case 'Supported Currencies':
        Navigator.pushNamed(context, '/supportedCurrencies');
        break;
      case 'Notifications':
        Navigator.pushNamed(context, '/notifications');
        break;
      case 'Logout':
        Navigator.pushNamed(context, '/logout');
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
        index: 2,
        key: _bottomNavigationKey,
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
                  value: 'Contact Support',
                  child: Row(
                    children: [
                      Icon(
                        Icons.contact_page_outlined,
                        size: 25,
                        color: AppConstant().themeColor,
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text('Contact Support'),
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
                      Padding(padding: EdgeInsets.only(left: 10)),
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
                      Padding(padding: EdgeInsets.only(left: 10)),
                      const Text('Notifications'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'Logout',
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        size: 25,
                        color: AppConstant().themeColor,
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text('Log Out'),
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
          if (index < routes.length) {
            Navigator.pushNamed(context, routes[index]);
          }
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
