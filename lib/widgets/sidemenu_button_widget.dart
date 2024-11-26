import 'package:flutter/material.dart';

class SideMenuButtonWidget extends StatelessWidget {
  const SideMenuButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18.0),
      child: Builder(
        builder: (context) => IconButton(
          iconSize: 30,
          icon: const Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ),
    );
  }
}
