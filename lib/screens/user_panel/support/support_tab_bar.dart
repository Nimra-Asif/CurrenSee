import 'package:eproject/screens/user_panel/support/contact_form.dart';
import 'package:eproject/screens/user_panel/support/issue_reporting.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:flutter/material.dart';

class SupportTabBar extends StatefulWidget {
  const SupportTabBar({super.key});

  @override
  State<SupportTabBar> createState() => _SupportTabBarState();
}

class _SupportTabBarState extends State<SupportTabBar> {
  @override
  Widget build(BuildContext context) {
   return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Support',
            style: TextStyle(color: AppConstant().themeColor),
          ), centerTitle: true,
          bottom: TabBar(
            indicatorColor: AppConstant().themeColor,
            labelColor: AppConstant().themeColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.contact_support), text: 'Contact Support'),
              Tab(icon: Icon(Icons.report), text: 'Issue Report'),
            ],
          ),
        ),
        body: TabBarView(children: [
          ContactSupport(),
          IssueReporting()
        ]),
      ),
    );
  }
}
