import 'dart:core';
import 'package:sqflite/sqflite.dart';
import 'package:rekap_keuangan/repositories/db_helper.dart';

class Dompet {
  var kddompet,
      namadompet,
      saldo,
      catatan,
      codepoint,
      fontfamily,
      fontpackage,
      color;
  Dompet(
      {this.kddompet,
      this.namadompet,
      this.catatan,
      this.saldo,
      this.codepoint,
      this.fontfamily,
      this.fontpackage,
      this.color});

  Dompet.fromMap(Map<String, dynamic> map)
      : kddompet = map['kddompet'],
        namadompet = map['namadompet'],
        saldo = map['saldo'],
        catatan = map['catatan'],
        codepoint = map['codepoint'],
        fontfamily = map['fontfamily'],
        fontpackage = map['fontpackage'],
        color = map['color'];

  Map<String, dynamic> toMap() => {
        "kddompet": kddompet,
        "namadompet": namadompet,
        "saldo": saldo,
        "catatan": catatan,
        "codepoint": codepoint,
        "fontfamily": fontfamily,
        "fontpackage": fontpackage,
        "color": color
      };

  Future<int> insertdompet(Dompet dompet) async {
    Database db = await DatabaseHelper.instance.database;
    print('masukinsert');
    print(dompet.toMap());

    var result = await db.insert("dompet", dompet.toMap());
    print('rs: ' + result.toString());
    return result;
    //print('result: ' + result.toString());
  }

  Future<void> updatedompet(Dompet dompet) async {
    Database db = await DatabaseHelper.instance.database;
    print(dompet.toMap());
    print(dompet.kddompet);
    //await db.update("dompet", dompet.toMap(),where: 'kddompet=?',whereArgs: [dompet.kddompet]);
    await db.rawUpdate(
        "UPDATE dompet set namadompet=?,catatan=?,codepoint=?,fontfamily=?,fontpackage=?,color=? WHERE kddompet=?",
        [
          dompet.namadompet,
          dompet.catatan,
          dompet.codepoint,
          dompet.fontfamily,
          dompet.fontpackage,
          dompet.color,
          dompet.kddompet
        ]);
  }

  Future<void> deletedompet(_kddompet) async {
    Database db = await DatabaseHelper.instance.database;
    await db.rawDelete("DELETE FROM dompet WHERE kddompet=?", [_kddompet]);
  }

  Future<List> getalldompet() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery("SELECT * FROM dompet");
    return result;
  }

  Future<List> getdatadompet(_kddompet) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db
        .rawQuery("SELECT * FROM dompet WHERE kddompet = ?", [_kddompet]);
    return result;
  }

  Future<List> getdatadompetsumsaldo(_kddompet) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT d.kddompet,d.namadompet,d.saldo + IFNULL(SUM(t.masuk),0) - IFNULL(SUM(t.keluar),0) as saldo,d.catatan,"
        " d.codepoint,d.fontfamily,d.fontpackage,d.color FROM dompet d LEFT JOIN transaksi t on d.kddompet = t.kddompet"
        " WHERE d.kddompet = ?",
        [_kddompet]);
    return result;
  }

  Future<List> getalldompetsumsaldo() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT d.kddompet,d.namadompet,d.saldo + IFNULL(SUM(t.masuk),0) - IFNULL(SUM(t.keluar),0) as saldo,d.catatan,"
        " d.codepoint,d.fontfamily,d.fontpackage,d.color FROM dompet d LEFT JOIN transaksi t on d.kddompet = t.kddompet"
        " GROUP BY d.kddompet");
    return result;
  }

  Future<List> sumsaldoawalakhir(_kddompet, _tanggalawal, _tanggalakhir) async {
    Database db = await DatabaseHelper.instance.database;
    var result;
    if (_kddompet == 0) {
      result = await db.rawQuery(
          "SELECT * FROM (SELECT IFNULL(SUM(masuk),0) - IFNULL(SUM(keluar),0) as saldoawal" +
              " FROM transaksi WHERE tanggaltransaksi < ?) a" +
              " JOIN (SELECT IFNULL(SUM(masuk),0) - IFNULL(SUM(keluar),0) as saldoakhir" +
              " FROM transaksi WHERE tanggaltransaksi <= ?) b",
          [_tanggalawal, _tanggalakhir]);
    } else {
      result = await db.rawQuery(
          "SELECT * FROM (SELECT IFNULL(SUM(masuk),0) - IFNULL(SUM(keluar),0) as saldoawal" +
              " FROM transaksi WHERE kddompet = ? AND tanggaltransaksi < ?) a" +
              " JOIN (SELECT IFNULL(SUM(masuk),0) - IFNULL(SUM(keluar),0) as saldoakhir" +
              " FROM transaksi WHERE kddompet = ? AND tanggaltransaksi <= ?) b",
          [_kddompet, _tanggalawal, _kddompet, _tanggalakhir]);
    }
    return result;
  }

  Future<List> sumsaldoperbulan(_kddompet, _arrtanggal) async {
    Database db = await DatabaseHelper.instance.database;
    var result;
    if (_kddompet == 0) {
      result = await db.rawQuery(
          "SELECT b.bulan,IFNULL(SUM(t.masuk),0) - IFNULL(SUM(t.keluar),0) as saldo" +
              " FROM (SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan) b" +
              " LEFT JOIN transaksi t ON strftime('%Y-%m',t.tanggaltransaksi) <= b.bulan GROUP BY b.bulan",
          [
            _arrtanggal[0],
            _arrtanggal[1],
            _arrtanggal[2],
            _arrtanggal[3],
            _arrtanggal[4],
            _arrtanggal[5]
          ]);
    } else {
      result = await db.rawQuery(
          "SELECT b.bulan,IFNULL(SUM(t.masuk),0) - IFNULL(SUM(t.keluar),0) as saldo" +
              " FROM (SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan) b" +
              " LEFT JOIN transaksi t ON strftime('%Y-%m',t.tanggaltransaksi) <= b.bulan" +
              " AND t.kddompet = ? GROUP BY b.bulan",
          [
            _arrtanggal[0],
            _arrtanggal[1],
            _arrtanggal[2],
            _arrtanggal[3],
            _arrtanggal[4],
            _arrtanggal[5],
            _kddompet
          ]);
    }
    return result;
  }

  Future<int> countdompetnama(_namadompet) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT COUNT(*) as JUMLAHDOMPET FROM dompet WHERE namadompet = ?",
        [_namadompet]);
    return result[0]['JUMLAHDOMPET'];
  }

  Future<int> countdompetedit(_kddompet, _namadompet) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT COUNT(*) as JUMLAHDOMPET FROM dompet WHERE namadompet = ? AND kddompet<>?",
        [_namadompet, _kddompet]);
    return result[0]['JUMLAHDOMPET'];
  }

  Future<double> sumdompet() async {
    Database db = await DatabaseHelper.instance.database;
    var result =
        await db.rawQuery("SELECT IFNULL(SUM(saldo),0) as saldo FROM dompet");
    if (result.length > 0) {
      return result[0]['saldo'];
    } else {
      return 0;
    }
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
