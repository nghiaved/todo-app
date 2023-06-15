import 'dart:convert';
import 'dart:math';
import 'package:client/constants/app_colors.dart';
import 'package:client/constants/config.dart';
import 'package:client/main.dart';
import 'package:client/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.token});

  final String? token;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  late Map<String, dynamic> userInfo;
  List? todos;

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

  void createTodo() async {
    if (_titleController.text.isNotEmpty && _descController.text.isNotEmpty) {
      var reqBody = {
        "userId": userInfo['_id'],
        "title": _titleController.text,
        "desc": _descController.text,
      };

      var response = await http.post(
        Uri.parse(createTodoUrl),
        headers: {'content-type': 'application/json'},
        body: jsonEncode(reqBody),
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
        _titleController.text = '';
        _descController.text = '';
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Add Todo successfully',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ));
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        readTodo();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Please fill out all information',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  void readTodo() async {
    var uri = '$readTodoUrl?userId=${userInfo['_id']}';

    var response = await http.get(
      Uri.parse(uri),
      headers: {'content-type': 'application/json'},
    );

    var jsonResponse = jsonDecode(response.body);
    setState(() {
      todos = jsonResponse['todos'];
    });
  }

  void updateTodo(String id, String title, String desc) async {
    var uri = '$updateTodoUrl/$id';
    var reqBody = {
      "title": title,
      "desc": desc,
    };

    var response = await http.put(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Update Todo successfully',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      readTodo();
    }
  }

  void deleteTodo(String id) async {
    var uri = '$deleteTodoUrl/$id';

    var response = await http.delete(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json"},
    );

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Delete Todo successfully',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
      readTodo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: GestureDetector(
          onTap: () {},
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
      body: todos == null
          ? const CircularProgressIndicator(color: AppColors.primaryColor)
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  TextField(
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
                        itemCount: todos!.length,
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
                                  _displayTextInputDialog(
                                      context, todos![index]);
                                },
                                title: RichText(
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: '${todos![index]['title']} :\n',
                                    style: const TextStyle(
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      height: 1.5,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: todos![index]['title'],
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
                                    'Edited: Date',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontStyle: FontStyle.italic,
                                      color:
                                          AppColors.blackColor.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    deleteTodo(todos![index]['_id']);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        elevation: 10,
        onPressed: () => _displayTextInputDialog(context, null),
        child: const Icon(Icons.add, size: 38),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context, Map? data) async {
    final TextEditingController title = TextEditingController();
    final TextEditingController desc = TextEditingController();
    title.text = data != null ? data['title'] : '';
    desc.text = data != null ? data['desc'] : '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: data == null ? _titleController : title,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: data == null ? _descController : desc,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (data != null) {
                    updateTodo(data['_id'], title.text, desc.text);
                  } else {
                    createTodo();
                  }
                },
                child: const Text('Add Todo'),
              ),
            ],
          ),
        );
      },
    );
  }
}
