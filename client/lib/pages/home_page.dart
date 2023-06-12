import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
        child: Text(
          userInfo['fullName'],
        ),
      ),
    );
  }
}
