import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/message_provider.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class MediaMessageWidget extends StatelessWidget {
  final File media;
  final int index;
  const MediaMessageWidget({
    super.key,
    required this.media,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Media'),
              content: const Text('Do you want to delete this media?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    Provider.of<MessageProvider>(context, listen: false)
                        .removeMessage(index);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: defaultTextBackgroundColor,
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
                  height: MediaQuery.of(context).size.width * 1,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
