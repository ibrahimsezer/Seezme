import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/viewmodels/chat_view_model.dart';
import 'package:seezme/widgets/message_widget.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<ChatViewModel>(
            builder: (context, chatVM, child) {
              return ListView.builder(
                controller: _scrollController,
                reverse: false,
                itemCount: context.watch<ChatViewModel>().messages.length,
                itemBuilder: (context, index) {
                  final message =
                      context.watch<ChatViewModel>().messages[index];
                  if (message.type == 'text') {
                    return MessageWidget(
                      message: message.message,
                      sender: message.sender,
                      createdAt: message.createdAt,
                      index: index,
                      type: message.type,
                    );
                  } else if (message.type == 'media') {
                    return Image.network(
                      //todo return to image message model
                      message.message,
                      fit: BoxFit.cover,
                    );
                  }
                  return null;
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
