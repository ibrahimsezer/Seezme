import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/models/chat_model.dart';
import 'package:seezme/core/services/auth_service.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/utility/helper_function.dart';
import 'package:seezme/core/viewmodels/chat_view_model.dart';

class SendMessageWidget extends StatelessWidget {
  const SendMessageWidget({
    super.key,
    required TextEditingController controller,
    required AuthService authService,
    required ScrollController scrollController,
  })  : _controller = controller,
        _authService = authService,
        _scrollController = scrollController;

  final TextEditingController _controller;
  final AuthService _authService;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewModel>(builder: (context, chatViewModel, child) {
      return Padding(
        padding: PaddingSize.paddingSmallSize,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                  controller: _controller,
                  cursorColor: defaultThemeLight.primaryColor,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: defaultThemeLight.primaryColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Send a message...',
                    hintStyle: TextStyle(color: ConstColors.greyColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: ConstColors.whiteColor,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.add, color: ConstColors.greyColor),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Info'), //todo
                              content: Text('Image send is not available yet',
                                  style:
                                      TextStyle(color: ConstColors.whiteColor)),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  onSubmitted: (value) async {
                    if (_controller.text.isNotEmpty) {
                      try {
                        await Provider.of<ChatViewModel>(context, listen: false)
                            .sendMessage(
                          ChatModel(
                            id: await _authService.auth.currentUser.uid,
                            sender: await _authService.getUsername(),
                            message: _controller.text,
                            type: 'text',
                            createdAt: Timestamp.now(),
                          ),
                        );
                        _controller.clear();

                        // Ensure scroll happens after message is sent
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Failed to send message. Please try again.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  }),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      try {
                        await Provider.of<ChatViewModel>(context, listen: false)
                            .sendMessage(
                          ChatModel(
                            id: await _authService.auth.currentUser.uid,
                            sender: await _authService.getUsername(),
                            message: _controller.text,
                            type: 'text',
                            createdAt: Timestamp.now(),
                          ),
                        );
                        _controller.clear();

                        // Ensure scroll happens after message is sent
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Failed to send message. Please try again.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  }),
            ),
          ],
        ),
      );
    });
  }
}
