// To parse this JSON data, do
//
//     final qoute = qouteFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;

List<Qoute> qouteFromJson(String str) =>
    List<Qoute>.from(json.decode(str).map((x) => Qoute.fromJson(x)));

String qouteToJson(List<Qoute> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Qoute {
  Qoute({
    this.uuid,
    this.qoute,
  });

  String uuid;
  List<QouteElement> qoute;

  factory Qoute.fromJson(Map<String, dynamic> json) => Qoute(
        uuid: json["uuid"],
        qoute: List<QouteElement>.from(
            json["qoute"].map((x) => QouteElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "qoute": List<dynamic>.from(qoute.map((x) => x.toJson())),
      };
}

class QouteElement {
  QouteElement({
    this.title,
  });

  String title;

  factory QouteElement.fromJson(Map<String, dynamic> json) => QouteElement(
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
      };
}

class Services {
  static const String url = 'https://qoute.********';
  static Future<List<Qoute>> getdata() async {
    try {
      final response = await http.get(url);
      if (200 == response.statusCode) {
        final List<Qoute> qouteLlist = qouteFromJson(response.body);
        return qouteLlist;
      } else {
        return List<Qoute>();
      }
    } catch (e) {
      return List<Qoute>();
    }
  }
}
