import 'package:flutter/material.dart';
import 'package:seezme/utils/const.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return MaterialApp(
      title: 'SeezMe',
      theme: defaultTheme,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Seezme', style: TextStyle(color: Colors.white)),
            backgroundColor: defaultTheme.primaryColor,
            actions: const [Icon(Icons.menu, color: Colors.white)],
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
                              SizedBox(
                                  width:
                                      10), // Profil fotoğrafı ile kullanıcı adı arasında boşluk
                              Text(
                                'Username', // Kullanıcı adı
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Item $index',
                                  style: const TextStyle(color: Colors.white70),
                                ),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
