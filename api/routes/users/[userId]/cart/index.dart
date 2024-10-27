import 'dart:async';
import 'dart:io';
import 'package:cart_repository/cart_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

FutureOr<Response> onRequest(RequestContext context, String userId) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, userId);
    case HttpMethod.post:
      return _post(context, userId);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, String userId) async {
  final cartRepository = context.read<CartRepository>();
  final cartItems = await cartRepository.getCartItems(userId);
  return Response.json(body: cartItems);
}

Future<Response> _post(RequestContext context, String userId) async {
  final body = await context.request.json() as Map<String, dynamic>;

  try {
    final product = Product.fromJson(body);
    final cartRepository = context.read<CartRepository>();
    final cartItem = await cartRepository.addToCart(userId, product);
    return Response.json(body: cartItem.toJson());
  } catch (err) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'Invalid cart item',
    );
  }
}
