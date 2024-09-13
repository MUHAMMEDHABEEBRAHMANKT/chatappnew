// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatServices {
//   //get instence of firebase
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   //get user stream
//   Stream<List<Map<String, dynamic>>> getUserStream() {
//     return _firestore.collection("Users").snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         //go thrugh each induvidual user
//         final user = doc.data();
//         //return user
//         return user;
//       }).toList();
//     });
//   }
//   //send message

//   //get message
// }
// chat_services.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_details.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<UserDetails>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return UserDetails.fromFirestore(data);
      }).toList();
    });
  }
}
