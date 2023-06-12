import 'dart:convert';
import 'package:client/constants/config.dart';
import 'package:client/pages/auth/register_page.dart';
import 'package:client/pages/home_page.dart';
import 'package:client/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoading = false;
      });

      final reqBody = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };

      try {
        final response = await http.post(
          Uri.parse(loginUrl),
          headers: {'content-type': 'application/json'},
          body: jsonEncode(reqBody),
        );

        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final myToken = jsonResponse['token'];
          prefs.setString('token', myToken);
          // ignore: use_build_context_synchronously
          nextScreen(context, HomePage(token: myToken));
        } else {
          // ignore: use_build_context_synchronously
          showSnackBar(context, Colors.red, 'Login failure');
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, Colors.red, 'Login failure');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffee7b64),
                        ),
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
                        decoration: textInputDecoration('Password', Icons.lock),
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
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffee7b64),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(TextSpan(
                        text: "Don't have an account? ",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                            text: "Register here",
                            style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                nextScreen(context, const RegisterPage());
                              },
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
