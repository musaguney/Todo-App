import 'package:flutter/material.dart';
import 'package:odev/screen/home_screen.dart';
import 'package:odev/models/category.dart';
import 'package:odev/services/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var category;
  final _categoryNameController = TextEditingController();
  final _categoryDescriptionController = TextEditingController();

  final _editCategoryNameController = TextEditingController();
  final _editCategoryDescriptionController = TextEditingController();

  final _category = Category();
  final _categoryService = CategoryService();

  final List<Category> _categoryList = List<Category>.empty(growable: true);
  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No name';
      _editCategoryDescriptionController.text =
          category[0]['description'] ?? 'No description';
    });
    _editFormDialog(context);
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
              actions: <Widget>[
                FlatButton(
                  color: Colors.green,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FlatButton(
                    color: Colors.red,
                    onPressed: () async {
                      _category.id = _categoryList.isEmpty
                          ? 1
                          : _categoryList.last.id! + 1;
                      _category.name = _categoryNameController.text;
                      _category.description =
                          _categoryDescriptionController.text;

                      var result =
                          await _categoryService.saveCategory(_category);
                      // print(result);
                      if (result > 0) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const CategoriesScreen()),
                            (Route<dynamic> route) => false);
                      }
                    },
                    child: const Text('Save'))
              ],
              title: const Text('Categories Form'),
              content: SingleChildScrollView(
                  child: Column(children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                      hintText: 'Write a category', labelText: 'Category'),
                  controller: _categoryNameController,
                ),
                TextField(
                  decoration: const InputDecoration(
                      hintText: 'Write a description',
                      labelText: 'Description'),
                  controller: _categoryDescriptionController,
                ),
              ])));
        });
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    _category.id = category[0]['id'];
                    _category.name = _editCategoryNameController.text;
                    _category.description =
                        _editCategoryDescriptionController.text;
                    var result =
                        await _categoryService.updateCategory(_category);
                    // print(result);
                    if (result > 0) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const CategoriesScreen()),
                          (Route<dynamic> route) => false);
                    }
                  },
                  child: const Text('Update'))
            ],
            title: const Text('Categories Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(
                        hintText: 'Write a category', labelText: 'Category'),
                    controller: _editCategoryNameController,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        hintText: 'Write a description',
                        labelText: 'Description'),
                    controller: _editCategoryDescriptionController,
                  )
                ],
              ),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, int index) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FlatButton(
                  color: Colors.red,
                  onPressed: () async {
                    var result = await _categoryService
                        .deleteCategory(_categoryList[index].id);
                    // print(result);
                    if (result > 0) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const CategoriesScreen()),
                          (Route<dynamic> route) => false);
                    }
                  },
                  child: const Text('Delete'))
            ],
            title: const Text('Are you sure you want to delete this.'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: RaisedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            ),
            elevation: 0.0,
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            color: Colors.blue,
          ),
          title: const Text('Categories'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showFormDialog(context);
          },
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: _categoryList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: Card(
                  elevation: 8.0,
                  child: ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editCategory(context, _categoryList[index].id);
                      },
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_categoryList[index].name.toString()),
                        IconButton(
                            onPressed: () {
                              _deleteFormDialog(context, index);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
