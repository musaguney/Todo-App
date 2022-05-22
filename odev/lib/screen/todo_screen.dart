import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:odev/models/todo.dart';
import 'package:odev/screen/home_screen.dart';
import 'package:odev/services/category_service.dart';
import 'package:odev/services/todo_service.dart';

class TodoScreen extends StatefulWidget {
  
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var todoTitleController = TextEditingController();
  var todoDescriptionContorller = TextEditingController();
  var todoDateController = TextEditingController();

  var _selectedValue;
  final List<DropdownMenuItem<String>> _categories = [];

  final _categoryService = CategoryService();
  final _todoService = TodoService();
  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.readCategories();
    print(categories);
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category["name"] ?? ""),
          value: category["name"],
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: todoTitleController,
              decoration: const InputDecoration(
                  labelText: 'Title', hintText: 'Write Todo Title'),
            ),
            TextField(
              controller: todoDescriptionContorller,
              decoration: const InputDecoration(
                  labelText: 'Description', hintText: 'Write Todo Description'),
            ),
            TextField(
              controller: todoDateController,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2030));

                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);

                  setState(() {
                    todoDateController.text = formattedDate;
                  });
                }
              },
              decoration: const InputDecoration(
                  labelText: 'Date',
                  hintText: 'Pick a Date',
                  prefixIcon: Icon(Icons.calendar_today)),
            ),
            DropdownButtonFormField(
                items: _categories,
                value: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                  const SizedBox(
                    height: 20,
                  );
                }),
            RaisedButton(
              onPressed: () async {
                Todo _newTodo = Todo();
                _newTodo.title = todoTitleController.text;
                _newTodo.description = todoDescriptionContorller.text;
                _newTodo.category = _selectedValue;
                _newTodo.todoDate = todoDateController.text;

                var result = await _todoService.saveTodo(_newTodo);
                print(result);
                if (result > 0) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (Route<dynamic> route) => false);
                }
              },
              color: Colors.blue,
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
