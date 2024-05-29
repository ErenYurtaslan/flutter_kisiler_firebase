// ignore_for_file: non_constant_identifier_names, file_names

class Kisiler{
  String kisi_id;
  String kisi_ad;
  String kisi_tel;

  Kisiler(this.kisi_id, this.kisi_ad, this.kisi_tel);

  factory Kisiler.fromJson(String key, Map<dynamic, dynamic> json){
    return Kisiler(key, json["kisi_ad"] as String, json["kisi_tel"] as String);
  }
}