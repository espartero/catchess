import 'category_data.dart';
import 'subcategory_data.dart';

/// A group that belongs to a Category [category] and a Subcategory [subcategory].
class Group {
  final String id;
  final String name;
  final Category category;
  final Subcategory subcategory;

  const Group(this.id, this.name, this.category, this.subcategory);
}
