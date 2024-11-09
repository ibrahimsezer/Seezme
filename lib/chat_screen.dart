import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:seezme/send_message.dart';
import 'package:seezme/utils/const.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  List<Widget> _drawerItems = [];
  File? _image;
  @override
  void initState() {
    super.initState();
    // _auth.signInAnonymously().then((result) {
    //   setState(() {
    //     _user = result.user;
    //   });
    // });
  }

  // void _sendMessage() {
  //   if (_controller.text.isNotEmpty) {
  //     FirebaseFirestore.instance.collection('messages').add({
  //       'text': _controller.text,
  //       'createdAt': Timestamp.now(),
  //       'userId': _user?.uid,
  //     });
  //     _controller.clear();
  //   }
  // }

  void _sendImage() {
    if (_image != null) {
      // Medya dosyasını sohbet sayfasına gönderme işlemi burada yapılacak
      // Örneğin, bir mesaj listesine ekleyebilirsiniz
      print('Media sent: ${_image!.path}');
      // Medya gönderildikten sonra pop-up'ı kapatın ve _image'ı temizleyin
      setState(() {
        _image = null;
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _addDrawerItem(String type) {
    setState(() {
      _drawerItems.add(
        ListTile(
          leading: Icon(type == 'Chat' ? Icons.chat : Icons.voice_chat),
          title: Text(type),
          onTap: () {
            // Butona tıklanınca yapılacak işlemler
          },
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
                height:
                    100, // Yüksekliği yarıya düşürmek için manuel olarak ayarlayın
                decoration: BoxDecoration(
                  color: defaultTheme.primaryColor,
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
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
              ),
              ..._drawerItems,
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add Item'),
                onTap: _showAddItemDialog,
              ),
            ],
          ),
        ),
        backgroundColor: defaultTheme.primaryColor,
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: 10, // specify the number of items
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: txtBgColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16.0),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://example.com/profile_image_url'), // Profil fotoğrafı URL'si
                              radius: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Username', // Kullanıcı adı
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Item $index',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                                            child: const Text('Select Media'),
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Kapat'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              _image = null;
                                            });
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Sil'),
                                          onPressed: () {
                                            setState(() {
                                              _image = null;
                                            });
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Gönder'),
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
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {} //_sendMessage,
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
