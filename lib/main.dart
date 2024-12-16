import 'package:eproject/firebase_options.dart';
import 'package:eproject/screens/auth/email_verification.dart';
import 'package:eproject/screens/auth/login.dart';
import 'package:eproject/screens/auth/signup.dart';
import 'package:eproject/screens/converter_screen.dart';
import 'package:eproject/screens/faq.dart';
import 'package:eproject/screens/main/demo.dart';
import 'package:eproject/screens/main/splash_screen.dart';
import 'package:eproject/screens/news_articles.dart';
import 'package:eproject/screens/supported_currencies.dart';
import 'package:eproject/screens/user_panel/history.dart';
import 'package:eproject/screens/user_panel/manage_alerts_screen.dart';
import 'package:eproject/screens/user_panel/notifications_screen.dart';
import 'package:eproject/screens/user_panel/rate_alert_intro.dart';
import 'package:eproject/screens/user_panel/rate_alerts.dart';
import 'package:eproject/screens/user_panel/support/support_tab_bar.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyBGy6tHByX0QxXLcJLuMWazfWSgWbgUA4g",
    appId: "1:919740703819:web:e8290d29f815919d99d9ce",
    messagingSenderId: "919740703819",
    projectId: "currensee-e5506",
    databaseURL: "https://currensee-e5506-default-rtdb.firebaseio.com/",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstant().themeColor),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      routes: {
        '/splashScreen': (context) => SplashScreen(),
        '/home': (context) => ConverterScreen(),
        '/signup': (context) => Signup(),
        '/verifyEmail': (context) => EmailVerification(),
        '/login': (context) => LoginUser(),
        '/historyScreen': (context) => HistoryScreen(),
        '/thresholdRate': (context) => RateAlertIntro(),
        '/supportedCurrencies': (context) => SupportedCurrenciesList(),
        '/news': (context) => NewsArticlesScreen(),
        '/contactSupport': (context) => SupportTabBar(),
        '/FAQ': (context) => FAQPage(),
        '/manage-alerts': (context) => ManageAlertsScreen(),
        '/notifications': (context) => NotificationsScreen()
      },
    );
  }
}
