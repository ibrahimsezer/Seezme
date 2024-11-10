import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/models/message_model.dart';
import 'package:seezme/utils/const.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final int index;
  const MessageWidget({
    super.key,
    required this.message,
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
              title: const Text('Delete Message'),
              content: const Text('Do you want to delete this message?'),
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
                    Provider.of<MessageModel>(context, listen: false)
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
      ),
    );
  }
}
