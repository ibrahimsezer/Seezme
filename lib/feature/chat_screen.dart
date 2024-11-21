import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/models/chat_model.dart';
import 'package:seezme/core/providers/navigaton_provider.dart';
import 'package:seezme/core/services/auth_service.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/utility/helper_function.dart';
import 'package:seezme/core/viewmodels/chat_view_model.dart';
import 'package:seezme/core/viewmodels/user_view_model.dart';
import 'package:seezme/widgets/avatar_widget.dart';
import 'package:seezme/widgets/message_widget.dart';

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
    scrollToBottom(_scrollController, context);
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
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: sizeWidth * 0.15,
                        child: Image(
                          image: AssetImage(Assets.logoTransparent),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Provider.of<NavigationProvider>(context,
                                    listen: false)
                                .goTargetPage(context, Routes.profile);
                          },
                          child: Padding(
                              padding: EdgeInsets.all(15),
                              child: AvatarWidget()),
                        ),
                        Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FutureBuilder<String?>(
                                  future: _authService.getUsername(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return Text(
                                        maxLines: 1,
                                        snapshot.data ?? '--',
                                        style: TextStyle(
                                          fontSize: 18,
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
                                    return Text(
                                      value.status,
                                    );
                                  },
                                )
                              ],
                            ),
                            Consumer<UserViewModel>(
                              builder: (context, value, child) {
                                return PopupMenuButton<String>(
                                  iconSize: 30,
                                  icon: Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) async {
                                    String uid = FirebaseAuth
                                            .instance.currentUser?.uid ??
                                        "";
                                    if (uid != "") {
                                      await Provider.of<UserViewModel>(context,
                                              listen: false)
                                          .updateUserStatus(uid, value);
                                    } else {
                                      showErrorSnackbar(
                                          "Check your internet connection",
                                          context);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: Status.statusAvailable,
                                        child: Text(
                                          Status.statusAvailable,
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: Status.statusIdle,
                                        child: Text(
                                          Status.statusIdle,
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: Status.statusBusy,
                                        child: Text(
                                          Status.statusBusy,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: Status.statusOffline,
                                        child: Text(
                                          Status.statusOffline,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ];
                                  },
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
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
            Consumer<UserViewModel>(builder: (context, userViewModel, child) {
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
                                                : user.status ==
                                                        Status.statusOffline
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
            }),
            ..._drawerItems,
          ],
        ),
      ),
      backgroundColor: defaultTheme.primaryColor,
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatViewModel>(
              builder: (context, chatVM, child) {
                return ListView.builder(
                  controller: _scrollController,
                  reverse: false,
                  itemCount: context.read<ChatViewModel>().messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        context.read<ChatViewModel>().messages[index];
                    if (message.type == 'text') {
                      return MessageWidget(
                        message: message.message,
                        sender: message.sender,
                        createdAt: message.createdAt,
                        index: index,
                        type: message.type,
                      );
                    } else if (message.type == 'media') {
                      return Image.network(
                        //todo return to image message model
                        message.message,
                        fit: BoxFit.cover,
                      );
                    }
                    return null;
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    cursorColor: defaultTheme.primaryColor,
                    style: TextStyle(
                      color: defaultTheme.primaryColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Send a message...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.add, color: Colors.grey[600]),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Info'),
                                content:
                                    Text('Image send is not available yet'),
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
                        },
                      ),
                    ),
                    onSubmitted: (value) async {
                      await context.read<ChatViewModel>().sendMessage(
                            ChatModel(
                              sender: await _authService.getUsername(),
                              message: _controller.text,
                              type: 'text',
                              createdAt: Timestamp.now(),
                            ),
                          );
                      _controller.clear();
                      scrollToBottom(_scrollController, context);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () async {
                        await context.read<ChatViewModel>().sendMessage(
                              ChatModel(
                                sender: await _authService.getUsername(),
                                message: _controller.text,
                                type: 'text',
                                createdAt: Timestamp.now(),
                              ),
                            );
                        _controller.clear();
                        scrollToBottom(_scrollController, context);
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
