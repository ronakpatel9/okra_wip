import 'package:flutter/material.dart';
import 'package:todo_list/todo.dart';

class NewTodoDialog extends StatelessWidget {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add item'),
      content: TextField(
        controller: controller,
        autofocus: true,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Add'),
          onPressed: () {
            final todo = Todo(controller.text, false);
            controller.clear();
            Navigator.of(context).pop(todo);
          },
        )
      ],
    );
  }
}
