class Todo {
  int? id;
  String? title;
  String? description;
  String? category;
  String? todoDate;

  categoryMapp() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['title'] = title;
    mapping['description'] = description;
    mapping['category'] = category;
    mapping['todoDate'] = todoDate;
    return mapping;
  }

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, description: $description,category:$category,todoDate:$todoDate)';
  }
}
