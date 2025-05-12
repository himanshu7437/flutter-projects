import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/addTodo.dart';
import 'package:todoapp/widgets/todoLIst.dart';
import 'package:url_launcher/url_launcher.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  List<String> todoList = [];

  void addTodo({required String todoText}) {
    if (todoList.contains(todoText)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Already Exists"),
            content: Text("this todo data already exists"),
            actions: [InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text("close"))],
          );
        },
      );
      return;
    }

    setState(() {
      todoList.add(todoText);
    });
    updateLocalData();
    Navigator.pop(context);
  }

  void updateLocalData() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoList', todoList);
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    todoList = (prefs.getStringList("todoList") ?? []).toList();
    setState(() {});
  }

  void showAddTodoBottomSheet() {
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
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.blueGrey[900],
        onPressed: showAddTodoBottomSheet,
        child: Icon(Icons.add, color: Colors.white,),
        ),
      drawer: Drawer(child: Column(
        children: [
          Container(
            color: Colors.blueGrey[900],
            height: 200,
            width: double.infinity,
            child: Center(child: Text("Todo App", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
          ),
          ListTile(
            onTap: () {
              launchUrl(Uri.parse("https://github.com/himanshu7437"));
            },
            leading: Icon(
              Icons.person
            ),
            title: Text("About Me", style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          ListTile(
            onTap: () {
              launchUrl(Uri.parse("mailto:himanshujangra@gmail.com"));
            },
            leading: Icon(
              Icons.phone
            ),
            title: Text("Contact Me", style: TextStyle(fontWeight: FontWeight.bold),),
          )
        ],
      )),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Todo App'),
      ),
      body: TodoListBuilder(todoList: todoList, updateLocalData: updateLocalData,),
    );
  }
}
