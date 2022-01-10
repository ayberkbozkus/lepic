
import 'package:exp/app/home/assessmentPages/assessment_page.dart';
import 'package:exp/app/home/classPages/classes_page.dart';
import 'package:exp/app/home/profilePages/profile_page.dart';
import 'package:exp/app/home/tab_items.dart';
import 'package:flutter/material.dart';

import 'cupertino_home.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.classes;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.classes: GlobalKey<NavigatorState>(),
    TabItem.assessments: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.classes: (_) => ClassPage(),
      TabItem.assessments: (_) => AssessmentPage(),
      TabItem.profile: (_) => ProfilePage(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        //widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }

}
