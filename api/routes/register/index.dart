import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:model/utils.dart';

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
      body: {'message': 'Invalid data'},
    );
  }
  final data = jsonDecode(response) as Map<String, dynamic>;
  if (data['username'] == null ||
      data['email'] == null ||
      data['password_hash'] == null) {
    return Response.json(
      body: {'message': 'Invalid data'},
    );
  }
  try {
    DatabaseHelper().insertData(
      data['username'] as String ,
      data['email'] as String ,
      data['password_hash'] as String ,
      phoneNumber: data['phone_number'] as String?,
    );
    return Response.json(body: {'message': 'ok'});
  } catch (e) {
    print(e);
    return Response.json(body: {'message': 'User already exists'});
  }
}