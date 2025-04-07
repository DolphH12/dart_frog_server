import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

final List<String> messages = [];

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final body = await context.request.body();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final message = data['message'] as String?;
    if (message != null) {
      messages.add(message);
      return Response.json(
        body: {'status': 'Message received!'},
      );
    }
    return Response.json(
      statusCode: 400,
      body: {
        'error': 'Missing message',
      },
    );
  }
  if (context.request.method == HttpMethod.get) {
    return Response.json(body: {'messages': messages});
  }
  return Response(statusCode: 405);
}
