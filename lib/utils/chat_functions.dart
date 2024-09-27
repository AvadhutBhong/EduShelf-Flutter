import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFunctions{

  final FirebaseFirestore _db= FirebaseFirestore.instance;

  //Fetch chat messages
  Stream<List<Map<String, dynamic>>> getMessages(String chatId){
    return _db.collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot)=> snapshot.docs.map((doc)=> doc.data()).toList());
  }

  //SEND A MESSAGE
  Future<void> sendMessages(String chatId, String senderId, String message) async {
    final messageData = {
      'senderId': senderId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Add the message to the messages collection
    await _db.collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    // Update the last message in the parent chat document
    await _db.collection('chats')
        .doc(chatId)
        .update({
      'lastMessage': message,
      'lastMessageSenderId': senderId,
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
    });
  }


  //CREATE OR FETCH A CHATID BETWEEN TWO USERS
  Future<String> getChatId(String currentUserId,  String ownerId) async{

    print('GET CHAT ID FUNCTION IS HEREEEEE ++++   CURRENTUSERID : $currentUserId anddddddd OWNER ID : $ownerId');
    final existingChat = await _db.collection('chats')
    .where('participants', arrayContains: currentUserId)
  .get();

    //check if a chat between two users already exists
    for (var chat in existingChat.docs){
      final participants = List<String>.from(chat['participants']);
      if(participants.contains(ownerId)){
        return chat.id;
      }
    }

    //If not exist, then create a new chat
    final newChat = await _db.collection('chats').add({
      'participants' : [currentUserId, ownerId],
      'createdAt': FieldValue.serverTimestamp(),
    });

    return newChat.id;
  }

  //FETCH ALL CHATS OF CURRENT USER
  Future<List<Map<String, dynamic>>> getUserChats(String currentUserId) async {

    print('FETCHING CURRENT CHATS FOR THE ID:' + currentUserId);
    final querySnapshot = await _db.collection('chats')
        .where('participants', arrayContains: currentUserId)
        .get();

    return querySnapshot.docs.map((doc) {
      return {
        'chatId': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }
}