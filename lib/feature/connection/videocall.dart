import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:seezme/core/services/auth_service.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/widgets/active_users_widget.dart';
import 'package:seezme/widgets/sidebar_profile_widget.dart';
import 'package:seezme/widgets/sidemenu_button_widget.dart';
import 'package:seezme/widgets/sidemenu_drawer_widget.dart';

class VideoCallWidget extends StatefulWidget {
  const VideoCallWidget({super.key, required this.title});
  final String title;

  @override
  State<VideoCallWidget> createState() => _VideoCallWidgetState();
}

class _VideoCallWidgetState extends State<VideoCallWidget> {
  final _auth = AuthService();
  final jitsiMeet = JitsiMeet();
  void join() async {
    var options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.jit.si",
      room: "seezmetestroom", //https://meet.jit.si/{room}
      configOverrides: {
        "startWithAudioMuted": false,
        "startWithVideoMuted": true,
        "subject": "Seezme",
        "localSubject": "Voice Chat",
      },
      featureFlags: {
        "unsaferoomwarning.enabled": false,
        "security-options.enabled": false
      },
      userInfo: JitsiMeetUserInfo(
          displayName: await _auth.getUsername(),
          email: await _auth.getEmail()),
    );
    jitsiMeet.join(options);
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [SideMenuButtonWidget()],
      ),
      endDrawer: SideMenuDrawerWidget(sizeWidth: sizeWidth, authService: _auth),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SidebarProfileWidget(authService: _auth),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(ConstColors.orangeWeb)),
                  onPressed: () {
                    join();
                  },
                  child: Text("Join Call",
                      style: TextStyle(color: ConstColors.blackLicorice)),
                ),
              ],
            ),
            ActiveUsersWidget(),
          ],
        ),
      ),
    );
  }
}
