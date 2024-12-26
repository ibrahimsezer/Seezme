import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/services/auth_service.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/utility/helper_function.dart';
import 'package:seezme/core/viewmodels/chat_view_model.dart';
import 'package:seezme/core/viewmodels/user_view_model.dart';
import 'package:seezme/widgets/chat_widget.dart';
import 'package:seezme/widgets/send_message_widget.dart';
import 'package:seezme/widgets/sidemenu_button_widget.dart';
import 'package:seezme/widgets/sidemenu_drawer_widget.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  AuthService _authService = AuthService();
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    // Initialize presence system
    AuthService().initUserPresence();

    // Start listening to messages and users
    chatViewModel.listenToMessages();
    userViewModel.listenToUsers();

    // Set up periodic check for inactive users
    _inactivityTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      userViewModel.checkInactiveUsers();
    });

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom(_scrollController, context);
    });
    chatViewModel.addListener(() {
      scrollToBottom(_scrollController, context);
    });
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    Provider.of<ChatViewModel>(context, listen: false).dispose();
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser;

    switch (state) {
      case AppLifecycleState.resumed:
        if (currentUser != null) {
          userViewModel.updateUserStatus(
              currentUser.uid, Status.statusAvailable);
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        if (currentUser != null) {
          userViewModel.updateUserStatus(currentUser.uid, Status.statusIdle);
        }
        break;
      case AppLifecycleState.detached:
        if (currentUser != null) {
          userViewModel.updateUserStatus(currentUser.uid, Status.statusOffline);
        }
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

//todo fetch messasge scrolling not working
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            const Text(Titles.mainTitle, style: TextStyle(color: Colors.white)),
        backgroundColor: defaultThemeLight.primaryColor,
        actions: [SideMenuButtonWidget()],
      ),
      endDrawer: SideMenuDrawerWidget(
        sizeWidth: sizeWidth,
        authService: _authService,
      ),
      backgroundColor: defaultThemeLight.primaryColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ChatWidget(scrollController: _scrollController),
          ),
          SendMessageWidget(
              controller: _controller,
              authService: _authService,
              scrollController: _scrollController),
        ],
      ),
    );
  }
}
