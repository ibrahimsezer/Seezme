import 'package:flutter/material.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: AssetImage(Assets.profileImage),
      radius: 20,
    );
  }
}
