import 'dart:async';
import 'package:flutter/material.dart';
import '../../model/round_groups_data.dart';
import '../../model/group_data.dart';
import 'round_groups_presenter.dart';
import 'round_detail_view.dart';

/// Page that shows the list of groups for a round.
///
/// The user can pick wich season and round will be displayed. By default,
/// the last round will be displayed.
class RoundGroupsPage extends StatefulWidget {
  RoundGroupsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RoundGroupsState();
  }
}

class _RoundGroupsState extends State<RoundGroupsPage>
    implements RoundGroupsViewContract {
  RoundGroupsPresenter _presenter;
  RoundGroups _roundGroups;
  bool _refreshing = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  _RoundGroupsState() {
    _presenter = RoundGroupsPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var headTextStyle = theme.textTheme.title.copyWith(
      fontSize: 18.0,
    );
    var headBoldTextStyle = headTextStyle.copyWith(
      fontWeight: FontWeight.w700,
    );
    var subheadTextStyle = theme.textTheme.caption.copyWith(
      fontSize: 14.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Lliga Catalana 2018", // TODO i18n
              style: TextStyle(
                color: Colors.cyan[50], // TODO style
                fontWeight: FontWeight.w700,
                fontSize: 22.0,
              ),
            ),
            Text(
              "Ronda 1 - 01.02.2018", // TODO i18n
              style: TextStyle(
                color: Colors.cyan[50], // TODO style
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        elevation: 2.0,
        brightness: Brightness.dark,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              if (i == 0) {
                return GestureDetector(
                  onTap: () => _pushDetail(),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 40.0,
                    margin: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Todos los grupos",
                            style: headBoldTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                final Group group = _roundGroups.groups[i - 1];

                return GestureDetector(
                  onTap: () => _pushDetail(group: group),
                  child: Container(
                    height: 40.0,
                    margin: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  group.subcategory.name,
                                  style: headBoldTextStyle,
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  group.category.name + " - " + group.name,
                                  style: subheadTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            separatorBuilder: (context, i) => Divider(height: 0.0),
            itemCount: _roundGroups?.groups != null
                ? _roundGroups.groups.length + 1
                : 0),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    _nonInteractiveRefresh();
  }

  @override
  onLoadDataComplete(RoundGroups roundGroups) {
    setState(() {
      _refreshing = false;
      _roundGroups = roundGroups;
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
      return _presenter.loadLastRound();
    } else {
      return null;
    }
  }

  _pushDetail({Group group}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoundDetailPage(
                _roundGroups.season,
                _roundGroups.round,
                group,
              )),
    );
  }
}
