// To parse this JSON data, do
//
//     final urLdocument = urLdocumentFromMap(jsonString);

import 'dart:convert';

UrLdocument urLdocumentFromMap(String str) => UrLdocument.fromMap(json.decode(str));

String urLdocumentToMap(UrLdocument data) => json.encode(data.toMap());

class UrLdocument {
    UrLdocument({
        this.url5,
        this.url6,
        this.url3,
        this.url4,
        this.url1,
        this.url2,
        this.url7,
        this.url8,
        this.url9,
        this.url10,
    });

    String url5;
    String url6;
    String url3;
    String url4;
    String url1;
    String url2;
    String url7;
    String url8;
    String url9;
    String url10;

    factory UrLdocument.fromMap(Map<String, dynamic> json) => UrLdocument(
        url5: json["url5"] == null ? null : json["url5"],
        url6: json["url6"] == null ? null : json["url6"],
        url3: json["url3"] == null ? null : json["url3"],
        url4: json["url4"] == null ? null : json["url4"],
        url1: json["url1"] == null ? null : json["url1"],
        url2: json["url2"] == null ? null : json["url2"],
        url7: json["url7"] == null ? null : json["url7"],
        url8: json["url8"] == null ? null : json["url8"],
        url9: json["url9"] == null ? null : json["url9"],
        url10: json["url10"] == null ? null : json["url10"],
    );

    Map<String, dynamic> toMap() => {
        "url5": url5 == null ? null : url5,
        "url6": url6 == null ? null : url6,
        "url3": url3 == null ? null : url3,
        "url4": url4 == null ? null : url4,
        "url1": url1 == null ? null : url1,
        "url2": url2 == null ? null : url2,
        "url7": url7 == null ? null : url7,
        "url8": url8 == null ? null : url8,
        "url9": url9 == null ? null : url9,
        "url10": url10 == null ? null : url10,
    };
}
