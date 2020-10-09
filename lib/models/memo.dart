import 'dart:core';
import 'package:sqflite/sqflite.dart';
import 'package:rekap_keuangan/repositories/db_helper.dart';

class Memo {
  var kdmemo, judul, tanggalbuat;

  Memo({this.kdmemo, this.judul, this.tanggalbuat});

  Memo.fromMap(Map<String, dynamic> map)
      : kdmemo = map['kdmemo'],
        judul = map['judul'],
        tanggalbuat = map['tanggalbuat'];

  Map<String, dynamic> toMap() => {
        "kdmemo": kdmemo,
        "judul": judul,
        "tanggalbuat": tanggalbuat,
      };

  Future<int> insertmemo(Memo memo) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.insert("memo", memo.toMap());
  }

  Future<void> updatememo(Memo memo) async {
    Database db = await DatabaseHelper.instance.database;
    //await db.update("memo", memo.toMap(),where: 'kdmemo=?',whereArgs: [memo.kdmemo]);
    await db.rawUpdate(
        "UPDATE memo set judul=? WHERE kdmemo=?", [memo.judul, memo.kdmemo]);
  }

  Future<void> deletememo(_kdmemo) async {
    Database db = await DatabaseHelper.instance.database;
    await db.rawDelete("DELETE FROM detailmemo WHERE kdmemo=?", [_kdmemo]);
    await db.rawDelete("DELETE FROM memo WHERE kdmemo=?", [_kdmemo]);
  }

  Future<List> getallmemo() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery("SELECT * FROM memo");
    return result;
  }

  Future<List> getdatamemo(_kdmemo) async {
    Database db = await DatabaseHelper.instance.database;
    var result =
        await db.rawQuery("SELECT * FROM memo WHERE kdmemo = ?", [_kdmemo]);
    return result;
  }

  Future<List> getallmemocountdetail() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery("SELECT m.*,count(u.kdmemo) as checked "
        "FROM (SELECT m.*,count(d.kdmemo) as jumlah,IFNULL(SUM(d.total),0) as total FROM memo m "
        "LEFT JOIN detailmemo d ON m.kdmemo = d.kdmemo GROUP BY m.kdmemo) m "
        "LEFT JOIN detailmemo u ON m.kdmemo = u.kdmemo AND u.status = 1 "
        "GROUP BY m.kdmemo");
    return result;
  }

  Future<int> countmemojudul(_judul) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT COUNT(*) as JUMLAHMEMO FROM memo WHERE judul = ?", [_judul]);
    return result[0]['JUMLAHMEMO'];
  }

  Future<int> countmemoedit(_kdmemo, _judul) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT COUNT(*) as JUMLAHMEMO FROM memo WHERE memo = ? AND kdmemo<>?",
        [_judul, _kdmemo]);
    return result[0]['JUMLAHMEMO'];
  }
  // Future<int> insertTrack(Device device) async {
  //   Database db = await DatabaseHelper.instance.database;
  //   return await db.insert("Tracks", device.toJSON());
  // }
  // Future<List> getAllLastTrack() async {
  //   Database db = await DatabaseHelper.instance.database;
  //   var result = await db.rawQuery("SELECT * FROM tracks t WHERE id in (SELECT max(id) FROM tracks GROUP BY device_sn)");
  //   return result.toList();
  // }
}
