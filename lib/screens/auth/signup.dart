import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eproject/screens/auth/email_verification.dart';
import 'package:eproject/screens/auth/encrypted_password.dart';
import 'package:eproject/screens/main/snack_bar.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eproject/services/country_service.dart';
import 'package:eproject/models/country_model.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _preferenceController = TextEditingController();

  // Declare baseCurrency
  String baseCurrency = '';

  // Declare countries list
  List<Country> countries = [];

  // Fetch countries asynchronously
  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    // Wait for countries to be fetched from CountryService
    List<Country> fetchedCountries = await CountryService().fetchCountries();

    setState(() {
      countries = fetchedCountries;
    });
  }

  Future<void> UserRegistration(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        String name = _nameController.text.trim();
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();
        String baseCurrency = _preferenceController.text;

        // Check if email already exists
        var emailCheck = await FirebaseFirestore.instance
            .collection("users")
            .where('useremail', isEqualTo: email)
            .get();

        if (emailCheck.docs.isNotEmpty) {
          CustomErrorSnackbar.show(context, 'Email already exists');
          return;
        }

        // Register user
        String encryptedPassword = EncryptionUtil.encryptPassword(password);

        // Create user in Firebase Auth
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: encryptedPassword,
        );
        User? user = userCredential.user;

        if (user != null) {
          // Send email verification
          await user.sendEmailVerification();

          // Add user to Firestore
          await FirebaseFirestore.instance.collection("users").add({
            'username': name,
            'useremail': email,
            'userpassword': password,
            'isVerified': false,
            'setCurrencyPreference': baseCurrency,
            'createdAt': DateTime.now(),
          });

          // Navigate to EmailVerification
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EmailVerification()),
            );
          }

          // Show success message
          CustomSuccessSnackbar.show(context, 'Verification Email Sent. Please Verify your Email first!');

          // Clear input fields
          _nameController.clear();
          _emailController.clear();
          _passwordController.clear();
          _preferenceController.clear();
        }
      }
    } catch (e) {
      CustomErrorSnackbar.show(context, 'An error occured $e');
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Gradient Overlay
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('/images/formBackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withOpacity(0.6),
                    Colors.purpleAccent.withOpacity(0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Registration Heading
          Positioned(
            top: 60,
            left: 140,
            child: Row(
              children: [
                Text(
                  "Registration",
                  style: TextStyle(
                    color: AppConstant().textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.supervised_user_circle_outlined,
                  color: AppConstant().textColor,
                  size: 30.0,
                ),
              ],
            ),
          ),

          // Form Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Container(
                height: 480,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: AppConstant().textColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //   DropDownSearchField(
                        //     textFieldConfiguration: TextFieldConfiguration(
                        //       controller: _preferenceController,
                        //       decoration: InputDecoration(
                        //         labelText: "Set Base Preference Currency",
                        //         labelStyle: TextStyle(fontSize: 14.0),
                        //         prefixIcon: Icon(Icons.arrow_drop_down_outlined),
                        //           border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(15),
                        //     ),
                        //    focusedBorder: OutlineInputBorder(),
                        //       ),
                        //     ),
                        //     suggestionsCallback: (pattern) async {
                        //       return countries
                        //           .where((c) =>
                        //               c.country
                        //                   .toLowerCase()
                        //                   .contains(pattern.toLowerCase()) ||
                        //               c.code
                        //                   .toLowerCase()
                        //                   .contains(pattern.toLowerCase()))
                        //           .map((c) => {
                        //                 'name': c.country,
                        //                 'code': c.code,
                        //                 'flag': c.flag,
                        //               })
                        //           .toList();
                        //     },
                        //     itemBuilder: (context, suggestion) {
                        //       return ListTile(
                        //         leading: Image.asset(
                        //           suggestion['flag']!,
                        //           width: 25,
                        //           height: 15,
                        //           fit: BoxFit.cover,
                        //         ),
                        //         title: Text(
                        //           suggestion['name']!,
                        //           style: TextStyle(fontSize: 14.0),
                        //         ),
                        //       );
                        //     },
                        //     onSuggestionSelected: (suggestion) {
                        //       setState(() {
                        //         // Updating baseCurrency directly when a suggestion is selected
                        //         baseCurrency =
                        //             suggestion['code']!.toUpperCase();

                        //         // Updating the controller text as well
                        //         _preferenceController.text = suggestion['code']!;
                        //       });
                        //     },
                        //     displayAllSuggestionWhenTap: true,
                        //   ),

                        // SizedBox(height: 20,),
                        // Name Input Field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person,
                                color: AppConstant().themeColor, size: 20.0,),
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        // Email Input Field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email,
                                color: AppConstant().themeColor, size: 20.0),
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            String emailPattern =
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                            if (!RegExp(emailPattern).hasMatch(value)) {
                              return 'Invalid email format';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        // Password Input Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock,
                                color: AppConstant().themeColor, size: 20.0),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppConstant().themeColor, size: 20.0
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        // Confirm Password Input Field
                        TextFormField(
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock,
                                color: AppConstant().themeColor, size: 20.0),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppConstant().themeColor, size: 20.0
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm Password is required';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        // Signup Button
                        ElevatedButton(
                          onPressed: () => UserRegistration(context),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            backgroundColor: AppConstant().themeColor,
                          ),
                          child: Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppConstant().textColor,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Login Text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppConstant().secondaryColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstant().themeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
