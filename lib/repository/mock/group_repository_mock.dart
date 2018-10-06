import 'dart:async';
import '../group_repository.dart';
import '../../model/round_groups_data.dart';
import '../../model/season_data.dart';
import '../../model/round_data.dart';
import '../../model/category_data.dart';
import '../../model/subcategory_data.dart';
import '../../model/group_data.dart';

/// A mock for the [GroupRepository].
class GroupRepositoryMock implements GroupRepository {
  static const _responseDelayMillis = 100;
  static const _errorFrequency = 5;

  RoundGroups _roundGroups;
  int _counter = 0;

  GroupRepositoryMock() {
    _build();
  }

  Future<RoundGroups> find(Season season, Round round) {
    _counter++;

    if (_errorFrequency > 0 && _counter % _errorFrequency == 0) {
      return Future.error("Mocked error");
    } else {
      return Future.delayed(const Duration(milliseconds: _responseDelayMillis), () => _roundGroups);
    }
  }

  _build() {
    Season season = Season("2018");
    Round round = Round("1", DateTime(2018, 2, 1));

    Subcategory subcategory1 = Subcategory("Divisió Honor");
    Subcategory subcategory2 = Subcategory("Primera provincial");
    Subcategory subcategory3 = Subcategory("Segona provincial con el texto muy largo");

    Category category1 = Category("Nacional");
    Category category2 = Category("Barcelona");

    _roundGroups = RoundGroups(
      season,
      round,
      List.from(
        [
          Group("1", "Grup I", category1, subcategory1, 5, 1),
          Group("2", "Grup II", category1, subcategory1, 5, 5),
          Group("3", "Grup III", category1, subcategory1, 5, 2),
          Group("4", "Grup IV", category1, subcategory1, 5, 5),
          Group("5", "Grup I", category2, subcategory2, 5, 0),
          Group("6", "Grup II", category2, subcategory2, 5, 5),
          Group("7", "Play-off d'ascens a primera divisió 1era elim.", category2, subcategory3, 5, 1),
          Group("8", "Grup II", category2, subcategory3, 5, 3),
          Group("9", "Grup III", category2, subcategory3, 5, 2),
        ],
      ),
    );
  }
}
