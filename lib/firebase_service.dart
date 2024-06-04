import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String?> getBuyerIdByEmail(String email) async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    } else {
      return null;
    }
  }

  Future<void> createChatRoom(List<String> userIds) async {
    await _firestore.collection('chats').add({'user_ids': userIds});
  }

  Future<void> sendMessage(String chatId, String message) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'sender_id': FirebaseAuth.instance.currentUser!.uid,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getChatRoomMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  Future<DocumentSnapshot> getUserInfo(String userId) {
    return _firestore.collection('users').doc(userId).get();
  }
}
