import 'dart:async';
import '../model/round_groups_data.dart';
import '../model/season_data.dart';
import '../model/round_data.dart';
import '../model/round_detail_data.dart';
import '../model/group_data.dart';

/// Contract for the group related repository actions.
abstract class GroupRepository {
  /// Finds the groups that played any match for a given season [season] and a round [round].
  Future<RoundGroups> findRoundGroups(Season season, Round round);

  Future<RoundDetail> findRoundDetail(Season season, Round round,
      {Group group});
}
