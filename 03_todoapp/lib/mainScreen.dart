import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/addTodo.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {

  List<String> todoList = [];

  void addTodo({required String todoText}) {
    setState(() {
      todoList.add(todoText);
    });
    updateLocalData();
    Navigator.pop(context);
  }


  void updateLocalData() async{

    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoList', todoList);
  }

  void loadData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    todoList = (prefs.getStringList("todoList") ?? []).toList();
    setState(() {});
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: Text('Drawer Data')),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Todo App'),
        actions: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      height: 200,
                      child: Addtodo(addTodo: addTodo),
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (BuildContext, int index) {
          return ListTile(
            onTap: () {
              showModalBottomSheet(
                context: context, 
                builder: (context) {
               return Container(
                padding: EdgeInsets.all(20),
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          todoList.removeAt(index);
                        });
                        updateLocalData();
                        Navigator.pop(context);
                      },
                      child: Text("Mark as done"),
                    ),
                  ],
                ),
              );
              });
            },
            title:  Text(todoList[index]),
          );
        },
      ),
    );
  }
}
