// chat_services.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_chat_app/models/message.dart';
import 'user_details.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<List<UserDetails>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return UserDetails.fromFirestore(data);
      }).toList();
    });
  }
  //send msg

  Future<void> sendMessage(String reciverID, message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        reciverID: reciverID,
        message: message,
        timestamp: timestamp);
    //constuct chat room id for two users(sorted to ensure uniqness)
    List<String> ids = [currentUserID, reciverID];
    ids.sort(); //sort the ids (this ensure the chatroomID is same for teh any 2 people)
    String chatroomID = ids.join('_');
    //add new message to the databese
    _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //get the message

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //construct chatroom id for the 2 users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatroomID = ids.join('_');
    return _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
