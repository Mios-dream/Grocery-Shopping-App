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
  final req = await context.request.body();
  if (req.isEmpty) {
    return Response.json(
      body: {'code': 400, 'message': 'Invalid data'},
    );
  }
  final data = jsonDecode(req) as Map<String, dynamic>;
  if (data['email'] == null ||
      data['username'] == null ||
      data['password_hash'] == null) {
    return Response.json(
      body: {'code': 400, 'message': 'Invalid data'},
    );
  }
  try {
    UserDB().insertData(
      data['email'] as String,
      data['username'] as String,
      data['password_hash'] as String,
      phoneNumber: data['phone_number'] as String?,
    );
    return Response.json(body: {'code': 0, 'message': 'ok'});
  } catch (e) {
    print(e);
    return Response.json(body: {'code': 1, 'message': 'Register failed'});
  }
}
