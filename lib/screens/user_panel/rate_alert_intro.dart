import 'package:eproject/screens/user_panel/rate_alert_screen.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:eproject/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RateAlertIntro extends StatelessWidget {
  const RateAlertIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Rate Alert'),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Icon(
                    Icons.show_chart,
                    size: 80,
                    color: AppConstant().themeColor,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Currency Rate Alerts',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                   Text(
                    'Set your rate alert. We will notify you when your target rate is reached.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstant().secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant().themeColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RateAlertScreen(),
                          ),
                        );
                      } else {
                        Navigator.pushNamed(context, '/login');
                      }
                    },
                    child: Text(
                      'Set Alert',
                      style: TextStyle(fontSize: 15, color: AppConstant().textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}