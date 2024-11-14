import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  void _goTargetPage(BuildContext context, String target) {
    Navigator.of(context).pushNamed(target);
  }

  get goTargetPage => _goTargetPage;
}
