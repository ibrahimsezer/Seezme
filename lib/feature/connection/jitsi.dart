import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class JitsiApp extends StatefulWidget {
  const JitsiApp({super.key, required this.title});
  final String title;

  @override
  State<JitsiApp> createState() => _JitsiAppState();
}

class _JitsiAppState extends State<JitsiApp> {
  final meetingNameController = TextEditingController();
  final jitsiMeet = JitsiMeet();
  void join() {
    var options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.jit.si",
      room: "BrilliantPitiesWinSomewhere", //https://meet.jit.si/{room}
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
          displayName: meetingNameController.text,
          email: "hasakiyasuo2008@gmail.com"),
    );
    jitsiMeet.join(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 250,
              height: 50,
              child: TextField(
                style: const TextStyle(color: ConstColors.whiteColor),
                controller: meetingNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter meeting name',
                ),
              ),
            ),
            SizedBox(
              width: 100,
              height: 50,
              child: FilledButton(
                  onPressed: join,
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                  ),
                  child: const Text("Join")),
            ),
          ],
        ),
      ),
    );
  }
}
