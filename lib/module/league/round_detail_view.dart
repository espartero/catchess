import 'dart:async';
import 'package:flutter/material.dart';
import '../../model/season_data.dart';
import '../../model/round_data.dart';
import '../../model/group_data.dart';
import '../../model/round_detail_data.dart';
import '../../model/group_matches_data.dart';
import '../../model/match_data.dart';
import 'round_detail_presenter.dart';
import 'match_detail_view.dart';

class RoundDetailPage extends StatefulWidget {
  final Season _season;
  final Round _round;
  final Group _group;

  RoundDetailPage(this._season, this._round, this._group, {Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RoundDetailState(_season, _round, group: _group);
  }
}

class _RoundDetailState extends State<RoundDetailPage>
    implements RoundDetailViewContract {
  RoundDetailPresenter _presenter;
  Season _season;
  Round _round;
  Group _group;
  RoundDetail _roundDetail;
  bool _refreshing = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  _RoundDetailState(this._season, this._round, {Group group}) {
    this._group = group;
    _presenter = RoundDetailPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var headTextStyle = theme.textTheme.caption.copyWith(
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
    );
    var subheadTextStyle = theme.textTheme.caption.copyWith(
      fontSize: 14.0,
    );
    var nonWinnerTeamTextStyle = theme.textTheme.body1.copyWith(
      fontSize: 14.0,
    );
    var winnerTeamTextStyle = nonWinnerTeamTextStyle.copyWith(
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Lliga Catalana " + _season.year, // TODO i18n
              style: TextStyle(
                color: Colors.cyan[50], // TODO style
                fontWeight: FontWeight.w700,
                fontSize: 22.0,
              ),
            ),
            Text(
              _round.name + " - 01.02.2018", // TODO i18n
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
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            GroupMatches groupMatches = _roundDetail.groupMatches[i];
            Group group = groupMatches.group;

            List<Widget> matchWidgets = List();
            for (var i = 0; i < groupMatches.matches.length; i++) {
              MatchData match = groupMatches.matches[i];
              var team1TextStyle = match.isTeam1Winner()
                  ? winnerTeamTextStyle
                  : nonWinnerTeamTextStyle;
              var team2TextStyle = match.isTeam2Winner()
                  ? winnerTeamTextStyle
                  : nonWinnerTeamTextStyle;

              matchWidgets.add(
                GestureDetector(
                  onTap: () => _pushDetail(match),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                    child: Table(
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1: FixedColumnWidth(30.0),
                      },
                      children: [
                        TableRow(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  match.team1,
                                  style: team1TextStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  match.team2,
                                  style: team2TextStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  _pointsToString(match.result1),
                                  style: team1TextStyle,
                                ),
                                Text(
                                  _pointsToString(match.result2),
                                  style: team2TextStyle,
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );

              if (i < groupMatches.matches.length - 1) {
                matchWidgets.add(Divider(height: 8.0));
              } else {
                matchWidgets.add(
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  ),
                );
              }
            }

            return Card(
              margin: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
              elevation: 2.0,
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      group.subcategory.name,
                      style: headTextStyle,
                    ),
                    subtitle: Text(
                      group.category.name + " - " + group.name,
                      style: subheadTextStyle,
                    ),
                  ),
                  Divider(height: 8.0),
                  Column(
                    children: matchWidgets,
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, i) => Container(),
          itemCount:
              _roundDetail == null ? 0 : _roundDetail.groupMatches.length,
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
  onLoadDataComplete(RoundDetail roundDetail) {
    setState(() {
      _refreshing = false;
      _roundDetail = roundDetail;
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
      return _presenter.load(_season, _round, group: _group);
    } else {
      return null;
    }
  }

  _pushDetail(MatchData match) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchDetailPage(match),
      ),
    );
  }

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
}
