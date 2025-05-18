import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import '../models/player.dart';

final List<WebSocketChannel> clients = [];
final List<Player> players = [];

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    Player? currentPlayer;

    channel.stream.listen((data) {
      final msg = jsonDecode(data.toString()) as Map<String, dynamic>;
      final type = msg['type'];

      if (type == 'join') {
        final player = Player(
          id: msg['id'] as String,
          name: msg['name'] as String,
          character: msg['character'] as String,
          channel: channel,
        );
        players.add(player);
        currentPlayer = player;

        channel.sink.add(jsonEncode({
          'type': 'player_list',
          'players': players.map((p) => p.toJson()).toList(),
        }));

        for (final other in players.where((p) => p != player)) {
          other.channel.sink.add(jsonEncode({
            'type': 'player_joined',
            'player': player.toJson(),
          }));
        }
      }

      if (type == 'move') {
        final p = players.firstWhere((p) => p.id == msg['id'] as String)
          ..x = msg['x'] as double
          ..y = msg['y'] as double;

        for (final other in players.where((o) => o.id != p.id)) {
          other.channel.sink.add(
            jsonEncode({
              'type': 'player_moved',
              'id': p.id,
              'x': p.x,
              'y': p.y,
              'direction': msg['direction'],
            }),
          );
        }
      }
    }, onDone: () {
      if (currentPlayer != null) {
        players.remove(currentPlayer);
        for (final other in players) {
          other.channel.sink.add(
            jsonEncode({
              'type': 'player_left',
              'id': currentPlayer!.id,
            }),
          );
        }
      }
    });
  });

  return handler(context);
}
