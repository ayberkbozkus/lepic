
import 'package:flutter/material.dart';

enum TabItem { classes, assessments, profile }

class TabItemData {
  const TabItemData({required this.title, required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.classes: TabItemData(title: 'Classes', icon: Icons.school),
    TabItem.assessments: TabItemData(title: 'Assessments', icon: Icons.assignment),
    TabItem.profile: TabItemData(title: 'Account', icon: Icons.person),
  };
}