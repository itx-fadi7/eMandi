import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_service.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatelessWidget {
  final String sellerId;
  final String buyerId;
  final String chatId;

  ChatRoom({
    required this.sellerId,
    required this.buyerId,
    required String chatId,
  }) : chatId = generateChatId(sellerId, buyerId);

  static String generateChatId(String sellerId, String buyerId) {
    return sellerId.compareTo(buyerId) < 0
        ? '$sellerId$buyerId'
        : '$buyerId$sellerId';
  }

  final TextEditingController messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Chat Room',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(

                // bottomleft: Radius.circular(25),
                bottomRight: Radius.circular(21),
                bottomLeft: Radius.circular(21))),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getChatMessages(chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                markMessagesAsSeen(snapshot.data!.docs, _auth);
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index];
                    bool isMe = message['sender_id'] == _auth.currentUser!.uid;
                    Timestamp? timestamp = message['timestamp'] as Timestamp?;
                    DateTime dateTime = timestamp?.toDate() ?? DateTime.now();
                    String time = DateFormat.jm().format(dateTime);

                    return ListTile(
                      title: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['message'] ?? '',
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    time,
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white70),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    message['isSeen']
                                        ? Icons.done_all
                                        : Icons.done,
                                    color: Colors.white70,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (messageController.text.isNotEmpty) {
                      Map<String, dynamic> messageMap = {
                        'message': messageController.text,
                        'sender_id': _auth.currentUser!.uid,
                        'timestamp': FieldValue.serverTimestamp(),
                        'isSeen': false,
                      };
                      await _chatService.addMessage(chatId, messageMap);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void markMessagesAsSeen(
      List<QueryDocumentSnapshot> messages, FirebaseAuth auth) {
    for (var message in messages) {
      var data = message.data() as Map<String, dynamic>;
      bool isSeen = data.containsKey('isSeen') ? data['isSeen'] : false;
      if (!isSeen && data['sender_id'] != auth.currentUser!.uid) {
        message.reference.update({'isSeen': true});
      }
    }
  }
}
