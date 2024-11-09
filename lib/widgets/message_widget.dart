import 'package:flutter/material.dart';
import 'package:seezme/utils/const.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  const MessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: txtBgColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  //Navigator.of(context).pushNamed('/profile');
                  print("chat avatar clicked");
                },
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://example.com/profile_image_url'), // Profil fotoğrafı URL'si
                  radius: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Username', // Kullanıcı adı
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white70),
                    maxLines: null,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
