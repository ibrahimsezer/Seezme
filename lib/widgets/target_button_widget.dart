import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/navigaton_provider.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class TargetButtonWidget extends StatelessWidget {
  const TargetButtonWidget({
    super.key,
    required this.sizeWidth,
    required this.targetRoute,
    required this.icon,
    required this.title,
  });

  final double sizeWidth;
  final String targetRoute;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<NavigationProvider>(context, listen: false)
            .goTargetPage(context, targetRoute);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: sizeWidth * 0.9,
          decoration: BoxDecoration(
              color: buttonColorDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: buttonBorderColorDark)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(icon),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(title),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
