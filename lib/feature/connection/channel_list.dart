// channel_list.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'video_chat.dart';

class ChannelListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel List'),
      ),
      body: Expanded(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('channels').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            var channels = snapshot.data!.docs;
            return ListView.builder(
              itemCount: channels.length,
              itemBuilder: (context, index) {
                var channel = channels[index];
                if (!channel.data().containsKey('name')) {
                  return ListTile(
                    title: const Text('Unnamed Channel'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoChatScreen(channelId: channel.id),
                      ),
                    ),
                  );
                }
                return ListTile(
                  title: Text(channel['name']),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideoChatScreen(channelId: channel.id),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class VideoChatScreen extends StatelessWidget {
  final String channelId;

  const VideoChatScreen({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Chat'),
      ),
      body: Center(
        child: Text('Channel ID: $channelId'),
      ),
    );
  }
}
