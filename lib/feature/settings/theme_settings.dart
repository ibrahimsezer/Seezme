import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/theme_provider.dart';

class ThemeSettingsPage extends StatefulWidget {
  @override
  _ThemeSettingsPageState createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('Dark Theme'),
              value: _isDarkTheme,
              onChanged: (bool value) {
                setState(() {
                  _isDarkTheme = value;
                });
                themeProvider.toggleTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
