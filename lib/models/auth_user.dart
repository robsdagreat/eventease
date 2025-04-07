class AuthUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  AuthUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      uid: map['uid'] ?? '',
      email: map['email'],
      displayName: map['displayName'],
      photoURL: map['photoURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }
}
