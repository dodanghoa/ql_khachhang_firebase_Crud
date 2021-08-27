import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ql_khachhang/khachHang.dart';
import 'package:uuid/uuid.dart';

class InfoPage extends StatefulWidget {
  KhachHang khachHang ;
  InfoPage({Key? key,required this.khachHang}) : super(key: key);
  @override
  _InfoPage createState() => _InfoPage(khachHang: khachHang);
}

class _InfoPage extends State<InfoPage> with InputValidationMixin{
  final _formKey = GlobalKey<FormState>();
  _InfoPage({required this.khachHang});
  final _database = FirebaseDatabase.instance.reference();
  late final _databaseRef ;
  late KhachHang khachHang ;
  int _counter = 0;
  @override
  void initState() {
    _databaseRef = _database.child("DSKhachHang");
    // TODO: implement initState
    super.initState();
    _hotencontroller.text = khachHang.hoTen;
    _sdtcontroller.text = khachHang.soDT;
    _diachicontroller.text = khachHang.diaChi;
  }
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  TextEditingController _hotencontroller = TextEditingController();
  TextEditingController _diachicontroller = TextEditingController();
  TextEditingController _sdtcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Thông tin khách hàng"),
      ),
      body: Form(
        key: _formKey,
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10)),
            TextFormField(
              controller: _hotencontroller,
              autofocus: false,
              decoration: InputDecoration(
                hintText: "Họ và tên",
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (isEmty(value!))
                  return null;
                else
                  return 'Vui lòng nhập tên';
              },
            ),
            Padding(padding: EdgeInsets.all(10)),
            TextFormField(
              controller: _sdtcontroller,
              autofocus: false,
              decoration: InputDecoration(
                hintText: "Số điện thoại",
                prefixIcon: Icon(Icons.phone_android),
              ),
              validator: (value) {
                if (isPhoneValid(value!))
                  return null;
                else
                  return 'Số điện thoại không hợp lệ';
              },
            ),
            Padding(padding: EdgeInsets.all(10)),
            TextFormField(
              controller: _diachicontroller,
              autofocus: false,
              decoration: InputDecoration(
                hintText: "Địa chỉ",
                prefixIcon: Icon(Icons.location_city),
              ),
              validator: (value) {
                if (isEmty(value!))
                  return null;
                else
                  return 'Vui lòng nhập địa chỉ';
              },
            ),
            Padding(padding: EdgeInsets.all(10)),
            RaisedButton(
              onPressed: () {
                if(_formKey.currentState!.validate())
                  {
                    if(khachHang.id=="")
                      {
                        var uuid = Uuid();
                        var id = uuid.v1();
                        _databaseRef.child(id).set(<String, String>{'id': id,
                          'hoTen': _hotencontroller.text ,
                          'diaChi': _diachicontroller.text,
                          'soDT':_sdtcontroller.text,
                        });
                      }
                    else{
                      _databaseRef.child(khachHang.id).set(<String, String>{'id': khachHang.id,
                        'hoTen': _hotencontroller.text ,
                        'diaChi': _diachicontroller.text,
                        'soDT':_sdtcontroller.text,
                      });
                    }

                  }
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("Lưu thông tin",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold ),),
              padding: EdgeInsets.fromLTRB(40,20,40,20),
            )
          ],
        ),
      )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

mixin InputValidationMixin {
  bool isEmty(String text) => !text.isEmpty;
  bool isPasswordValid(String password) => password.length > 6;
  bool isrePasswordValid(String password,String repassword) => password.length > 6 &&password==repassword;
  bool isPhoneValid(String phone) {
    RegExp regex = new RegExp(
        r"^([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{3})");
    return regex.hasMatch(phone);
  }
}
