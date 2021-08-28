import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ql_khachhang/thongtinkhachhang.dart';
import 'khachHang.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

TextStyle _titlestyle =
    TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
TextStyle _subtitlestyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        "/ThongTinKhachHang": (BuildContext context) => new InfoPage(
              khachHang: new KhachHang("", "", "", ""),
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<KhachHang> display = [];
  final _database = FirebaseDatabase.instance.reference();
  late var _databaseRef;

  TextEditingController _searchcontroller = TextEditingController();
  int _counter = 0;
  List<KhachHang> data = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      LoadData();
    }
  }

  LoadData() {
    _databaseRef = _database.child("DSKhachHang").get().then((value) => {
          data = _parseData(value),
          setState(() {
            display = data;
          })
        });
  }

  @override
  void initState() {
    LoadData();
  }

  List<KhachHang> _parseData(DataSnapshot dataSnapshot) {
    var companyList = <KhachHang>[];
    if (dataSnapshot.exists) {
      var mapOfMaps = Map<String, dynamic>.from(dataSnapshot.value);
      mapOfMaps.values.forEach((value) {
        companyList.add(KhachHang.fromJson(Map.from(value)));
      });
    } else {
      return [];
    }
    return companyList;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  ListView _builderListveiw() {
    int index = 0;
    return ListView.builder(
        padding: EdgeInsets.all(10),
        key: UniqueKey(),
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: display.length,
        itemBuilder: (context, index) {
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: (index - 1) % 2 == 0 ? Colors.blueAccent : Colors.cyan,
              elevation: 10,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      size: 50,
                    ),
                    title: Text(
                      "Họ Tên : " + display[index].hoTen,
                      style: _titlestyle,
                    ),
                    subtitle: Text(
                      "Địa chỉ : " +
                          display[index].diaChi +
                          "\nSố điện thọai : " +
                          display[index].soDT,
                      style: _subtitlestyle,
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      //add some actions, icons...etc
                      new RaisedButton(
                        color: Colors.green,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoPage(
                                  khachHang: display[index],
                                ),
                              )).then((value) => LoadData());
                        },
                        child: new Text(
                          "Sửa",
                          style: new TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      new RaisedButton(
                          color: Colors.red,
                          onPressed: () {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Thông báo'),
                                  content: const Text('Xác nhận xóa?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => {
                                        _database
                                            .child("DSKhachHang")
                                            .child(data[index].id.toString())
                                            .remove(),
                                       Navigator.pop(context),
                                          LoadData()
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),);
                          },
                          child: new Text(
                            "Xóa",
                            style: new TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                ],
              ));
        });
  }

  void onDismiss() {
    print('Menu is dismiss');
  }

  List<Widget> renderDrawer() {
    return [
      DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                maxRadius: 50,
                child: Image.network(
                    "https://cdn3.iconfinder.com/data/icons/avatars-round-flat/33/avat-01-512.png"),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Text(
                "Google Assistant",
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          )),
      ListTile(
        leading: Icon(Icons.info),
        title: const Text(
          'Thông tin chi tiết',
          style: TextStyle(fontSize: 16),
        ),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: const Text(
          'Cài đặt',
          style: TextStyle(fontSize: 16),
        ),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.help_center),
        title: const Text(
          'Help center',
          style: TextStyle(fontSize: 16),
        ),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          Navigator.pop(context);
        },
      ),
      ListTile(
        selected: true,
        leading: Icon(Icons.logout),
        title: const Text(
          'Đăng xuất',
          style: TextStyle(fontSize: 16),
        ),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          Navigator.pop(context);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khách hàng'),
        actions: [
          Icon(Icons.favorite),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.search),
          ),
          Icon(Icons.more_vert),
        ],
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: renderDrawer(),
      )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(5)),
            TextField(
              controller: _searchcontroller,
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "Tìm kiếm",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (text) {
                if (text.isEmpty) {
                  setState(() {
                    display = List.from(data);
                  });
                } else {
                  setState(() {
                    display = data
                        .where((element) =>
                            element.hoTen
                                .toString()
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            element.hoTen
                                .toString()
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            element.diaChi
                                .toString()
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            element.soDT
                                .toString()
                                .toLowerCase()
                                .contains(text.toLowerCase()))
                        .toList();
                  });
                }
                print(display.length);
              },
            ),
            _builderListveiw(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed("/ThongTinKhachHang")
              .then((value) => LoadData());
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
