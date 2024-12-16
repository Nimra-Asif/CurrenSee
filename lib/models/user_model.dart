class UserModel {
  final String uId;
  final String username;
  final String email;
  final dynamic createdAt;

  UserModel({required this.uId, required this.username, required this.email, required this.createdAt});


Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'username': username,
      'email': email,
      'createdAt': createdAt,
    };
  }

factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'],
      username: json['username'],
      email: json['email'],
      createdAt: json['createdAt'].toString(),
    );
  }
}

 