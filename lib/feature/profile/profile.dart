import 'package:flutter/material.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/widgets/target_button_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(Titles.profile),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(Assets.profileImage),
              ),
              SizedBox(height: 16),
              Text(
                'Username',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'email@example.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16),
              TargetButtonWidget(
                sizeWidth: sizeWidth,
                targetRoute: Routes.theme,
                icon: Icons.brightness_6,
                title: Titles.theme,
              ),
              TargetButtonWidget(
                sizeWidth: sizeWidth,
                targetRoute: Routes.notifications,
                icon: Icons.notifications,
                title: Titles.notifications,
              ),
              TargetButtonWidget(
                sizeWidth: sizeWidth,
                targetRoute: Routes.privacy,
                icon: Icons.lock,
                title: Titles.privacy,
              ),
              TargetButtonWidget(
                sizeWidth: sizeWidth,
                targetRoute: Routes.quit,
                icon: Icons.exit_to_app_outlined,
                title: Titles.logout,
              ),
              Spacer(),
              Container(
                  width: sizeWidth * 0.3,
                  child: Image.asset(
                    Assets.logoTransparent,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
