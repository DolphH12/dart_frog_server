import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

class Player {
  Player({
    required this.id,
    required this.name,
    required this.character,
    required this.channel,
    this.x = 0.0,
    this.y = 0.0,
  });

  final String id;
  final String name;
  final String character;
  final WebSocketChannel channel;
  double x;
  double y;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'character': character,
        'x': x,
        'y': y,
      };
}
