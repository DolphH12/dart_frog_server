import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

final List<WebSocketChannel> clients = [];

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    clients.add(channel);

    print('Cliente conectado');

    channel.stream.listen(
      (message) {
        print('Mensaje recibido: $message');

        for (final client in clients) {
          if (client != channel) {
            client.sink.add('$channel: $message');
          }
        }
      },
      onDone: () {
        print('Cliente desconectado');
      },
      onError: (e) {
        print('Error en el canal');
      },
    );
  });

  return handler(context);
}
