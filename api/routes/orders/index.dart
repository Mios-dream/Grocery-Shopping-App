import 'dart:async';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';
import 'package:models/models.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final sampleData=<Order>[Order(
    id: const Uuid().v4(),
    userId: const Uuid().v4(),
    products: Product.sampleData,
    totalAmount: 25.0,
    orderDate: DateTime.now(),
    status: 'processing',
    deliveryAddress: Address.sampleData[0],
  ),
    Order(
      id: const Uuid().v4(),
      userId: const Uuid().v4(),
      products: Product.sampleData,
      totalAmount: 70.0,
      orderDate: DateTime.now(),
      status: 'shipped',
      deliveryAddress: Address.sampleData[0],
    ),];
  return Response.json(body: sampleData);
}
