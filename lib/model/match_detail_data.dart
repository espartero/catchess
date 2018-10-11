import 'match_data.dart';
import 'game_data.dart';

class MatchDetail {
  final MatchData match;
  final List<Game> games;

  MatchDetail(this.match, this.games);
}
