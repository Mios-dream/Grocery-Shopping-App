import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:product_repo/product_repo.dart';

FutureOr<Response> onRequest(RequestContext context, String productID) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, productID);
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, String productID) async {
  final productRepo = context.read<ProductRepo>();
  final products = await productRepo.getProductByID(productID);
  return Response.json(body: products);
}
