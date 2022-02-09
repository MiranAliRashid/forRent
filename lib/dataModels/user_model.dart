//this is model for users
import 'dart:convert';

class UserModel {
  String? id;
  String? username;
  String? email;
  String? imgurl;
  String? phone;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? token;
  UserModel({
    this.id,
    this.username,
    this.email,
    this.imgurl,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? imgurl,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      imgurl: imgurl ?? this.imgurl,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'imgurl': imgurl,
      'phone': phone,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      imgurl: map['imgurl'],
      phone: map['phone'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, imgurl: $imgurl, phone: $phone, createdAt: $createdAt, updatedAt: $updatedAt, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.imgurl == imgurl &&
        other.phone == phone &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.token == token;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        email.hashCode ^
        imgurl.hashCode ^
        phone.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        token.hashCode;
  }
}
