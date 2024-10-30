import 'dart:async';
import 'dart:io';
import 'package:cart_repo/cart_repo.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(
  RequestContext context,
  String userID,
  String itemID,
) async {
  switch (context.request.method) {
    case HttpMethod.delete:
      return _delete(context, userID, itemID);
    case HttpMethod.post:
    case HttpMethod.get:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _delete(
  RequestContext context,
  String userID,
  String itemID,
) async {
  final cartRepo = context.read<CartRepo>();
  await cartRepo.removeFromCart(userID, itemID);
  return Response.json(body: 'The item has been removed from the cart.');
}
