import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qr_reader/qrcode_reader_view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scanner/scanViewDemo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  GlobalKey<QrcodeReaderViewState> _key = GlobalKey();
  TabController tabController;
  String qrData = 'welcome in QR Code App';
  String result = "Hey there !";
  TextEditingController qrTextController = TextEditingController();
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: AppBar(
          backgroundColor: Colors.teal,
          bottom: TabBar(
            controller: tabController,
            onTap: (int val) {
              print(val);
            },
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.center_focus_strong,
                  color: Colors.amber,
                  size: 35,
                ),
                text: 'Full Scan',
              ),
              Tab(
                icon: Icon(
                  Icons.create,
                  color: Colors.green,
                  size: 30,
                ),
                text: 'Generate QR',
              ),
              Tab(
                icon: Icon(
                  Icons.fullscreen,
                  color: Colors.blue,
                  size: 35,
                ),
                text: 'Scan',
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          scanonly(context),
          generate(context),
          fullscan(context),
        ],
      ),
    );
  }

  ///generat
  Widget generate(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height / 2.7,
                alignment: Alignment.topCenter,
                child: QrImage(
                  data: qrData,
                  size: 250.0,
                )),
            SizedBox(
              height: 5,
            ),
            Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Text('Enter Your DATA to get QR CODE'),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      maxLines: null,
                      minLines: 2,
                      controller: qrTextController,
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: "Enter Data or Link",
                        contentPadding: const EdgeInsets.only(
                            left: 20, bottom: 20, top: 20),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 3),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 5),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              width: 200,
              margin: EdgeInsets.only(left: 50, right: 50),
              child: FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Generate QR Code ',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1),
                    ),
                    Image(
                      image: AssetImage('assets/img/qrcode.png'),
                      height: 25,
                      width: 25,
                    ),
                  ],
                ),
                onPressed: () {
                  if (qrTextController.text.isEmpty) {
                    setState(() {
                      qrData = 'welcome in QR Code App';
                    });
                  } else {
                    setState(() {
                      qrData = qrTextController.text;
                    });
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: BorderSide(color: Colors.green, width: 5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///scan only

  Future oNScan(String data) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Scan code results"),
          content: Text(data),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("confirm"),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: Text("copy"),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: data));
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
    _key.currentState.startScan();
  }

  Widget scanonly(BuildContext context) {
    return QrcodeReaderView(
      key: _key,
      onScan: oNScan,
      headerWidget: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: FlatButton(
          onPressed: () async {
            Map<PermissionGroup, PermissionStatus> permissions =
                await PermissionHandler()
                    .requestPermissions([PermissionGroup.camera]);
            print(permissions);
            if (permissions[PermissionGroup.camera] ==
                PermissionStatus.granted) {
              showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text("permission"),
                    content: Row(
                      children: <Widget>[
                        Text('Request permission is OK'),
                        Icon(
                          Icons.check,
                          size: 15,
                          color: Color(0xff1974D2),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text("confirm"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );
                },
              );
              setState(() {
                isOk = true;
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.camera_enhance,
                color: Colors.red[900],
                size: 35,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ' permission',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    ' "First" ',
                    style: TextStyle(color: Colors.red[900],fontSize: 20),
                  ),
                  Text(
                    'for Camera',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }

  ///setting(scan2)
  QrReaderViewController _controller;
  bool isOk = false;
  String data;
  void onScan(String v, List<Offset> offsets) {
    print([v, offsets]);
    setState(() {
      data = v;
    });
    _controller.stopCamera();
  }

  Widget fullscan(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                Map<PermissionGroup, PermissionStatus> permissions =
                await PermissionHandler().requestPermissions([PermissionGroup.camera]);
                print(permissions);
                if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return  CupertinoAlertDialog(
                        title: Text("permission"),
                        content: Text('Request permission is OK'),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text("confirm"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                  );
                  setState(() {
                    isOk = true;
                  });
                }
              },
              child: Text('Request permission"First"',style: TextStyle(color: Colors.white),),
              color: Colors.red[900],
            ),

            if (isOk)
              Container(
                width: 320,
                height: 300,
                child: QrReaderView(
                  width: 320,
                  height: 300,
                  callback: (container) {
                    this._controller = container;
                    _controller.startCamera(onScan);
                  },
                ),
              ),
            if (data != null)
              Container(
                height: 150,
                width: 400,
                child: Card(
                  margin: EdgeInsets.all(20),
                  color: Colors.white70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 3.0),
                              borderRadius: BorderRadius.all(Radius.circular(
                                      20.0) //                 <--- border radius here
                                  ),
                            ),
                            height: 90,
                            width: 270,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SelectableText(data),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.content_copy,
                              size: 25,
                            ),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: data));
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScanViewDemo()));
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.fullscreen),
                          Text("Full Screen")
                        ],
                      ),
                    ),
                    FlatButton(
                        onPressed: () async {
                          var image = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (image == null) return;
                          final rest = await FlutterQrReader.imgScan(image);
                          setState(() {
                            data = rest;
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.satellite),
                            Text("scan pictures"),
                          ],
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          assert(_controller != null);
                          _controller.setFlashlight();
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.flash_on),
                            Text("flash"),
                          ],
                        )),
                    FlatButton(
                        onPressed: () {
                          assert(_controller != null);
                          _controller.startCamera(onScan);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.camera),
                            Text(' New Scan"after stop"'),
                          ],
                        )),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
