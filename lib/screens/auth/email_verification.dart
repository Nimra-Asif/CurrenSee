import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eproject/screens/main/snack_bar.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Email Verification", style: TextStyle(
            color: AppConstant().textColor
          )),centerTitle: true,
          backgroundColor: AppConstant().themeColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please verify your email to continue",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await user.reload();
                      user = FirebaseAuth.instance.currentUser;

                      if (user!.emailVerified) {
                        var userDoc = await FirebaseFirestore.instance
                            .collection('users')
                            .where('useremail', isEqualTo: user.email)
                            .get();

                        if (userDoc.docs.isNotEmpty) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userDoc.docs[0].id)
                              .update({'isVerified': true});
                        }

                        Navigator.pushReplacementNamed(context, '/login');
                      } else {
                        CustomErrorSnackbar.show(
            context, 'Verification Email Sent. Please Verify your Email first!'
          );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: AppConstant().themeColor
                  ),
                  child: Text(
                    "Verify Email",
                    style: TextStyle(fontSize: 18, color: AppConstant().textColor),
                  ),
              ),
            ],
          ),
        ));
  }
}
