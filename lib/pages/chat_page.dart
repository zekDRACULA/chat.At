import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/service/database_service.dart'; // Import your DatabaseService

class ChatPage extends StatefulWidget {
  final String? currentUserUid;
  final String? friendUid;
  final String? chatId; // Pass the chat ID to the chat page

  const ChatPage({
    Key? key,
    required this.currentUserUid,
    required this.friendUid,
    required this.chatId, // Receive the chat ID here
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? messages; // Stream for chat messages
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadChatMessages();
  }

  // Load chat messages for the given chat ID
  void loadChatMessages() {
    messages = DatabaseService().getChatMessages(widget.chatId!);
  }

  // Send a message to the chat
  void sendMessage() {
    String messageText = messageController.text.trim();
    if (messageText.isNotEmpty) {
      DatabaseService()
          .sendMessage(widget.chatId!, widget.currentUserUid!, messageText);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'), // Display the chat title or friend's name
      ),
      body: Column(
        children: [
          // Display chat messages using StreamBuilder
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messages,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Build the list of chat messages
                final messagesList = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messagesList) {
                  // Customize the message display as needed
                  String messageText = message['text'];
                  String senderUid = message['sender'];

                  // For example, display messages in a ListTile
                  messageWidgets.add(ListTile(
                    title: Text(messageText),
                    subtitle: Text('Sender: $senderUid'),
                  ));
                }

                return ListView(
                  children: messageWidgets,
                );
              },
            ),
          ),
          // Input field for sending messages
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
