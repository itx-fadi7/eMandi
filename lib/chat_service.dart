import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get or create a chat room ID
  Future<String> getChatRoomId(String sellerId, String buyerId) async {
    // Ensure the IDs are always in the same order
    String chatRoomId = sellerId.compareTo(buyerId) < 0
        ? '$sellerId$buyerId'
        : '$sellerId$buyerId';
    // Check if the chat room already exists
    DocumentSnapshot chatRoom =
        await _firestore.collection('chatRooms').doc(chatRoomId).get();
    if (!chatRoom.exists) {
      // Create a new chat room
      await _firestore.collection('chatRooms').doc(chatRoomId).set({
        'users': [sellerId, buyerId],
        'created_at': FieldValue.serverTimestamp(),
      });
    }

    return chatRoomId;
  }

  Stream<QuerySnapshot> getChatMessages(String chatId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> addMessage(String chatId, Map<String, dynamic> message) async {
    await _firestore
        .collection('chatRooms')
        .doc(chatId)
        .collection('messages')
        .add(message);
  }
}

String generateChatId(String userId1, String userId2) {
  // Ensure the IDs are always in the same order
  String chatId =
      userId1.compareTo(userId2) < 0 ? '$userId1$userId2' : '$userId2$userId1';
  return chatId;
}
