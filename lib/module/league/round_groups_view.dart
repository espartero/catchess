import 'dart:async';
import 'package:flutter/material.dart';
import '../../model/round_groups_data.dart';
import '../../model/group_data.dart';
import 'round_groups_presenter.dart';

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
        title: Text(
          "Lliga Catalana", // TODO i18n
          style: TextStyle(
            color: Colors.cyan[50], // TODO style
          ),
        ), // TODO i18n + review text style
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              final Group group = _roundGroups.groups[i];
              final List children = <Widget>[
                Text(
                  group.category.name,
                  style: headTextStyle,
                ),
                Icon(
                  Icons.navigate_next,
                  color: Theme.of(context).accentColor,
                ),
                Text(
                  group.subcategory.name.toUpperCase(),
                  style: headBoldTextStyle,
                )
              ];

              return Container(
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
                          children: children,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              group.name,
                              style: subheadTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, i) => Divider(height: 0.0),
            itemCount:
                _roundGroups?.groups != null ? _roundGroups.groups.length : 0),
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
}
