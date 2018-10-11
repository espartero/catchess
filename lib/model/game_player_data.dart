import 'player_data.dart';

class GamePlayer {
  final Player player;
  final int elo;
  final String title;
  final double increment;
  final int order;
  final bool bis;
  final bool white;

  GamePlayer(this.player, this.elo, this.title, this.increment, this.order,
      this.bis, this.white);
}
