import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../home/screen/todoList.dart';

class AddPage extends StatefulWidget {
  final Map? todo;
  const AddPage({super.key, this.todo});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController description = TextEditingController();

  bool isEdit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final descriptions = todo['description'];
      titleController.text = title;
      description.text = descriptions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'ADd Page'),
      ),
      body: ListView(children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(hintText: 'title'),
        ),
        SizedBox(
          height: 28,
        ),
        TextField(
          controller: description,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(hintText: 'description'),
          maxLines: 8,
          minLines: 5,
        ),
        SizedBox(
          height: 28,
        ),
        ElevatedButton(
            onPressed: isEdit ? UpdateData : AddData,
            child: Text(isEdit ? 'Edit' : 'submit'))
      ]),
    );
  }


  ///edit data to api
  Future<void> UpdateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('you cannot call update without todo data');
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;
    final descrptin = description.text;
// insert data into model or cal like map api map
    final body = {
      "title": title,
      "description": descrptin,
      "is_completed": false
    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      titleController.text = '';
      description.text = '';
      print('success');
      shoSuccessMessage('updation success', context);
    } else {
      shoSuccessMessage('updation faild', context);
      print('creation faild');
      print(response.body);
    }
  }

  /// add data to api post the url
  Future<void> AddData() async {
    //declare controler into varible
    final title = titleController.text;
    final descrptin = description.text;
     // insert data into model or cal like map api map
    final body = {
      "title": title,
      "description": descrptin,
      "is_completed": false
    };
//call the post api link into variable
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      titleController.text = '';
      description.text = '';
      print('success');
      shoSuccessMessage('success', context);
    } else {
      shoSuccessMessage('faild', context);
      print('creation faild');
      print(response.body);
    }
  }
}
