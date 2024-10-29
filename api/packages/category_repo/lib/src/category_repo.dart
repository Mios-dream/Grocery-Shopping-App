import 'package:model/model.dart';

class CategoryRepo {
  Future<Category> getCategoryById(String categoryId) async {
    return Category.sampleData
        .firstWhere((category) => category.id == categoryId);
  }

  Future<List<Category>> getCategories() async {
    return Category.sampleData;
  }
}
