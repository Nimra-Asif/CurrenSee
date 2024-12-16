import 'package:eproject/screens/main/snack_bar.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isLoggedIn = false;
  String? userName;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Check if user is logged in
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        isLoggedIn = true;
        userName = user.displayName ?? 'User'; // Fetch the user's name
      });
    } else {
      setState(() {
        isLoggedIn = false;
        userName = null;
      });
    }
  }

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error during logout: $e");
      CustomErrorSnackbar.show(context, 'Error logging out. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppConstant().themeColor,
      title: Text(
        widget.title,
        style: TextStyle(
          color: AppConstant().textColor,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      actions: [
        if (isLoggedIn)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  userName ?? 'User',
                  style: TextStyle(
                    color: AppConstant().textColor,
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: _handleLogout,
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: AppConstant().dangerColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text(
              "Login",
              style: TextStyle(
                color: AppConstant().textColor,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}