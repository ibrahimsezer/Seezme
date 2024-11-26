import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/viewmodels/chat_view_model.dart';

class AllChatsWidget extends StatefulWidget {
  const AllChatsWidget({
    super.key,
  });

  @override
  State<AllChatsWidget> createState() => _AllChatsWidgetState();
}

class _AllChatsWidgetState extends State<AllChatsWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewModel>(builder: (context, chatViewModel, child) {
      return Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Chats'),
            onTap: () async {
              await chatViewModel.createNewChatRoom('chatId_1');
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            //todo return allchat list with widget
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: chatViewModel.allChatList.length,
              itemBuilder: (context, index) {
                final chatList = chatViewModel.allChatList[index];
                return Text(chatList.message);
              },
            ),
        ],
      );
    });
  }
}
