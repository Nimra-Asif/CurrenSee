import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eproject/screens/main/bottom_bar.dart';
import 'package:eproject/screens/main/snack_bar.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IssueReporting extends StatefulWidget {
  const IssueReporting({super.key});

  @override
  State<IssueReporting> createState() => _IssueReportingState();
}

class _IssueReportingState extends State<IssueReporting> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _issueController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

   Future<void> _submitIssue() async {
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
      await FirebaseFirestore.instance.collection('issue_reports').add({
        'userId': user.uid,
        'message': _issueController.text,
        // 'phone': _phoneController.text,
        'timestamp': Timestamp.now(),
      });

     CustomSuccessSnackbar.show(context, 'Issue Reported Successfully!');

      _issueController.clear();
      // _phoneController.clear();
    } catch (e) {
      CustomErrorSnackbar.show(context, 'Issue reported Failed!');
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
                "Report Issue if you face Any!",
                style: TextStyle(
                  color: AppConstant().themeColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ), 
              SizedBox(height: 20),
              TextFormField(
                controller: _issueController,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: 'Issue',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitIssue,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: AppConstant().dangerColor,
                ),
                child: Center(
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Report',
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
