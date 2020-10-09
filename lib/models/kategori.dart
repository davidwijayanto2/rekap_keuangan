import 'dart:core';
import 'package:sqflite/sqflite.dart';
import 'package:rekap_keuangan/repositories/db_helper.dart';

class Kategori {
  var kdkategori,
      namakategori,
      jenis,
      codepoint,
      fontfamily,
      fontpackage,
      color;
  Kategori(
      {this.kdkategori,
      this.namakategori,
      this.jenis,
      this.codepoint,
      this.fontfamily,
      this.fontpackage,
      this.color});

  Kategori.fromMap(Map<String, dynamic> map)
      : kdkategori = map['kdkategori'],
        namakategori = map['namakategori'],
        jenis = map['jenis'],
        codepoint = map['codepoint'],
        fontfamily = map['fontfamily'],
        fontpackage = map['fontpackage'],
        color = map['color'];

  Map<String, dynamic> toMap() => {
        "kdkategori": kdkategori,
        "namakategori": namakategori,
        "jenis": jenis,
        "codepoint": codepoint,
        "fontfamily": fontfamily,
        "fontpackage": fontpackage,
        "color": color
      };

  Future<void> insertkategori(Kategori kategori) async {
    Database db = await DatabaseHelper.instance.database;
    await db.insert("kategori", kategori.toMap());
  }

  Future<void> updatekategori(Kategori kategori) async {
    Database db = await DatabaseHelper.instance.database;
    //await db.update("dompet", dompet.toMap(),where: 'kddompet=?',whereArgs: [dompet.kddompet]);
    await db.rawUpdate(
        "UPDATE kategori set namakategori=?,codepoint=?,fontfamily=?,fontpackage=?,color=? WHERE kdkategori=?",
        [
          kategori.namakategori,
          kategori.codepoint,
          kategori.fontfamily,
          kategori.fontpackage,
          kategori.color,
          kategori.kdkategori
        ]);
  }

  Future<void> deletekategori(_kdkategori) async {
    Database db = await DatabaseHelper.instance.database;
    await db
        .rawDelete("DELETE FROM kategori WHERE kdkategori=?", [_kdkategori]);
  }

  Future<List> getallkategori() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery("SELECT * FROM kategori");
    return result;
  }

  Future<List> getdatakategori(_kdkategori) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db
        .rawQuery("SELECT * FROM kategori WHERE kdkategori = ?", [_kdkategori]);
    return result;
  }

  Future<List> getkategorimasuk() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery("SELECT * FROM kategori WHERE jenis = 'm'");
    return result;
  }

  Future<List> getkategorikeluar() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery("SELECT * FROM kategori WHERE jenis = 'k'");
    return result;
  }

  Future<int> countkategorinama(_namakategori) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT COUNT(*) as jumlahkategori FROM kategori WHERE namakategori = ?",
        [_namakategori]);
    return result[0]['jumlahkategori'];
  }

  Future<int> countkategoriedit(_kdkategori, _namakategori) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT COUNT(*) as jumlahkategori FROM kategori WHERE namakategori = ? AND kdkategori <>?",
        [_namakategori, _kdkategori]);
    return result[0]['jumlahkategori'];
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
