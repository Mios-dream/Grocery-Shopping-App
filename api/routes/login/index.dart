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
  if (data['email'] == null || data['password_hash'] == null) {
    return Response.json(
      body: {'code': 400, 'message': 'Invalid data'},
    );
  }
  try {
    final rows = UserDB().queryData(
      data['email'] as String,
      data['password_hash'] as String,
    );
    return Response.json(body: {'code': 0, 'message': rows[0]});
  } catch (e) {
    print(e);
    return Response.json(
      body: {'code': 1, 'message': 'Account or password error'},
    );
  }
}
