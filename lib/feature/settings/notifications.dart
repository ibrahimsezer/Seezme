import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/notifications_provider.dart';

class NotificationsPage extends StatefulWidget {
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _enableNotifications = false;
  bool _emailNotifications = false;
  bool _smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = Provider.of<NotificationsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: _enableNotifications,
            onChanged: (bool value) {
              setState(() {
                _enableNotifications = value;
              });
              notificationsProvider.toggleEnableNotifications(value);
            },
          ),
          SwitchListTile(
            title: Text('Receive Email Notifications'),
            value: _emailNotifications,
            onChanged: (bool value) {
              setState(() {
                _emailNotifications = value;
              });
              notificationsProvider.toggleEmailNotifications(value);
            },
          ),
          SwitchListTile(
            title: Text('Receive SMS Notifications'),
            value: _smsNotifications,
            onChanged: (bool value) {
              setState(() {
                _smsNotifications = value;
              });
              notificationsProvider.toggleSmsNotifications(value);
            },
          ),
        ],
      ),
    );
  }
}
