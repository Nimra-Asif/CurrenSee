import 'package:eproject/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:eproject/services/auth_service.dart';
import 'package:eproject/screens/main/snack_bar.dart';


class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final AuthService _authService = AuthService();
  String userName = 'Login Page';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    String name = await _authService.getCurrentUserName();
    setState(() {
      userName = name;
    });
  }

  Future<void> _handleLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      
      if (email.isEmpty || password.isEmpty) {
        CustomErrorSnackbar.show(
          context,
          'Email and Password cannot be empty!',
          
        );
        return;
      }

      var result = await _authService.loginUser(email, password);
      
      if (result['success']) {
        CustomSuccessSnackbar.show(context, result['message'],);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        CustomErrorSnackbar.show(context, result['message'], );
      }
    } catch (e) {
      CustomErrorSnackbar.show(
        context,
        'An unexpected error occurred. Please try again.',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Container
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

          // Login Heading
          Positioned(
            top: 80,
            left: 200,
            child: Row(
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    color: AppConstant().textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.login_rounded,
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
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                        TextFormField(
                          controller: _emailController,
                          enabled: !_isLoading,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email, color: AppConstant().themeColor,size: 20.0),
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                            if (!RegExp(emailPattern).hasMatch(value)) {
                              return 'Invalid email format';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        TextFormField(
                          controller: _passwordController,
                          enabled: !_isLoading,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: AppConstant().themeColor),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: AppConstant().themeColor, size: 20.0
                              ),
                              onPressed: !_isLoading
                                ? () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  }
                                : null,
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
                            return null;
                          },
                        ),

                        SizedBox(height: 30),

                        ElevatedButton(
                          onPressed: _isLoading ? null : () => _handleLogin(context),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: AppConstant().themeColor,
                          ),
                          child: Center(
                            child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: AppConstant().themeColor,
                                    backgroundColor: AppConstant().textColor,
                                  ),
                                )
                              : Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstant().textColor,
                                  ),
                                ),
                          ),
                        ),

                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an Account?",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppConstant().secondaryColor,
                              ),
                            ),
                            TextButton(
                              onPressed: _isLoading
                                ? null
                                : () {
                                    Navigator.pushReplacementNamed(context, '/signup');
                                  },
                              child: Text(
                                "Register Yourself",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstant().themeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 30),
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