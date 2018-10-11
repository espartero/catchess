import 'dart:async';
import '../../model/match_detail_data.dart';
import '../../model/match_data.dart';
import '../../repository/group_repository.dart';
import '../../injection/dependency_injection.dart';

abstract class MatchDetailViewContract {
  onLoadDataComplete(MatchDetail matchDetail);

  /// Informs the UI that an error has occured when retrieving data from the data source.
  onLoadDataError();
}

class MatchDetailPresenter {
  MatchDetailViewContract _view;
  GroupRepository _repository;

  MatchDetailPresenter(this._view) {
    this._repository = Injector().groupRepository;
  }

  Future load(MatchData match) {
    return _repository
        .findMatchDetail(match)
        .then((matchDetail) => _view.onLoadDataComplete(matchDetail))
        .catchError((onError) => _view.onLoadDataError());
  }
}
