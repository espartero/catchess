import 'round_data.dart';
import 'group_data.dart';
import 'season_data.dart';

/// List of [groups] with at least one match for a [season] and a [round].
class RoundGroups {
  final Season season;
  final Round round;
  final List<Group> groups;

  const RoundGroups(this.season, this.round, this.groups);
}
