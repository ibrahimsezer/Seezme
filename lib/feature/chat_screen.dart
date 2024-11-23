import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/services/auth_service.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/utility/helper_function.dart';
import 'package:seezme/core/viewmodels/chat_view_model.dart';
import 'package:seezme/core/viewmodels/user_view_model.dart';
import 'package:seezme/widgets/active_users_widget.dart';
import 'package:seezme/widgets/chat_widget.dart';
import 'package:seezme/widgets/send_message_widget.dart';
import 'package:seezme/widgets/sidebar_profile_widget.dart';

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

  List<Widget> _drawerItems = [];

  //new
  //ChatViewModel _chatViewModel = ChatViewModel();
  //UserViewModel _userViewModel = UserViewModel();
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

  void _addDrawerItem(String type) {
    setState(() {
      _drawerItems.add(
        ListTile(
          leading: Icon(type == 'Chat' ? Icons.chat : Icons.voice_chat),
          title: Text(type),
          onTap: () {},
        ),
      );
    });
  }

  void _showAddItemDialog() {
    showDialog(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: const Text('What type of item would you like to add?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Chat'),
              onPressed: () {
                _addDrawerItem('Chat');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Voice Chat'),
              onPressed: () {
                _addDrawerItem('Voice Chat');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            const Text(Titles.mainTitle, style: TextStyle(color: Colors.white)),
        backgroundColor: defaultTheme.primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Builder(
              builder: (context) => IconButton(
                iconSize: 30,
                icon: const Icon(Icons.menu),
                color: Colors.white,
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          )
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: sizeWidth * 0.4,
              decoration: BoxDecoration(
                color: defaultTheme.primaryColor,
              ),
              child: Container(
                height: sizeWidth * 0.4,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SidebarProfileWidget(authService: _authService),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Item'),
              onTap: _showAddItemDialog,
            ),
            ListTile(
                leading: const Icon(Icons.video_call),
                title: const Text("Video Call"),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Info'),
                        content: Text('Video Call is not available yet'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }),
            ActiveUsersWidget(),
            ..._drawerItems,
          ],
        ),
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
