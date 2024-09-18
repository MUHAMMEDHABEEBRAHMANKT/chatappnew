class UserDetails {
  final String uid;
  final String email;
  final String name; // Add name field

  UserDetails({
    required this.uid,
    required this.email,
    required this.name, // Include name in constructor
  });

  // Updated to include uid and name from the Firestore document
  factory UserDetails.fromFirestore(
      Map<String, dynamic> data, String documentID) {
    return UserDetails(
      uid: documentID,
      email: data['email'] as String? ?? '', // Handle email field
      name: data['name'] as String? ?? '', // Handle name field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name, // Add name to map
    };
  }
}
