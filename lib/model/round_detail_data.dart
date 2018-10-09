import 'round_data.dart';
import 'group_matches_data.dart';
import 'season_data.dart';

class RoundDetail {
  final Season season;
  final Round round;
  final List<GroupMatches> groupMatches;

  const RoundDetail(this.season, this.round, this.groupMatches);
}
