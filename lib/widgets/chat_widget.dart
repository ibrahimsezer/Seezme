import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/viewmodels/chat_view_model.dart';
import 'package:seezme/widgets/message_widget.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    super.key,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<ChatViewModel>(
            builder: (context, chatVM, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Always scroll to bottom when messages change
                if (widget._scrollController.hasClients &&
                    chatVM.messages.isNotEmpty) {
                  widget._scrollController.animateTo(
                    widget._scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });

              return ListView.builder(
                controller: widget._scrollController,
                reverse: false,
                itemCount: chatVM.messages.length,
                itemBuilder: (context, index) {
                  final message = chatVM.messages[index];
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
