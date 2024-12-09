import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:db/db.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _get(context);
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final response = await context.request.body();
  if (response.isEmpty) {
    return Response.json(
      body: {'code': 400, 'message': 'Invalid data'},
    );
  }
  final data = jsonDecode(response) as Map<String, dynamic>;
  if (data['user_id'] == null || data['items'] == null) {
    return Response.json(
      body: {'code': 400, 'message': 'Invalid data'},
    );
  }
  try {
    final orderId = OrderDatabase().createOrder(
      userId: data['user_id'] as String,
      amount: data['amount'] as double,
      items: jsonEncode(data['items']),
    );
    return Response.json(
      body: {'code': 0, 'message': 'success', 'order_id': orderId},
    );
  } catch (e) {
    print(e);
    return Response.json(body: {'code': 1, 'message': 'error'});
  }
}
