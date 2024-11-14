import 'package:flutter/material.dart';
import 'package:seezme/widgets/target_button_widget.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          children: [
            TargetButtonWidget(
              sizeWidth: sizeWidth,
              targetRoute: Routes.notifications,
              icon: Icons.notifications,
              title: Titles.notifications,
            ),
            TargetButtonWidget(
              sizeWidth: sizeWidth,
              targetRoute: Routes.quit,
              icon: Icons.exit_to_app_outlined,
              title: Titles.quit,
            )
          ],
        ),
      ),
    );
  }
}
