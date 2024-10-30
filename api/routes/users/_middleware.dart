import 'package:cart_repo/cart_repo.dart';
import 'package:dart_frog/dart_frog.dart';

final _cartRepo = CartRepo();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<CartRepo>((_) => _cartRepo));
}
