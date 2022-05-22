import 'package:flutter/material.dart';
import 'package:odev/models/todo.dart';
import 'package:odev/services/todo_service.dart';

class TodoCategoryScreen extends StatefulWidget {
  final String? title;
  final String? category;
  const TodoCategoryScreen({Key? key, this.title, this.category})
      : super(key: key);

  @override
  _TodoCategoryScreenState createState() => _TodoCategoryScreenState();
}

class _TodoCategoryScreenState extends State<TodoCategoryScreen> {
  final _todoService = TodoService();
  final List<Todo> _todoList = [];

  @override
  void initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    var todos = await _todoService.readTodo();
    todos.forEach((todos) {
      setState(() {
        var _todoModel = Todo();
        _todoModel.id = todos['id'];
        _todoModel.title = todos['title'];
        _todoModel.description = todos['description'];
        _todoModel.category = todos['category'];
        _todoModel.todoDate = todos['todoDate'];

        if (_todoModel.category == widget.category) {
          _todoList.add(_todoModel);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Todo List'),
      ),
      body: ListView.builder(
          itemCount: _todoList.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              child: ListTile(
                title: Text(_todoList[index].title ?? ""),
                subtitle: Text(_todoList[index].category ?? ""),
                trailing: Text(_todoList[index].todoDate ?? ""),
              ),
            );
          }),
    );
  }
}
