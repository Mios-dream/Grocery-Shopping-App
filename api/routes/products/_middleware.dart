import 'package:dart_frog/dart_frog.dart';
import 'package:product_repo/product_repo.dart';

final _productRepo = ProductRepo();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<ProductRepo>((_) => _productRepo));
}
