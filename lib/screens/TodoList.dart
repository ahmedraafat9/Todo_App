import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_page.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isLoading=true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "TodoApp",
        ),
      ),
      body: Visibility(
        visible: isLoading,
         child: Center(child: CircularProgressIndicator(),),
         replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                "No Todo Item",
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final item=items[index] as Map;
                  final id=item['_id'] as String;
                  return Card(
                    child: ListTile(

                      leading: CircleAvatar(child: Text("${index+1}")),
                      title: Text(
                        item['title'],

                      ),
                      subtitle: Text(
                        item['description'],
                      ),
                      trailing: PopupMenuButton(
                      onSelected: (value) {
                        if(value=='edit')
                          {
                            // Go to edit page
                          }else if(value=="delete")
                            {
                              //Go to delete page
                              DeleteByID(id);
                            }
                      },
                      itemBuilder: (context)
                      {
                        return [
                          PopupMenuItem(
                            child: Text(
                              "Delete",
                            ),
                            value: 'delete',

                          ),
                        ];
                      }),
                    ),
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            navigateAddPage();
          },
          label: Text(
            "Add Todo",
          )),
    );
  }

  Future <void> DeleteByID(String id)
  async {

    final url="https://api.nstack.in/v1/todos/$id";
    final URl=Uri.parse(url);
    final respoonse=await http.delete(URl);
    if(respoonse.statusCode==200)
      {
        final filtered=items.where((element) => element['_id'] != id ).toList();
        setState(() {
          items=filtered;
        });
      }else
        {
          showfaliureMesaage("Deletion Failure");
        }

  }

  void navigateEditPage() {
    final route = MaterialPageRoute(
      builder: (context) => addPage(),
    );
    Navigator.push(context, route);
  }

 Future<void> navigateAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => addPage(),
    );
   await Navigator.push(context, route);
   setState(() {
     isLoading=true;
   });
   fetchData();
  }

  Future<void> fetchData() async {
    final uri = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final Url = Uri.parse(uri);
    final response = await http.get(Url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading=false;
    });
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
