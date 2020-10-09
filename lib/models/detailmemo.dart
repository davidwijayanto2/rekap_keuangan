import 'dart:core';
import 'package:sqflite/sqflite.dart';
import 'package:rekap_keuangan/repositories/db_helper.dart';

class DetailMemo {
  var kddetailmemo, kdmemo, namadmemo, total, status;

  DetailMemo(
      {this.kddetailmemo,
      this.kdmemo,
      this.namadmemo,
      this.total,
      this.status});

  DetailMemo.fromMap(Map<String, dynamic> map)
      : kddetailmemo = map['kddetailmemo'],
        kdmemo = map['kdmemo'],
        namadmemo = map['namadmemo'],
        total = map['total'],
        status = map['status'];

  Map<String, dynamic> toMap() => {
        "kddetailmemo": kddetailmemo,
        "kdmemo": kdmemo,
        "namadmemo": namadmemo,
        "total": total,
        "status": status,
      };

  Future<void> insertdetailmemo(DetailMemo dmemo) async {
    Database db = await DatabaseHelper.instance.database;
    await db.insert("detailmemo", dmemo.toMap());
  }

  Future<void> updatedetailmemo(DetailMemo dmemo) async {
    Database db = await DatabaseHelper.instance.database;
    //await db.update("memo", memo.toMap(),where: 'kdmemo=?',whereArgs: [memo.kdmemo]);
    await db.rawUpdate(
        "UPDATE detailmemo set namadmemo=?,total=? WHERE kddetailmemo=?",
        [dmemo.namadmemo, dmemo.total, dmemo.kddetailmemo]);
  }

  Future<void> updatestatusdetailmemo(DetailMemo dmemo) async {
    Database db = await DatabaseHelper.instance.database;
    await db.rawUpdate("UPDATE detailmemo set status=? WHERE kddetailmemo=?",
        [dmemo.status, dmemo.kddetailmemo]);
  }

  Future<void> deletedetailmemo(_kddetailmemo) async {
    Database db = await DatabaseHelper.instance.database;
    await db.delete("detailmemo",
        where: '$kddetailmemo=?', whereArgs: [_kddetailmemo]);
  }

  Future<void> deletealldetailmemo(_kdmemo) async {
    Database db = await DatabaseHelper.instance.database;
    await db.delete("detailmemo", where: '$kdmemo=?', whereArgs: [_kdmemo]);
  }

  Future<List> getalldetailmemo() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery("SELECT * FROM detailmemo");
    return result;
  }

  Future<List> getdatadetailmemo(_kdmemo) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db
        .rawQuery("SELECT * FROM detailmemo WHERE kdmemo = ?", [_kdmemo]);
    return result;
  }

  Future<int> countcheckeddetailmemo(_kdmemo) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT COUNT(*) as jumlah FROM detailmemo WHERE kdmemo = ? AND status = 1",
        [_kdmemo]);
    return result[0]['jumlah'];
  }

  Future<int> countuncheckeddetailmemo(_kdmemo) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT COUNT(*) as jumlah FROM detailmemo WHERE kdmemo = ? AND status = 0",
        [_kdmemo]);
    return result[0]['jumlah'];
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
