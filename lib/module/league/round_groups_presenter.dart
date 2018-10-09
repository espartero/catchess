import 'dart:async';
import '../../model/round_groups_data.dart';
import '../../repository/group_repository.dart';
import '../../injection/dependency_injection.dart';

/// Contract for the round groups view.
abstract class RoundGroupsViewContract {
  /// Loads the data into the UI after retrieving it from the data source.
  onLoadDataComplete(RoundGroups roundGroups);

  /// Informs the UI that an error has occured when retrieving data from the data source.
  onLoadDataError();
}

/// Presenter for the round groups view.
class RoundGroupsPresenter {
  RoundGroupsViewContract _view;
  GroupRepository _repository;

  RoundGroupsPresenter(this._view) {
    this._repository = Injector().groupRepository;
  }

  Future loadLastRound() {
    return _repository
        .findRoundGroups(null, null) // TODO use the last season and round
        .then((roundGroups) => _view.onLoadDataComplete(roundGroups))
        .catchError((onError) => _view.onLoadDataError());
  }
}
