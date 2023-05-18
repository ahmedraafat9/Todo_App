import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class addPage extends StatefulWidget {
  const addPage({Key? key}) : super(key: key);

  @override
  State<addPage> createState() => _addPageState();
}

class _addPageState extends State<addPage> {
  TextEditingController task = TextEditingController();
  TextEditingController Description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "AddPage",
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: task,
            decoration: InputDecoration(
              hintText: "Task",
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            controller: Description,
            minLines: 5,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: "Description",
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: voidSubmitData,
              child: Text(
                "Submit",
              ))
        ],
      ),
    );
  }

  Future<void> voidSubmitData() async {
    final taskController = task.text;
    final descriptionController = Description.text;
    final body = {
      //the body is sent to the server to store data
      "title": taskController,
      "description": descriptionController,
      "is_completed": false,
    };
    final URL = "https://api.nstack.in/v1/todos";
    final url = Uri.parse(URL);
    final respone = await http.post(
      url,
      body: jsonEncode(
        body,
      ),
      headers: {"Content-Type": "application/json"},
    );
    if (respone.statusCode == 201) {
      task.text="";
      Description.text="";
      showSuccessMesaage("Creation Successes");
    } else {
      showfaliureMesaage("Creation Failed");
    }
  }

  void showSuccessMesaage(String Message) {
    final snack = SnackBar(content: Text(Message));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  void showfaliureMesaage(String Message) {
    final snack = SnackBar(
      content: Text(
        Message,
        style: TextStyle(
          color: Colors.white,
          backgroundColor: Colors.red,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
