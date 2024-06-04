import 'package:emandi/forgotpass.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_ui.dart';

class ChatListScreen extends StatefulWidget {
  ChatListScreen({
    Key? key,
  }) : super(key: key);
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  String lastMessageText = 'Message here';
  String lastMessageTime = '';
  bool isSeen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'User List',
            style: TextStyle(
                color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.teal,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(

                  // bottomleft: Radius.circular(25),
                  bottomRight: Radius.circular(21),
                  bottomLeft: Radius.circular(21))),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.data() == null) {
              return Container(
                  alignment: AlignmentDirectional.center,
                  child: Text('User data is null'));
            }

            Map<String, dynamic> userData =
                snapshot.data!.data()! as Map<String, dynamic>;

            // Handle the chatRooms list safely
            List<dynamic> chatRooms = userData['chatRooms'] ?? [];
            if (chatRooms.isEmpty) {
              return Center(
                  child: Text(
                'No chat rooms found',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ));
            }

            return ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                String chatRoomId = chatRooms[index];
                String sellerId = chatRoomId.substring(0, 28);
                String buyerId = chatRoomId.substring(28);
                String chatId = generateChatId(sellerId, buyerId);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoom(
                          sellerId: sellerId,
                          buyerId: buyerId,
                          chatId: chatId,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      'User Email: ${userData['email']}',
                      style: TextStyle(fontSize: 17),
                    ),
                    subtitle: Text(
                      '$lastMessageText ',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: SizedBox(
          height: 70.0,
          width: 70.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(16.0),
              primary: Colors.teal, // Background color
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String buyerEmail = '';

                  return AlertDialog(
                    title: Text('Create Chat Room'),
                    content: TextField(
                      onChanged: (value) {
                        buyerEmail = value;
                      },
                      decoration:
                          InputDecoration(hintText: 'Enter buyer\'s email'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Create'),
                        onPressed: () async {
                          String? buyerId = await _firestoreService
                              .getBuyerIdByEmail(buyerEmail);
                          if (buyerId != null) {
                            String sellerId = _auth.currentUser!.uid;
                            String chatRoomId =
                                generateChatId(sellerId, buyerId);

                            // Add the new chat room to Firestore
                            await FirebaseFirestore.instance
                                .collection('chatRooms')
                                .doc(chatRoomId)
                                .set({
                              'users': [sellerId, buyerId],
                              'created_at': FieldValue.serverTimestamp(),
                            });

                            // Update the user's chatRooms list
                            await _firestoreService.addChatRoomToUser(
                                sellerId, chatRoomId);
                            await _firestoreService.addChatRoomToUser(
                                buyerId, chatRoomId);

                            if (mounted) {
                              Navigator.of(context).pop();
                              setState(
                                  () {}); // Refresh the screen to show updated chat rooms
                            }
                          } else {
                            // Handle error when buyer email is not found
                            MyToast.myShowToast('Buyer email not found');
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 37,
            ),
          ),
        ));
  }

  String generateChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0
        ? '$userId1$userId2'
        : '$userId2$userId1';
  }
}

class FirestoreService {
  Future<String?> getBuyerIdByEmail(String email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    } else {
      return null;
    }
  }

  Future<void> addChatRoomToUser(String userId, String chatRoomId) async {
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(userId);
    DocumentSnapshot userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      await userDoc.update({
        'chatRooms': FieldValue.arrayUnion([chatRoomId]),
      });
    } else {
      await userDoc.set({
        'chatRooms': [chatRoomId],
      });
    }
  }
}
