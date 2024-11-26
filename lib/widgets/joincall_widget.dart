import 'package:flutter/material.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/widgets/custom_button_widget.dart';

class JoinCallWidget extends StatelessWidget {
  const JoinCallWidget({
    super.key,
    required this.onPressed,
    required this.channelName,
  });
  final VoidCallback onPressed;
  final String channelName;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButtonWidget(
          text: channelName,
          onPressed: onPressed,
          textColor: ConstColors.blackLicorice,
          backgroundColor: WidgetStateProperty.all(ConstColors.orangeWeb),
        ));
  }
}
