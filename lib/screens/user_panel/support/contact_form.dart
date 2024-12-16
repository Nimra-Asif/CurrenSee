import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eproject/screens/auth/login.dart';
import 'package:eproject/screens/main/bottom_bar.dart';
import 'package:eproject/screens/main/snack_bar.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactSupport extends StatefulWidget {
  const ContactSupport({super.key});

  @override
  State<ContactSupport> createState() => _ContactSupportState();
}

class _ContactSupportState extends State<ContactSupport> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please log in first.',
            style: TextStyle(
              color: AppConstant().textColor,
            ),
          ),
          action: SnackBarAction(
            label: 'Login Here',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppConstant().dangerColor,
          width: 470,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('support_messages').add({
        'userId': user.uid,
        'message': _messageController.text,
        'phone': _phoneController.text,
        'timestamp': Timestamp.now(),
      });

      CustomSuccessSnackbar.show(context, 'Message sent successfully!');

      _messageController.clear();
      _phoneController.clear();
    } catch (e) {
      CustomErrorSnackbar.show(context, 'Message sent failed!');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Bottom_Bar(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "We are here to Support You!",
                style: TextStyle(
                  color: AppConstant().themeColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _messageController,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: 'Feedback or Query?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Message is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                enabled: !_isLoading,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Your Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: AppConstant().themeColor,
                ),
                child: Center(
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Send',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppConstant().textColor
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
