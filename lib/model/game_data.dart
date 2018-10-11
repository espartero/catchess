import 'game_player_data.dart';

class Game {
  final GamePlayer player1;
  final GamePlayer player2;
  final double points1;
  final double points2;
  final int position;

  Game(this.player1, this.player2, this.points1, this.points2, this.position);

  bool isPlayer1Winner() {
    return points1 > points2;
  }

  bool isPlayer2Winner() {
    return points2 > points1;
  }
}
