// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class DotLocal {
  static DotLocal fromJsonString(String jsonString) => DotLocal.fromJson(json.decode(jsonString));

  static String toJsonString(DotLocal data) => json.encode(data.toJson());

  bool isPrivate;
  String password;
  String iconName;

  DotLocal({
    this.isPrivate,
    this.password,
    this.iconName,
  });

  factory DotLocal.fromJson(Map<String, dynamic> json) {
    return DotLocal(
      isPrivate: json['isPrivate'],
      password: json['password'],
      iconName: json['iconName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "isPrivate": isPrivate,
      "password": password,
      "iconName": iconName,
    };
  }
}
