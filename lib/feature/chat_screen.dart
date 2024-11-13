import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/message_provider.dart';
//import 'package:seezme/send_message.dart';
import 'package:seezme/core/utility/constans/const.dart';
import 'package:seezme/widgets/media_message_widget.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:seezme/widgets/message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  //final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Widget> _drawerItems = [];
  File? _image;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      Provider.of<MessageProvider>(context, listen: false)
          .addMessage(_controller.text);
      _controller.clear();
      _scrollToBottom();
    }
  }

  void _sendImage() {
    if (_image != null) {
      Provider.of<MessageProvider>(context, listen: false)
          .addMediaMessage(_image!);
      _scrollToBottom();
      Navigator.of(context).pop();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
    return MaterialApp(
      title: 'SeezMe',
      theme: defaultTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Seezme', style: TextStyle(color: Colors.white)),
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
                height: 100,
                decoration: BoxDecoration(
                  color: defaultTheme.primaryColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 18.0),
                        child: Text(
                          'Seezme',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/profile');
                            print("right drawer avatar clicked");
                          },
                          child: const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://example.com/profile_image_url'),
                            radius: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add Item'),
                onTap: _showAddItemDialog,
              ),
              ..._drawerItems,
            ],
          ),
        ),
        backgroundColor: defaultTheme.primaryColor,
        body: Column(
          children: [
            Expanded(
              child: Consumer<MessageProvider>(
                  builder: (context, MessageProvider, child) {
                return ListView.builder(
                  controller: _scrollController,
                  reverse: false,
                  itemCount: MessageProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = MessageProvider.messages[index];
                    if (message is String) {
                      return MessageWidget(
                        message: message,
                        index: index,
                      );
                    } else if (message is File) {
                      return MediaMessageWidget(media: message, index: index);
                    }
                    return null;
                  },
                );
              }),
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
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text('Add a media'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const SizedBox(height: 20),
                                          _image == null
                                              ? const Text('No image selected.')
                                              : Image.file(
                                                  _image!,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25,
                                                  fit: BoxFit.contain,
                                                ),
                                          TextButton(
                                            onPressed: () async {
                                              final pickedFile =
                                                  await ImagePicker().pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (pickedFile != null) {
                                                setState(() {
                                                  _image =
                                                      File(pickedFile.path);
                                                });
                                              }
                                            },
                                            child: const Text('Choose an image',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w800)),
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Close'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              _image = null;
                                            });
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Delete'),
                                          onPressed: () {
                                            setState(() {
                                              _image = null;
                                            });
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Send'),
                                          onPressed: () {
                                            _sendImage();
                                            setState(() {
                                              _image = null;
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          _sendMessage();
                          _controller.clear();
                        } //todo _sendMessage,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
