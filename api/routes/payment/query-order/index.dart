import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:model/db.dart';

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

  try {
    if (data['order_id'] != null) {
      final orderData =
      OrderDatabase().queryDataByOrderId(orderId: data['order_id'] as String);
      return Response.json(
        body: {'code': 0, 'message': orderData},
      );
    }else if( data['user_id'] != null){
      final orderData =
      OrderDatabase().queryDataByUserId(userId: data['user_id'] as String);
      return Response.json(
        body: {'code': 0, 'message': orderData},
      );
    }else{
      return Response.json(
        body: {'code': 400, 'message': 'Invalid data'},
      );
    }
  } catch (e) {
    return Response.json(body: {'code': 1, 'message': 'error'});
  }
}
