// To parse this JSON data, do
//
//     final userData = userDataFromMap(jsonString);

import 'dart:convert';

UserData userDataFromMap(String str) => UserData.fromMap(json.decode(str));

String userDataToMap(UserData data) => json.encode(data.toMap());

class UserData {
    UserData({
        this.address,
        this.role,
        this.name,
        this.profilePicUrl,
    });

    String address;
    String role;
    String name;
    String profilePicUrl;

    factory UserData.fromMap(Map<String, dynamic> json) => UserData(
        address: json["address"] == null ? null : json["address"],
        role: json["role"] == null ? null : json["role"],
        name: json["name"] == null ? null : json["name"],
        profilePicUrl: json["profilePicUrl"] == null ? null : json["profilePicUrl"],
    );

    Map<String, dynamic> toMap() => {
        "address": address == null ? null : address,
        "role": role == null ? null : role,
        "name": name == null ? null : name,
        "profilePicUrl": profilePicUrl == null ? null : profilePicUrl,
    };
}
