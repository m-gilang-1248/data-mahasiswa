// ignore_for_file: file_namas, unnecessary_this, prefer_collection_literals

import 'dart:typed_data';
import 'dart:convert';


class Data{
  int? id;
  String? nama;
  String? nim;
  String? nohp;
  String? alamat;
  Uint8List? imageBytes;

  Data({this.id, this.nama, this.nim, this.nohp, this.alamat, this.imageBytes});

  Map<String, dynamic> toMapWithImage() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = id;
    }
    map['nama'] = nama;
    map['nim'] = nim;
    map['nohp'] = nohp;
    map['alamat'] = alamat;
    map['imageBytes'] = imageBytes != null ? base64Encode(imageBytes!) : null;
    
    return map;
  }

  Data.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.nama = map['nama'];
    this.nim = map['nim'];
    this.nohp = map['nohp'];
    this.alamat = map['alamat'];
    this.imageBytes = map['imageBytes'] != null ? base64Decode(map['imageBytes']) : null;
  }
}