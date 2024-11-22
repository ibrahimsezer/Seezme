import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/viewmodels/user_view_model.dart';

class ActiveUsersWidget extends StatelessWidget {
  const ActiveUsersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(builder: (context, userViewModel, child) {
      return ListTile(
        leading: const Icon(Icons.people),
        title: const Text(Titles.activeUsers),
        onTap: () async {
          userViewModel.fetchUsers();
          userViewModel.refreshStatus();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Consumer<UserViewModel>(
                  builder: (context, userViewModel, child) {
                return AlertDialog(
                  title: const Text(Titles.activeUsers),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: userViewModel.users.length,
                      itemBuilder: (context, index) {
                        final user = userViewModel.users[index];
                        return ListTile(
                          title: Text(user.username),
                          subtitle: Text(user.status),
                          leading: Icon(
                            Icons.circle,
                            color: user.status == Status.statusAvailable
                                ? Colors.green
                                : user.status == Status.statusIdle
                                    ? Colors.orange
                                    : user.status == Status.statusBusy
                                        ? Colors.red
                                        : user.status == Status.statusOffline
                                            ? Colors.grey
                                            : Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
            },
          );
        },
      );
    });
  }
}
