import 'dart:io';

import 'package:flutter/material.dart';
import 'package:seezme/utils/const.dart';

class MediaMessageWidget extends StatelessWidget {
  final File media;
  const MediaMessageWidget({
    super.key,
    required this.media,
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
          const SizedBox(height: 5),
          Row(
            children: [
              Image.file(
                media,
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.50,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
