import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RentModel {
  String address;
  String city;
  String discreption;
  String id;
  String imgurl;
  String rentprice;
  Timestamp postdate;
  String userid;
  String username;
  RentModel({
    required this.address,
    required this.city,
    required this.discreption,
    required this.id,
    required this.imgurl,
    required this.rentprice,
    required this.postdate,
    required this.userid,
    required this.username,
  });

  RentModel copyWith({
    String? address,
    String? city,
    String? discreption,
    String? id,
    String? imgurl,
    String? rentprice,
    Timestamp? postdate,
    String? userid,
    String? username,
  }) {
    return RentModel(
      address: address ?? this.address,
      city: city ?? this.city,
      discreption: discreption ?? this.discreption,
      id: id ?? this.id,
      imgurl: imgurl ?? this.imgurl,
      rentprice: rentprice ?? this.rentprice,
      postdate: postdate ?? this.postdate,
      userid: userid ?? this.userid,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'discreption': discreption,
      'id': id,
      'imgurl': imgurl,
      'rentprice': rentprice,
      'postdate': postdate,
      'userid': userid,
      'username': username,
    };
  }

  factory RentModel.fromMap(Map<String, dynamic> map) {
    return RentModel(
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      discreption: map['discreption'] ?? '',
      id: map['id'] ?? '',
      imgurl: map['imgurl'] ?? '',
      rentprice: map['rentprice'] ?? '',
      postdate: map['postdate'] ?? '',
      userid: map['userid'] ?? '',
      username: map['username'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RentModel.fromJson(String source) =>
      RentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RentModel(address: $address, city: $city, discreption: $discreption, id: $id, imgurl: $imgurl, rentprice: $rentprice, postdate: $postdate, userid: $userid, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RentModel &&
        other.address == address &&
        other.city == city &&
        other.discreption == discreption &&
        other.id == id &&
        other.imgurl == imgurl &&
        other.rentprice == rentprice &&
        other.postdate == postdate &&
        other.userid == userid &&
        other.username == username;
  }

  @override
  int get hashCode {
    return address.hashCode ^
        city.hashCode ^
        discreption.hashCode ^
        id.hashCode ^
        imgurl.hashCode ^
        rentprice.hashCode ^
        postdate.hashCode ^
        userid.hashCode ^
        username.hashCode;
  }
}
