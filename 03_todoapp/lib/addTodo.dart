import 'package:flutter/material.dart';

class Addtodo extends StatefulWidget {

  void Function({required String todoText}) addTodo;

  Addtodo({super.key, required this.addTodo});

  @override
  State<Addtodo> createState() => _AddtodoState();
}

class _AddtodoState extends State<Addtodo> {

  TextEditingController todoText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Add Todo'),
        TextField(
          onSubmitted: (value) {
            if(todoText.text.isNotEmpty) {
            widget.addTodo(todoText: todoText.text); 
            }
            todoText.text = '';
          },
          autofocus: true,
          controller: todoText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(5),
            hintText: 'write your todo here...',
          ),
        ),

        ElevatedButton(
          onPressed: () {
          if(todoText.text.isNotEmpty) {
            widget.addTodo(todoText: todoText.text); 
          }
          todoText.text = '';
        }, child: Text('Add Task'))
      ],
    );
  }
}