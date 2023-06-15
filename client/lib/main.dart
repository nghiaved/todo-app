import 'package:client/constants/app_colors.dart';
import 'package:client/pages/auth/login_page.dart';
import 'package:client/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token')));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.token});

  final String? token;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.whiteColor,
      ),
      home: (token != null && (JwtDecoder.isExpired(token!) == false))
          ? HomePage(token: token)
          : const LoginPage(),
    );
  }
}
