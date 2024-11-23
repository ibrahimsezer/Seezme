import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/viewmodels/user_view_model.dart';
import 'package:seezme/widgets/zoomable_card.dart';

class ActiveUsersWidget extends StatefulWidget {
  const ActiveUsersWidget({super.key});

  @override
  State<ActiveUsersWidget> createState() => _ActiveUsersWidget1State();
}

class _ActiveUsersWidget1State extends State<ActiveUsersWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(builder: (context, userViewModel, child) {
      return Column(
        children: [
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text(Titles.activeUsers),
            onTap: () async {
              await userViewModel.fetchUsers();
              userViewModel.refreshStatus();
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: userViewModel.users.length,
              itemBuilder: (context, index) {
                final user = userViewModel.users[index];
                return ZoomableCard(
                  imageString: Assets.profileImage3,
                  username: user.username,
                  status: user.status,
                );
              },
            ),
        ],
      );
    });
  }
}
