import 'package:category_repo/category_repo.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:product_repo/product_repo.dart';

final _categoryRepo = CategoryRepo();
final _productRepo = ProductRepo();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<CategoryRepo>((_) => _categoryRepo))
      .use(provider<ProductRepo>((_) => _productRepo));
}
