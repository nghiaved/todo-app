import 'package:client/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key, this.data});

  final Map<String, dynamic>? data;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    if (widget.data != null) {
      _titleController = TextEditingController(text: widget.data!['title']);
      _descController = TextEditingController(text: widget.data!['desc']);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('Add Todo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: AppColors.blackColor, fontSize: 24),
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                border: InputBorder.none,
                hintText: 'Title',
                hintStyle: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 24,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descController,
              style: const TextStyle(color: AppColors.blackColor, fontSize: 24),
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Description',
                hintStyle: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 24,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, [_titleController.text, _descController.text]);
        },
        elevation: 10,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.save),
      ),
    );
  }
}
