import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/viewmodels/chat_view_model.dart';
import 'package:seezme/widgets/avatar_widget.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final String sender;
  final Timestamp createdAt;
  final int index;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MessageWidget({
    super.key,
    required this.message,
    required this.sender,
    required this.createdAt,
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
                  onPressed: () async {
                    // Firestore'dan mesajı sil
                    Provider.of<ChatViewModel>(context, listen: false)
                        .deleteMessage(_firestore.collection('chats').doc().id);
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
                  onTap: () {},
                  child: AvatarWidget(),
                ),
                const SizedBox(width: 10),
                Text(
                  sender, // Kullanıcı adı
                  style: const TextStyle(color: Colors.white70),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    createdAt.toDate().toString().substring(0, 19),
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
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
