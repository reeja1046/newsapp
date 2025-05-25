import 'package:flutter/material.dart';
import 'package:newsapp/constant/colors.dart';
import 'package:newsapp/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create Your Account',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Join to get the latest headlines and personalized news.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          hint: "Full Name",
                          controller: nameController,
                          validator: (value) =>
                              value!.isEmpty ? "Name cannot be empty" : null,
                        ),
                        _buildTextField(
                          hint: "Email Address",
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) return "Email cannot be empty";
                            if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$')
                                .hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          hint: "Password",
                          controller: passwordController,
                          isPassword: true,
                          isPasswordVisible: _isPasswordVisible,
                          onVisibilityToggle: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (value.length < 6) return "Minimum 6 characters";
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.018),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('isLoggedIn', true);

                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                );
                              }
                            },
                            child: Text(
                              'Sign Up',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                       
                      ],
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

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onVisibilityToggle,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? !isPasswordVisible : false,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
        ),
      ),
    );
  }
}
