import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ext_storage/ext_storage.dart';

class BackupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackupScreenBody();
  }
}

class BackupScreenBody extends StatefulWidget {
  @override
  _BackupState createState() => _BackupState();
}

class _BackupState extends State<BackupScreenBody> {
  static const platform =
      const MethodChannel('com.pandacode.rekap_keuangan/database');
  var dir = '';
  @override
  void initState() {
    ExtStorage.getExternalStorageDirectory()
        .then((value) => setState(() => dir = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyScreens().initScreen(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Backup Database'),
          backgroundColor: MyColors.blue,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
            child: Container(
          color: Colors.white,
          child: Container(
              padding: EdgeInsets.all(MyScreens.safeVertical * 2),
              child: ListView(children: <Widget>[
                Text(
                  'Backup Database',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text('Melakukan backup database rekap keuangan Anda.'),
                SizedBox(
                  height: MyScreens.safeVertical * 1,
                ),
                Text('Lokasi Backup: '),
                Text(
                  dir + '/BackupRekapKeuangan/dbrekapkeuangan.sqlite3',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MyScreens.safeVertical * 1,
                ),
                RaisedButton(
                  color: MyColors.blue,
                  child: Text('BACKUP', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (await Permission.storage.request().isGranted) {
                      _backupdatabase();
                    }
                  },
                ),
                SizedBox(
                  height: MyScreens.safeVertical * 2.5,
                ),
                Text(
                  'Restore Database',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text('Mengembalikan data ke saat terakhir melakukan backup'),
                SizedBox(
                  height: MyScreens.safeVertical * 1,
                ),
                RaisedButton(
                  color: MyColors.blue,
                  child: Text(
                    'RESTORE',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (await Permission.storage.request().isGranted) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Peringatan'),
                              content: Text(
                                  'Apakah Anda yakin akan mengembalikan data pada waktu terakhir kali backup?'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Batal'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text('Restore'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _restoredatabase();
                                  },
                                )
                              ],
                            );
                          });
                    }
                  },
                )
              ])),
        )));
  }

  Future<void> _backupdatabase() async {
    try {
      var message = await platform.invokeMethod('backupDatabase');
      Fluttertoast.showToast(msg: message);
    } on PlatformException catch (e) {
      print("Failed to backup: '${e.message}'.");
    }
  }

  Future<void> _restoredatabase() async {
    try {
      var message = await platform.invokeMethod('restoreDatabase');
      Fluttertoast.showToast(msg: message);
    } on PlatformException catch (e) {
      print("Failed to restore: '${e.message}'.");
    }
  }

  // _openDB() async {
  //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String dbpath = join(documentsDirectory.path, "dbrekapkeuangan");
  //   return await openDatabase(dbpath);
  // }
}
