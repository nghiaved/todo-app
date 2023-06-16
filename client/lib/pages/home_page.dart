import 'dart:convert';
import 'dart:math';
import 'package:client/constants/app_colors.dart';
import 'package:client/helpers/http_helper.dart';
import 'package:client/main.dart';
import 'package:client/pages/edit_profile_page.dart';
import 'package:client/pages/form_page.dart';
import 'package:client/widgets/delete_dialog.dart';
import 'package:client/widgets/image_widget.dart';
import 'package:client/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.token});

  final String? token;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Map<String, dynamic> userInfo;
  List todos = [];
  List filtered = [];

  @override
  void initState() {
    super.initState();
    userInfo = JwtDecoder.decode(widget.token!);
    readTodo();
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      todos = filtered
          .where((data) =>
              data['title'].toLowerCase().contains(searchText.toLowerCase()) ||
              data['desc'].toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void createTodo(String title, String desc) async {
    if (title.isNotEmpty && desc.isNotEmpty) {
      final reqBody = {
        "userId": userInfo['_id'],
        "title": title,
        "desc": desc,
      };

      final response = await HttpHelper.createTodo(reqBody);

      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, AppColors.greenColor, 'Add Todo successfully');
        readTodo();
      }
    } else {
      showSnackBar(
          context, AppColors.redColor, 'Please fill out all information');
    }
  }

  void readTodo() async {
    final response = await HttpHelper.readTodo(userInfo['_id']);

    final jsonResponse = jsonDecode(response.body);
    setState(() {
      todos = jsonResponse['todos'];
      filtered = todos;
    });
  }

  void updateTodo(String id, String title, String desc) async {
    if (title.isNotEmpty && desc.isNotEmpty) {
      final reqBody = {
        "title": title,
        "desc": desc,
      };

      final response = await HttpHelper.updateTodo(id, reqBody);

      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, AppColors.greenColor, 'Update Todo successfully');
        readTodo();
      }
    } else {
      showSnackBar(
          context, AppColors.redColor, 'Please fill out all information');
    }
  }

  void deleteTodo(String id) async {
    final response = await HttpHelper.deleteTodo(id);

    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, AppColors.greenColor, 'Delete Todo successfully');
      readTodo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: const Icon(Icons.menu),
        ),
        title: Text(userInfo['fullName']),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('token');
              // ignore: use_build_context_synchronously
              nextScreen(context, MyApp(token: prefs.getString('token')));
            },
            child: const Icon(Icons.exit_to_app),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            TextField(
              onChanged: onSearchTextChanged,
              decoration:
                  textInputDecoration('Search...', Icons.search).copyWith(
                labelStyle: TextStyle(
                  color: AppColors.blackColor.withOpacity(0.6),
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: getRandomColor(),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListTile(
                        onTap: () async {
                          final result = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return FormPage(data: todos[index]);
                          }));

                          if (result != null) {
                            updateTodo(
                              todos[index]['_id'],
                              result[0],
                              result[1],
                            );
                          }
                        },
                        title: RichText(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: '${todos[index]['title']} :\n',
                            style: const TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: todos[index]['desc'],
                                style: const TextStyle(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Edited: ${DateFormat('EEE MMM d, yyyy h:mm a').format(DateTime.parse(todos[index]['updatedAt']))}',
                            style: TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: AppColors.blackColor.withOpacity(0.6),
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            showDeleteDialog(
                              context,
                              () {
                                deleteTodo(todos[index]['_id']);
                                Navigator.pop(context);
                              },
                            );
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        elevation: 10,
        // onPressed: () => _displayTextInputDialog(context, null),
        onPressed: () async {
          final result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return const FormPage();
          }));

          if (result != null) {
            createTodo(result[0], result[1]);
          }
        },
        child: const Icon(Icons.add, size: 38),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.secondColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Profile',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: ImageWidget(image: userInfo['image'] ?? ''),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fullname',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userInfo['fullName'],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Icon(
                    Icons.email,
                    size: 40,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userInfo['email'],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryColor,
                  ),
                  child: InkWell(
                    onTap: () {
                      nextScreen(context, EditProfilePage(userInfo: userInfo));
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
