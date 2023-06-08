import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo["title"];
      final description = todo["description"];
      titleController.text = title;
      descController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isEdit ? Text("Edit Task") : Text("Add Task"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: "Title",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.teal),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.teal),
              ),
            ),
            cursorColor: Colors.teal,
          ),
          TextField(
            controller: descController,
            decoration: const InputDecoration(
              hintText: "Description",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.teal),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.teal),
              ),
            ),
            minLines: 5,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            cursorColor: Colors.teal,
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
              onPressed: () {
                isEdit ? updateData() : submitData();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
              ),
              child: isEdit
                  ? const Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
                    )
                  : const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ))
        ],
      ),
    );
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final desc = descController.text;

    final body = {"title": title, "description": desc, "is_completed": false};

    final url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 201) {
      titleController.text = "";
      descController.text = "";
      showSuccessMessage("Task added successfully");
    } else {
      showErrorMessage("Failed to add task");
    }
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print("You cant call updated without todo data");
      return;
    }
    final id = todo["_id"];
    final isCompleted = todo["is_completed"];
    final title = titleController.text;
    final desc = descController.text;

    final body = {
      "title": title,
      "description": desc,
      "is_completed": isCompleted
    };

    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      showSuccessMessage("Task updated successfully");
    } else {
      showErrorMessage("Failed to update task");
    }
  }

  void showSuccessMessage(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
