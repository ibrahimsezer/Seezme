import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/navigaton_provider.dart';
import 'package:seezme/core/services/auth_service.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/viewmodels/user_view_model.dart';
import 'package:seezme/widgets/avatar_widget.dart';
import 'package:seezme/widgets/status_button_widget.dart';

class SidebarProfileWidget extends StatelessWidget {
  const SidebarProfileWidget({
    super.key,
    required AuthService authService,
  }) : _authService = authService;

  final AuthService _authService;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Provider.of<NavigationProvider>(context, listen: false)
                .goTargetPage(context, Routes.profile);
          },
          child: Padding(
              padding: PaddingSize.paddingStandartSize, child: AvatarWidget()),
        ),
        Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder<String?>(
                  future: _authService.getUsername(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text(
                        maxLines: 1,
                        snapshot.data ?? '--',
                        style: TextStyle(
                          color: ConstColors.onPrimaryColor,
                          fontSize: FontSize.usernameFontSize,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                  },
                ),
                Consumer<UserViewModel>(
                  builder: (context, value, child) {
                    return Text(value.status,
                        style: TextStyle(
                          color: ConstColors.onPrimaryColor,
                          fontSize: FontSize.statusFontSize,
                        ));
                  },
                )
              ],
            ),
            StatusButtonWidget(),
          ],
        )
      ],
    );
  }
}
