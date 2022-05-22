import 'package:flutter/material.dart';
import 'package:odev/screen/categories_screen.dart';
import 'package:odev/screen/home_screen.dart';
import 'package:odev/screen/todo_category_screen.dart';
import 'package:odev/services/category_service.dart';

import '../models/category.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  final _categoryService = CategoryService();
  final List<Category> _categoryList = [];

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://i.pinimg.com/564x/0e/35/8d/0e358d98578648662715198235ce64ee.jpg'),
            ),
            accountName: Text('berkant123'),
            accountEmail: Text('berkantyurt@gmail.com'),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.view_list),
            title: const Text('Categories'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CategoriesScreen())),
          ),
          ListView.builder(
              itemCount: _categoryList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TodoCategoryScreen(
                            title: _categoryList[index].name,
                            category: _categoryList[index].name,
                          ))),
                  title: Text(_categoryList[index].name ?? ""),
                );
              })
        ],
      ),
    );
  }
}
