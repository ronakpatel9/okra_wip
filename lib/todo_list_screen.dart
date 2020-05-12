import 'package:flutter/material.dart';
import 'package:okra/db_helper.dart';
import 'package:okra/new_todo_dialog.dart';
import 'package:okra/todo.dart';
import 'package:okra/todo_list.dart';

enum Settings { DeleteDone }

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    Future<List<Todo>> todosFuture = dbHelper.getTodosList();
    todosFuture.then((todos) {
      setState(() {
        this.todos = todos;
      });
    });
  }

  _toggleTodo(Todo todo, bool isChecked) {
    dbHelper.markDone(todo);
    setState(() {
      todo.isDone = isChecked;
    });
  }

  _addTodo() async {
    final todo = await showDialog<Todo>(
      context: context,
      builder: (BuildContext context) {
        return NewTodoDialog();
      },
    );

    if (todo != null) {
      setState(() {
        todos.add(todo);
        dbHelper.addTodo(todo);
      });
    }
  }

  Widget _popUpMenu() {
    return PopupMenuButton<Settings>(
      icon: Icon(Icons.more_vert),
      onSelected: (Settings result) {
        if (result == Settings.DeleteDone) {
          dbHelper.deleteTodoMarkedAsDone();
          Future<List<Todo>> todosFuture = dbHelper.getTodosList();
          todosFuture.then((todos) {
            setState(() {
              this.todos = todos;
            });
          });
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Settings>>[
        const PopupMenuItem(
          child: Text('Delete Marked As Done'),
          value: Settings.DeleteDone,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bhindi'),
        actions: <Widget>[
          _popUpMenu(),
        ],
      ),
      body: TodoList(
        todos: todos,
        onTodoToggle: _toggleTodo,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addTodo,
      ),
    );
  }
}
