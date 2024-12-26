import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/utility/helper_function.dart';
import 'package:seezme/core/viewmodels/user_view_model.dart';

class StatusButtonWidget extends StatelessWidget {
  const StatusButtonWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Consumer<UserViewModel>(
      builder: (context, value, child) {
        return PopupMenuButton<String>(
          iconSize: 30,
          icon: Icon(Icons.arrow_drop_down),
          onSelected: (String value) async {
            String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
            if (uid != "") {
              await userViewModel.updateUserStatus(uid, value);
              userViewModel.listenToUsers();
            } else {
              showErrorSnackbar("Check your internet connection", context);
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: Status.statusAvailable,
                child: Text(
                  Status.statusAvailable,
                  style: TextStyle(
                      color: Colors.green, fontSize: FontSize.statusFontSize),
                ),
              ),
              PopupMenuItem<String>(
                value: Status.statusIdle,
                child: Text(
                  Status.statusIdle,
                  style: TextStyle(
                      color: Colors.orange, fontSize: FontSize.statusFontSize),
                ),
              ),
              PopupMenuItem<String>(
                value: Status.statusBusy,
                child: Text(
                  Status.statusBusy,
                  style: TextStyle(
                      color: Colors.red, fontSize: FontSize.statusFontSize),
                ),
              ),
              PopupMenuItem<String>(
                value: Status.statusOffline,
                child: Text(
                  Status.statusOffline,
                  style: TextStyle(
                      color: Colors.grey, fontSize: FontSize.statusFontSize),
                ),
              ),
            ];
          },
        );
      },
    );
  }
}
