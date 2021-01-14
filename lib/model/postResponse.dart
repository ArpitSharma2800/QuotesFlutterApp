// To parse this JSON data, do
//
//     final postresponse = postresponseFromJson(jsonString);

import 'dart:convert';

Postresponse postresponseFromJson(String str) =>
    Postresponse.fromJson(json.decode(str));

String postresponseToJson(Postresponse data) => json.encode(data.toJson());

class Postresponse {
  Postresponse({
    this.uuid,
    this.qoute,
  });

  String uuid;
  List<Qoute> qoute;

  factory Postresponse.fromJson(Map<String, dynamic> json) => Postresponse(
        uuid: json["uuid"],
        qoute: List<Qoute>.from(json["qoute"].map((x) => Qoute.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "qoute": List<dynamic>.from(qoute.map((x) => x.toJson())),
      };
}

class Qoute {
  Qoute({
    this.title,
  });

  String title;

  factory Qoute.fromJson(Map<String, dynamic> json) => Qoute(
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
      };
}
