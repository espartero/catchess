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
import '../../model/match_detail_data.dart';
import '../../model/game_data.dart';
import '../../model/game_player_data.dart';
import '../../model/player_data.dart';

/// A mock for the [GroupRepository].
class GroupRepositoryMock implements GroupRepository {
  static const _responseDelayMillis = 50;
  static const _errorFrequency = 50;

  RoundGroups _roundGroups;
  List<Game> _games;
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

  @override
  Future<MatchDetail> findMatchDetail(MatchData match) {
    _counter++;

    if (_errorFrequency > 0 && _counter % _errorFrequency == 0) {
      return Future.error("Mocked error");
    } else {
      return Future.delayed(const Duration(milliseconds: _responseDelayMillis),
          () => _buildMatchDetail(match));
    }
  }

  _build() {
    Season season = Season("2018");
    Round round = Round("Ronda 1", DateTime(2018, 2, 1));

    Subcategory subcategory1 = Subcategory("Divisió Honor");
    Subcategory subcategory2 = Subcategory("Primera provincial");
    Subcategory subcategory3 = Subcategory(
        "Segona provincial con el texto muy muy muy muy pero que muy largo");

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

    _games = <Game>[
      Game(
          GamePlayer(Player("1", "Jugador 1"), 2100, "", 5.5, 1, false, true),
          GamePlayer(
              Player("11", "Jugador 1"), 2150, "", -5.5, 1, false, false),
          1.0,
          0.0,
          1),
      Game(
          GamePlayer(
              Player("2", "Jugador 2"), 2070, "", -5.36, 2, false, false),
          GamePlayer(
              Player("12", "Jugador 2"), 2120, "MC", 3.13, 2, false, true),
          0.0,
          1.0,
          2),
      Game(
          GamePlayer(Player("3", "Jugador con nombre bastante bastante largo pero que muy largo"), 1935, "", 15.25, 2, false, true),
          GamePlayer(Player("13", "LLAURADO PLADELLORENS, CATERINA"), 2111, "", 0.0, 2, false, false),
          1.0,
          0.0,
          3),
      Game(
          GamePlayer(Player("3", "Jugador 3"), 1935, "", 0.0, 2, false, true),
          GamePlayer(Player("13", "Jugador 3"), 2111, "", 0.0, 2, false, false),
          0.5,
          0.5,
          4),
      Game(
          GamePlayer(Player("3", "Jugador con nombre bastante bastante largo pero que muy largo"), 1935, "", 0.0, 2, false, true),
          GamePlayer(Player("13", "Jugador con nombre bastante bastante largo pero que muy largo"), 2111, "", 0.0, 2, false, false),
          0.5,
          0.5,
          5),
      Game(
          GamePlayer(Player("3", "Jugador 3"), 1935, "(2)", 0.0, 2, false, true),
          GamePlayer(Player("13", "Jugador 3"), 2111, "", 0.0, 2, false, false),
          0.5,
          0.5,
          6),
      Game(
          GamePlayer(Player("3", "Jugador 3"), 1935, "", 0.0, 2, false, true),
          GamePlayer(Player("13", "Jugador 3"), 2111, "", 0.0, 2, false, false),
          0.5,
          0.5,
          7),
      Game(
          GamePlayer(Player("3", "Jugador 3"), 1935, "", 0.0, 2, false, true),
          GamePlayer(Player("13", "Jugador 3"), 2111, "", 0.0, 2, false, false),
          0.5,
          0.5,
          8),
      Game(
          GamePlayer(Player("3", "Jugador 3"), 1935, "", 0.0, 2, false, true),
          GamePlayer(Player("13", "Jugador 3"), 2111, "", 0.0, 2, false, false),
          0.5,
          0.5,
          9),
      Game(
          GamePlayer(Player("3", "Jugador 3"), 1935, "", 0.0, 2, false, true),
          GamePlayer(Player("13", "Jugador 3"), 2111, "", 0.0, 2, false, false),
          0.5,
          0.5,
          10),
    ];
  }

  RoundDetail _buildForGroup(Season season, Round round, Group group) {
    MatchData match1 =
        MatchData("1", "Ateneu Colon B", "Sant Marti C", 5.5, 4.5);
    MatchData match2 =
        MatchData("2", "Cerdanyola Mataro B", "Llavaneres", 6.0, 4.0);
    MatchData match3 = MatchData(
        "3",
        "Equipo con un nombre anormalmente largo porque puede ser un SUB-12",
        "Equipo 6",
        10.0,
        0.0);
    MatchData match4 = MatchData(
        "4",
        "Equipo con un nombre anormalmente largo porque puede ser un SUB-12",
        "Equipo con un nombre anormalmente largo porque puede ser un SUB-12",
        5.0,
        5.0);
    MatchData match5 = MatchData("5", "Equipo 9", "Equipo 10", 0.5, 9.5);
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
    MatchData match1 =
        MatchData("1", "Ateneu Colon B", "Sant Marti C", 5.5, 4.5);
    MatchData match2 =
        MatchData("2", "Cerdanyola Mataro B", "Llavaneres", 6.0, 4.0);
    MatchData match3 = MatchData(
        "3",
        "Equipo con un nombre anormalmente largo porque puede ser un SUB-12",
        "Equipo 6",
        10.0,
        0.0);
    MatchData match4 = MatchData("4", "Equipo 7", "Equipo 8", 5.0, 5.0);
    MatchData match5 = MatchData("5", "Equipo 9", "Equipo 10", 0.5, 9.5);

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

  MatchDetail _buildMatchDetail(MatchData match) {
    return MatchDetail(match, _games);
  }
}
