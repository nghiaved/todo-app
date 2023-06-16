import 'dart:convert';
import 'package:client/constants/app_colors.dart';
import 'package:client/constants/config.dart';
import 'package:client/pages/home_page.dart';
import 'package:client/widgets/pic_picker.dart';
import 'package:client/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.userInfo});

  final Map<String, dynamic> userInfo;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();
  bool isImageSelected = false;

  @override
  void initState() {
    _fullNameController =
        TextEditingController(text: widget.userInfo['fullName']);
    _emailController = TextEditingController(text: widget.userInfo['email']);
    super.initState();
  }

  update() async {
    if (formKey.currentState!.validate()) {
      var uri = '$updateUrl/${widget.userInfo['_id']}';
      var reqBody = {
        "fullName": _fullNameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "image": widget.userInfo['image'],
      };

      var response = await http.put(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        final myToken = jsonResponse['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', myToken);
        // ignore: use_build_context_synchronously
        nextScreen(context, HomePage(token: myToken));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: picPicker(
                    isImageSelected,
                    widget.userInfo['image'] ?? '',
                    (file) => {
                      setState(
                        () {
                          widget.userInfo['image'] = file.path;
                          isImageSelected = true;
                        },
                      )
                    },
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _fullNameController,
                  decoration: textInputDecoration('Fullname', Icons.person),
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
                    onPressed: update,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
