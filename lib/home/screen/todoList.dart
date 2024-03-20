import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../addPage/screen/addPage.dart';
import 'package:http/http.dart' as http;


///show snackbar
void shoSuccessMessage(String message,BuildContext context){
  final snackBar=SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}


class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  List items = [];
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ToDoList'),
        ),
        body: Visibility(
          visible: items.isNotEmpty,replacement: Center(child: Text('No Data'),),
          child: RefreshIndicator(
            onRefresh: fetchTodo,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id=item["_id"]as String;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if(value=='edit'){
                          navigateEditPage(item);
                        }else if(value=='delete'){
                          deleteById(id);
                        }
                      },
                      itemBuilder: (context) {
                  
                      return[
                        PopupMenuItem(child: Text('edit'),value: 'edit',),
                        PopupMenuItem(child: Text('delete'),value: 'delete',),
                      ];
                    },),
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: navigateToDoPage,
          child: Center(child: Icon(CupertinoIcons.add)),
        ));
  }

 Future <void> navigateEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddPage(todo:item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading=true;
    });
    fetchTodo();
  }

 Future <void> navigateToDoPage() async{
    final route = MaterialPageRoute(
      builder: (context) => AddPage(),
    );
   await Navigator.push(context, route);
   setState(() {
     isLoading=true;
   });
   fetchTodo();
  }

  Future<void>deleteById(String id)async{
    final url='https://api.nstack.in/v1/todos/$id';
    final uri=Uri.parse(url);
    final response=await http.delete(uri);
    if(response.statusCode==200){
final filterd=items.where((element) => element('_id')!=id).toList();
setState(() {
  items=filterd;
});
shoSuccessMessage('deleted', context);
    }else{
      shoSuccessMessage('deleteion faild',context);
    }
  }

  Future<void> fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body as String);
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = true;
    });
    print(response.statusCode);
    print(response.body);
  }
}
