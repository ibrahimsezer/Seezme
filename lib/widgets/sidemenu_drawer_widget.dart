import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/services/auth_service.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/utility/helper_function.dart';
import 'package:seezme/core/viewmodels/chat_view_model.dart';
import 'package:seezme/feature/allchat_widget.dart';
import 'package:seezme/widgets/active_users_widget.dart';
import 'package:seezme/widgets/sidebar_profile_widget.dart';

class SideMenuDrawerWidget extends StatelessWidget {
  const SideMenuDrawerWidget({
    super.key,
    required this.sizeWidth,
    required AuthService authService,
  }) : _authService = authService;

  final double sizeWidth;
  final AuthService _authService;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: sizeWidth * 0.4,
            decoration: BoxDecoration(
              color: defaultTheme.primaryColor,
            ),
            child: Container(
              height: sizeWidth * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SidebarProfileWidget(authService: _authService),
                ],
              ),
            ),
          ),
          AllChatsWidget(),
          ListTile(
              leading: const Icon(Icons.video_call),
              title: const Text("Video Call"),
              onTap: () {
                Navigator.pushNamed(context, Routes.videocall);
              }),
          ActiveUsersWidget(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.small(
                  onPressed: () async {
                    final String user = await _authService.getEmail();
                    if (user == "user11@gmail.com") {
                      Provider.of<ChatViewModel>(context, listen: false)
                          .deleteAllMessage();
                    } else {
                      showInfoDialog("Info", "You are not admin", context);
                    }
                  },
                  child: const Icon(Icons.delete_forever)),
            ],
          ),
        ],
      ),
    );
  }
}
