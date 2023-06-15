import 'dart:convert';
import 'package:client/constants/app_colors.dart';
import 'package:client/constants/config.dart';
import 'package:client/pages/auth/login_page.dart';
import 'package:client/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoading = false;
      });

      final reqBody = {
        "fullName": _fullNameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
      };

      try {
        final response = await http.post(
          Uri.parse(registerUrl),
          headers: {'content-type': 'application/json'},
          body: jsonEncode(reqBody),
        );

        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          _fullNameController.text = '';
          _emailController.text = '';
          _passwordController.text = '';
          // ignore: use_build_context_synchronously
          showSnackBar(context, AppColors.greenColor, 'Register successfully');
        } else {
          // ignore: use_build_context_synchronously
          showSnackBar(context, AppColors.redColor, 'Register failure');
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, AppColors.redColor, 'Register failure');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            )
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _fullNameController,
                          decoration:
                              textInputDecoration('Fullname', Icons.person),
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return 'Fullname cannot be empty';
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: textInputDecoration('Email', Icons.email),
                          validator: (value) {
                            return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            ).hasMatch(value!)
                                ? null
                                : "Please enter a valid email";
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration:
                              textInputDecoration('Password', Icons.lock),
                          obscureText: true,
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Password must be at least 6 characters";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: register,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: AppColors.whiteColor, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(
                                color: AppColors.blackColor, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Login now",
                                style: const TextStyle(
                                  color: AppColors.blackColor,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const LoginPage());
                                  },
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
}
