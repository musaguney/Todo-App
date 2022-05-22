class Category {
  String? name;
  String? description;
  int? id;

  categoryMapp() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;
    return mapping;
  }

  @override
  String toString() {
    return 'Category(name: $name, description: $description, id: $id)';
  }
}
