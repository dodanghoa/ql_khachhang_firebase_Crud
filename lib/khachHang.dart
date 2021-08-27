import 'package:firebase_database/firebase_database.dart';

class KhachHang{
  var id,hoTen,diaChi,soDT;
  KhachHang(this.id, this.hoTen, this.diaChi, this.soDT);


  KhachHang.fromSnapshot(DataSnapshot snapshot) :
        id = snapshot.key,
        hoTen = snapshot.value["hoTen"],
        diaChi = snapshot.value["diaChi"],
        soDT = snapshot.value["soDT"];
  @override
  String toString() {
    return 'KhachHang{id: $id, hoTen: $hoTen, diaChi: $diaChi, soDT: $soDT}';
  }

  factory KhachHang.fromJson(Map<dynamic, dynamic> json) =>
      KhachHang(json['id'], json['hoTen'], json['diaChi'], json['soDT']);
}