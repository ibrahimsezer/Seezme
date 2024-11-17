import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/message_provider.dart';
import 'package:seezme/core/providers/navigaton_provider.dart';
import 'package:seezme/core/providers/status_provider.dart';
import 'package:seezme/core/providers/theme_provider.dart';
import 'package:seezme/core/services/shared_preferences_service.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/widgets/avatar_widget.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Widget> _drawerItems = [];
  File? _image;
  Future<String?> _username = SharedPreferencesService().getUsername();

  @override
  void initState() {
    super.initState();
    _fetchChatMessages();
    //_fetchUsername();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsername() async {
    _username;
  }

  void _fetchChatMessages() {
    _firestore.collection('chat').snapshots().listen((querySnapshot) {
      final messages = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Belge ID'sini ekle
        return data;
      }).toList();

      messages.sort((a, b) {
        Timestamp aTimestamp = a['createdAt'];
        Timestamp bTimestamp = b['createdAt'];
        return aTimestamp.compareTo(bTimestamp);
      });

      Provider.of<MessageProvider>(context, listen: false).messages = messages;
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final username = await _username;
      final getMessage = _controller.text;
      final message = {
        'message': getMessage,
        'sender': username ?? "Unknown",
        'createdAt': Timestamp.now(),
        'type': 'text',
      };
      await _firestore.collection('chat').add(message);
      _controller.clear();
    }
    _fetchChatMessages();
  }

  Future<void> _sendImage() async {
    if (_image != null) {
      // Resmi Firebase Storage'a yükle
      final storageRef = _storage
          .ref()
          .child('chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Firestore'a resmi kaydet
      await _firestore.collection('chat').add({
        'message': 'Image',
        'imageUrl': downloadUrl,
        'sender': _username, // Gönderen kullanıcı adı
        'createdAt': Timestamp.now(),
      });

      Provider.of<MessageProvider>(context, listen: false).addMediaMessage({
        'message': 'Image',
        'imageUrl': downloadUrl,
        'sender': _username,
        'createdAt': Timestamp.now(),
      });
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
      ); //todo check this
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
    double sizeWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: Titles.mainTitle,
      theme: defaultTheme, //todo rework theme
      darkTheme: ThemeData.dark(),
      themeMode: Provider.of<ThemeProvider>(context).currentTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(Titles.mainTitle,
              style: TextStyle(color: Colors.white)),
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
                            Container(
                              width: sizeWidth * 0.4,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  FutureBuilder<String?>(
                                    future: _username,
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
                                  Consumer<StatusProvider>(builder:
                                      (context, statusProvider, child) {
                                    return Text(
                                      statusProvider.status,
                                      style: TextStyle(
                                          color: statusProvider.status ==
                                                  Status.statusAvailable
                                              ? Colors.green
                                              : statusProvider.status ==
                                                      Status.statusIdle
                                                  ? Colors.orange
                                                  : statusProvider.status ==
                                                          Status.statusBusy
                                                      ? Colors.red
                                                      : Colors.grey),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              iconSize: 30,
                              icon: Icon(Icons.arrow_drop_down),
                              onSelected: (String value) {
                                Provider.of<StatusProvider>(context,
                                        listen: false)
                                    .updateStatus(value);
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
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: Status.statusBusy,
                                    child: Text(
                                      Status.statusBusy,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ];
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
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
                  onTap: () {}
                  //Provider.of<NavigationProvider>(context, listen: false)
                  //  .goTargetPage(context, Routes.webrtc),
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
                builder: (context, messageProvider, child) {
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: false,
                    itemCount: messageProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = messageProvider.messages[index];
                      if (message['type'] == 'text') {
                        return MessageWidget(
                          message: message['message'],
                          sender: message['sender'] ?? _username,
                          createdAt: message['createdAt'],
                          index: index,
                        );
                      } else if (message['type'] == 'media') {
                        return Image.network(
                          message['mediaUrl'],
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
                        //todo media file upload button, "must have billing account"
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
                        }),
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
