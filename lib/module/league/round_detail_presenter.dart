import 'dart:async';
import '../../model/round_detail_data.dart';
import '../../model/season_data.dart';
import '../../model/round_data.dart';
import '../../model/group_data.dart';
import '../../repository/group_repository.dart';
import '../../injection/dependency_injection.dart';

/// Contract for the round detail view.
abstract class RoundDetailViewContract {
  /// Loads the data into the UI after retrieving it from the data source.
  onLoadDataComplete(RoundDetail roundDetail);

  /// Informs the UI that an error has occured when retrieving data from the data source.
  onLoadDataError();
}

/// Presenter for the round detail view.
class RoundDetailPresenter {
  RoundDetailViewContract _view;
  GroupRepository _repository;

  RoundDetailPresenter(this._view) {
    this._repository = Injector().groupRepository;
  }

  Future load(Season season, Round round, {Group group}) {
    return _repository
        .findRoundDetail(season, round, group: group)
        .then((roundDetail) => _view.onLoadDataComplete(roundDetail))
        .catchError((onError) => _view.onLoadDataError());
  }
}
