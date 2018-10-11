import 'dart:async';
import 'package:flutter/material.dart';
import '../../model/match_detail_data.dart';
import '../../model/match_data.dart';
import '../../model/game_player_data.dart';
import 'match_detail_presenter.dart';

class MatchDetailPage extends StatefulWidget {
  final MatchData _match;

  MatchDetailPage(this._match, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MatchDetailState(_match);
  }
}

class _MatchDetailState extends State<MatchDetailPage>
    implements MatchDetailViewContract {
  MatchDetailPresenter _presenter;
  final MatchData _match;
  MatchDetail _matchDetail;
  bool _refreshing = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  TextStyle _teamTextStyle;
  TextStyle _pointsTextStyle;
  TextStyle _winnerPlayerTextStyle;
  TextStyle _winnerIncrementTextStyle;
  TextStyle _nonWinnerPlayerTextStyle;
  TextStyle _nonWinnerIncrementTextStyle;

  _MatchDetailState(this._match) {
    _presenter = MatchDetailPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    if (_teamTextStyle == null) {
      var theme = Theme.of(context);
      _teamTextStyle = theme.textTheme.title.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
      );
      _pointsTextStyle = theme.textTheme.display1.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w700,
      );
      _nonWinnerPlayerTextStyle = theme.textTheme.body1.copyWith(
        fontSize: 14.0,
      );
      _nonWinnerIncrementTextStyle = _nonWinnerPlayerTextStyle.copyWith(
        color: Colors.red,
      );
      _winnerPlayerTextStyle = _nonWinnerPlayerTextStyle.copyWith(
        fontWeight: FontWeight.w700,
      );
      _winnerIncrementTextStyle = _winnerPlayerTextStyle.copyWith(
        color: Colors.green,
      );
    }

    List<Widget> children = List();

    if (_matchDetail != null) {
      children.add(
        Container(
          margin: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _createPointsWidget(
                _matchDetail.match.team1,
                _matchDetail.match.result1,
              ),
              Expanded(
                child: Container(
                  height: 70.0,
                  margin: EdgeInsets.symmetric(
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        width: 0.3,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                flex: 1,
              ),
              _createPointsWidget(
                _matchDetail.match.team2,
                _matchDetail.match.result2,
              ),
            ],
          ),
        ),
      );

      children.add(Divider(
        height: 1.0,
      ));
      _matchDetail.games.forEach((game) {
        children.add(Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    game.position.toString(),
                    style: _teamTextStyle,
                  ),
                ),
                flex: 2,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 0.3,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      children: <Widget>[
                        _buildPlayerWidget(
                          game.player1,
                          game.points1,
                          game.isPlayer1Winner(),
                        ),
                        _buildPlayerWidget(
                          game.player2,
                          game.points2,
                          game.isPlayer2Winner(),
                        ),
                      ],
                    ),
                  ),
                ),
                flex: 25,
              ),
            ],
          ),
        ));
        children.add(Divider(
          height: 1.0,
        ));
      });
    } else {
      children.add(Container());
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Lliga Catalana ", // TODO i18n + season
              style: TextStyle(
                color: Colors.cyan[50], // TODO style
                fontWeight: FontWeight.w700,
                fontSize: 22.0,
              ),
            ),
            Text(
              " - 01.02.2018", // TODO i18n + round
              style: TextStyle(
                color: Colors.cyan[50], // TODO style
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        elevation: 2.0,
        brightness: Brightness.dark,
      ),
      backgroundColor: Colors.grey.shade200,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: children,
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    _nonInteractiveRefresh();
  }

  @override
  onLoadDataComplete(MatchDetail matchDetail) {
    setState(() {
      _refreshing = false;
      _matchDetail = matchDetail;
    });
  }

  @override
  onLoadDataError() {
    _refreshing = false;
    final snackBar = SnackBar(
        content: Text(
            "No se ha podido recargar la página. Por favor, chequee su conexión a internet.")); // TODO i18n
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _nonInteractiveRefresh() {
    /// _refreshIndicatorKey.currentState.show() will trigger a call to _handleRefresh().
    if (_refreshIndicatorKey == null ||
        _refreshIndicatorKey.currentState == null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _refreshIndicatorKey.currentState.show();
      });
    } else {
      _refreshIndicatorKey.currentState.show();
    }
  }

  Future _handleRefresh() async {
    if (!_refreshing) {
      _refreshing = true;
      return _presenter.load(_match);
    } else {
      return null;
    }
  }

  /// TODO Unify
  String _pointsToString(double points) {
    if (points == null) {
      return "";
    } else {
      if (points.toString().endsWith(".5")) {
        return (points.floor() == 0 ? "" : points.floor().toString()) +
            "\u00BD";
      } else {
        return points.floor().toString();
      }
    }
  }

  String _incrementToWidget(double increment) {
    if (increment == null) {
      return "";
    } else if (increment >= 0) {
      return "+" + increment.toString();
    } else {
      return increment.toString();
    }
  }

  Widget _createPointsWidget(String team, double points) {
    return Expanded(
      child: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              width: 52.0,
              height: 52.0,
              alignment: Alignment(0.0, 0.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                border: Border.all(
                  color: Colors.grey,
                  width: 0.3,
                  style: BorderStyle.solid,
                ),
              ),
              child: Text(
                _pointsToString(points),
                style: _pointsTextStyle,
              ),
            ),
            Text(
              team,
              style: _teamTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      flex: 490,
    );
  }

  Widget _buildPlayerWidget(GamePlayer player, double points, bool winner) {
    TextStyle textStyle =
        winner ? _winnerPlayerTextStyle : _nonWinnerPlayerTextStyle;
    TextStyle incrementTextStyle = textStyle;

    if (player.increment != null) {
      if (winner && player.increment > 0) {
        incrementTextStyle = _winnerIncrementTextStyle;
      } else if (!winner && player.increment < 0) {
        incrementTextStyle = _nonWinnerIncrementTextStyle;
      }
    }

    return Container(
      padding: EdgeInsets.all(2.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              player.player.name,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
            flex: 30,
          ),
          Expanded(
            child: Text(
              player.title,
              style: textStyle,
            ),
            flex: 4,
          ),
          Expanded(
            child: Text(
              player.elo.toString(),
              style: textStyle,
            ),
            flex: 4,
          ),
          Expanded(
            child: Text(
              _incrementToWidget(player.increment),
              style: incrementTextStyle,
            ),
            flex: 6,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                _pointsToString(points),
                style: textStyle,
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
}
