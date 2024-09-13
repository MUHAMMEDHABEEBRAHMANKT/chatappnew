// user_details.dart
class UserDetails {
  final String uid;
  final String email;

  UserDetails({required this.uid, required this.email});

  factory UserDetails.fromFirestore(Map<String, dynamic> data) {
    return UserDetails(
      uid: data['uid'] as String? ?? '',
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
