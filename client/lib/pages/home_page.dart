import 'package:client/main.dart';
import 'package:client/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.token});

  final String? token;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String, dynamic> userInfo;

  @override
  void initState() {
    super.initState();
    userInfo = JwtDecoder.decode(widget.token!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('token');
            // ignore: use_build_context_synchronously
            nextScreen(context, MyApp(token: prefs.getString('token')));
          },
          child: Text(
            userInfo['fullName'],
          ),
        ),
      ),
    );
  }
}
