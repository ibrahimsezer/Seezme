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

  @override
  void initState() {
    super.initState();
    Provider.of<ChatViewModel>(context, listen: false).fetchMessages();
    Provider.of<UserViewModel>(context, listen: false).fetchUsers();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom(_scrollController, context);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Provider.of<ChatViewModel>(context, listen: false).fetchMessages();
      Provider.of<UserViewModel>(context, listen: false).fetchUsers();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom(_scrollController, context);
      });
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
        backgroundColor: defaultTheme.primaryColor,
        actions: [SideMenuButtonWidget()],
      ),
      endDrawer: SideMenuDrawerWidget(
        sizeWidth: sizeWidth,
        authService: _authService,
      ),
      backgroundColor: defaultTheme.primaryColor,
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
