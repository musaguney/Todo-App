import 'package:flutter/material.dart';
import 'package:odev/helpers/drawer_navigation.dart';
import 'package:odev/models/todo.dart';
import 'package:odev/screen/todo_screen.dart';
import 'package:odev/services/todo_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        _todoList.add(_todoModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        // backgroundColor: Colors.red,
      ),
      drawer: const DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TodoScreen()));
        },
        child: const Icon(Icons.add),
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
