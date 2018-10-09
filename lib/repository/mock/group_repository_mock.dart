import 'dart:async';
import '../group_repository.dart';
import '../../model/round_groups_data.dart';
import '../../model/season_data.dart';
import '../../model/round_data.dart';
import '../../model/category_data.dart';
import '../../model/subcategory_data.dart';
import '../../model/group_data.dart';
import '../../model/round_detail_data.dart';
import '../../model/group_matches_data.dart';
import '../../model/match_data.dart';

/// A mock for the [GroupRepository].
class GroupRepositoryMock implements GroupRepository {
  static const _responseDelayMillis = 50;
  static const _errorFrequency = 50;

  RoundGroups _roundGroups;
  int _counter = 0;

  GroupRepositoryMock() {
    _build();
  }

  @override
  Future<RoundGroups> findRoundGroups(Season season, Round round) {
    _counter++;

    if (_errorFrequency > 0 && _counter % _errorFrequency == 0) {
      return Future.error("Mocked error");
    } else {
      return Future.delayed(const Duration(milliseconds: _responseDelayMillis),
          () => _roundGroups);
    }
  }

  @override
  Future<RoundDetail> findRoundDetail(Season season, Round round,
      {Group group}) {
    _counter++;

    if (_errorFrequency > 0 && _counter % _errorFrequency == 0) {
      return Future.error("Mocked error");
    } else if (group == null) {
      return Future.delayed(const Duration(milliseconds: _responseDelayMillis),
          () => _buildForAllGroups(season, round));
    } else {
      return Future.delayed(const Duration(milliseconds: _responseDelayMillis),
          () => _buildForGroup(season, round, group));
    }
  }

  _build() {
    Season season = Season("2018");
    Round round = Round("Ronda 1", DateTime(2018, 2, 1));

    Subcategory subcategory1 = Subcategory("Divisió Honor");
    Subcategory subcategory2 = Subcategory("Primera provincial");
    Subcategory subcategory3 =
        Subcategory("Segona provincial con el texto muy muy muy muy pero que muy largo");

    Category category1 = Category("Nacional");
    Category category2 = Category("Barcelona");

    _roundGroups = RoundGroups(
      season,
      round,
      List.from(
        [
          Group("1", "Grup I", category1, subcategory1),
          Group("2", "Grup II", category1, subcategory1),
          Group("3", "Grup III", category1, subcategory1),
          Group(
              "4",
              "Play-off d'ascens a primera divisió 1era elim. Play-off d'ascens a primera divisió 1era elim.",
              category1,
              subcategory1),
          Group("5", "Grup I", category2, subcategory2),
          Group("6", "Grup II", category2, subcategory2),
          Group("7", "Play-off d'ascens a primera divisió 1era elim.",
              category2, subcategory3),
          Group("8", "Grup II", category2, subcategory3),
          Group("9", "Grup III", category2, subcategory3),
        ],
      ),
    );
  }

  RoundDetail _buildForGroup(Season season, Round round, Group group) {
    Match match1 = Match("Ateneu Colon B", "Sant Marti C", 5.5, 4.5);
    Match match2 = Match("Cerdanyola Mataro B", "Llavaneres", 6.0, 4.0);
    Match match3 = Match(
        "Equipo con un nombre anormalmente largo porque puede ser un SUB-12",
        "Equipo 6",
        10.0,
        0.0);
    Match match4 = Match("Equipo 7", "Equipo 8", 5.0, 5.0);
    Match match5 = Match("Equipo 9", "Equipo 10", 0.5, 9.5);
    GroupMatches groupMatches = GroupMatches(
      group,
      List.from([
        match1,
        match2,
        match3,
        match4,
        match5,
      ]),
    );

    return RoundDetail(season, round, [groupMatches]);
  }

  RoundDetail _buildForAllGroups(Season season, Round round) {
    Match match1 = Match("Ateneu Colon B", "Sant Marti C", 5.5, 4.5);
    Match match2 = Match("Cerdanyola Mataro B", "Llavaneres", 6.0, 4.0);
    Match match3 = Match(
        "Equipo con un nombre anormalmente largo porque puede ser un SUB-12",
        "Equipo 6",
        10.0,
        0.0);
    Match match4 = Match("Equipo 7", "Equipo 8", 5.0, 5.0);
    Match match5 = Match("Equipo 9", "Equipo 10", 0.5, 9.5);

    List<GroupMatches> groupMatchesList = [];
    _roundGroups.groups.forEach((group) => groupMatchesList.add(GroupMatches(
          group,
          List.from([
            match1,
            match2,
            match3,
            match4,
            match5,
          ]),
        )));

    return RoundDetail(season, round, groupMatchesList);
  }
}
