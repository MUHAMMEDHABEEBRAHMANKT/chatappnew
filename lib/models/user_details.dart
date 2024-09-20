class UserDetails {
  final String uid;
  final String email;

  UserDetails({required this.uid, required this.email});

  // Updated to include uid from the Firestore document ID
  factory UserDetails.fromFirestore(
      Map<String, dynamic> data, String documentID) {
    return UserDetails(
      uid: documentID, // Set uid to the document ID
      email: data['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }
}
