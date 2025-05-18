import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import '../routes/ws(Anterior).dart' as ws_handler;

void main() async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  const handler = ws_handler.onRequest;
  await serve(handler, ip, port);
}
