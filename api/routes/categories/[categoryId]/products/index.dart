import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:product_repo/product_repo.dart';

FutureOr<Response> onRequest(
  RequestContext context,
  String categoryId,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, categoryId);
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, String categoryID) async {
  final productRepo = context.read<ProductRepo>();
  final products = await productRepo.getProductsByCategoryID(categoryID);
  return Response.json(body: products);
}
