import 'package:sqflite/sqflite.dart';
import 'package:rekap_keuangan/repositories/db_helper.dart';

class Transaksi {
  var idtransaksi,
      kdtransaksi,
      kdkategori,
      kddompet,
      tanggaltransaksi,
      keluar,
      masuk,
      catatan,
      foto;

  Transaksi(
      {this.idtransaksi,
      this.kdtransaksi,
      this.kdkategori,
      this.kddompet,
      this.tanggaltransaksi,
      this.keluar,
      this.masuk,
      this.catatan,
      this.foto});

  Transaksi.fromMap(Map<String, dynamic> map)
      : idtransaksi = map['idtransaksi'],
        kdtransaksi = map['kdtransaksi'],
        kdkategori = map['kdkategori'],
        kddompet = map['kddompet'],
        tanggaltransaksi = map['tanggaltransaksi'],
        keluar = map['keluar'],
        masuk = map['masuk'],
        catatan = map['catatan'],
        foto = map['foto'];

  Map<String, dynamic> toMap() => {
        "idtransaksi": idtransaksi,
        "kdtransaksi": kdtransaksi,
        "kdkategori": kdkategori,
        "kddompet": kddompet,
        "tanggaltransaksi": tanggaltransaksi,
        "keluar": keluar,
        "masuk": masuk,
        "catatan": catatan,
        "foto": foto
      };
  Future<void> inserttransaksi(Transaksi transaksi) async {
    Database db = await DatabaseHelper.instance.database;
    await db.rawInsert(
        "INSERT INTO transaksi(kdtransaksi,kdkategori,kddompet,tanggaltransaksi,"
        "keluar,masuk,catatan,foto) VALUES(?,?,?,?,?,?,?,?)",
        [
          transaksi.kdtransaksi,
          transaksi.kdkategori,
          transaksi.kddompet,
          transaksi.tanggaltransaksi,
          transaksi.keluar,
          transaksi.masuk,
          transaksi.catatan,
          transaksi.foto
        ]);
  }

  Future<void> inserttransaksitransfer(
      Transaksi transaksiasal, Transaksi transaksitujuan) async {
    Database db = await DatabaseHelper.instance.database;
    await db.rawInsert(
        "INSERT INTO transaksi(kdtransaksi,kdkategori,kddompet,tanggaltransaksi,"
        "keluar,masuk,catatan,foto) VALUES(?,?,?,?,?,?,?,?)",
        [
          transaksiasal.kdtransaksi,
          transaksiasal.kdkategori,
          transaksiasal.kddompet,
          transaksiasal.tanggaltransaksi,
          transaksiasal.keluar,
          transaksiasal.masuk,
          transaksiasal.catatan,
          transaksiasal.foto
        ]);
    await db.rawInsert(
        "INSERT INTO transaksi(kdtransaksi,kdkategori,kddompet,tanggaltransaksi,"
        "keluar,masuk,catatan,foto) VALUES(?,?,?,?,?,?,?,?)",
        [
          transaksitujuan.kdtransaksi,
          transaksitujuan.kdkategori,
          transaksitujuan.kddompet,
          transaksitujuan.tanggaltransaksi,
          transaksitujuan.keluar,
          transaksitujuan.masuk,
          transaksitujuan.catatan,
          transaksitujuan.foto
        ]);
  }

  Future<void> deletetransaksi(_kdtransaksi) async {
    Database db = await DatabaseHelper.instance.database;
    await db
        .rawDelete("DELETE FROM transaksi WHERE kdtransaksi=?", [_kdtransaksi]);
  }

  Future<void> updatetransaksi(Transaksi transaksi) async {
    Database db = await DatabaseHelper.instance.database;
    await db.rawUpdate(
        "UPDATE transaksi SET kdkategori=?,kddompet=?,tanggaltransaksi=?,keluar=?,masuk=?,catatan=?,foto=? "
        "WHERE kdtransaksi=?",
        [
          transaksi.kdkategori,
          transaksi.kddompet,
          transaksi.tanggaltransaksi,
          transaksi.keluar,
          transaksi.masuk,
          transaksi.catatan,
          transaksi.foto,
          transaksi.kdtransaksi
        ]);
  }

  Future<void> updatetransaksitransfer(
      Transaksi transaksi, Transaksi transaksi2) async {
    Database db = await DatabaseHelper.instance.database;

    await db.rawUpdate(
        "UPDATE transaksi SET kddompet=?,tanggaltransaksi=?,keluar=?,masuk=?,catatan=? "
        "WHERE idtransaksi=?",
        [
          transaksi.kddompet,
          transaksi.tanggaltransaksi,
          transaksi.keluar,
          transaksi.masuk,
          transaksi.catatan,
          transaksi.idtransaksi
        ]);
    await db.rawUpdate(
        "UPDATE transaksi SET tanggaltransaksi=?,keluar=?,masuk=? "
        "WHERE idtransaksi=?",
        [
          transaksi2.tanggaltransaksi,
          transaksi2.keluar,
          transaksi2.masuk,
          transaksi2.idtransaksi
        ]);
  }

  Future<void> deletetransaksikategori(_kdkategori) async {
    Database db = await DatabaseHelper.instance.database;
    await db
        .rawDelete("DELETE FROM transaksi WHERE kdkategori=?", [_kdkategori]);
  }

  Future<void> deletetransaksidompet(_kddompet) async {
    Database db = await DatabaseHelper.instance.database;
    await db.rawDelete("DELETE FROM transaksi WHERE kddompet=?", [_kddompet]);
  }

  Future<int> getkdtransaksi() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT kdtransaksi FROM transaksi ORDER BY kdtransaksi DESC LIMIT 1");
    if (result.length > 0) {
      return result[0]['kdtransaksi'];
    }
    return 0;
  }

  Future<List> getdatatransaksiid(_idtransaksi) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT t.*,d.namadompet,d.codepoint as codepointdompet,d.fontfamily as fontfamilydompet, " +
            "d.fontpackage as fontpackagedompet,d.color as colordompet,k.namakategori,k.jenis,k.codepoint as codepointkategori, " +
            "k.fontfamily as fontfamilykategori, k.fontpackage as fontpackagekategori,k.color as colorkategori " +
            "FROM transaksi t JOIN dompet d ON t.kddompet = d.kddompet " +
            "JOIN kategori k ON t.kdkategori = k.kdkategori WHERE t.idtransaksi = ?",
        [_idtransaksi]);
    return result;
  }

  Future<List> getdatatransaksikd(_kdtransaksi, _idtransaksi) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT t.*,d.namadompet,d.codepoint as codepointdompet,d.fontfamily as fontfamilydompet, " +
            "d.fontpackage as fontpackagedompet,d.color as colordompet,k.namakategori,k.codepoint as codepointkategori, " +
            "k.fontfamily as fontfamilykategori, k.fontpackage as fontpackagekategori,k.color as colorkategori " +
            "FROM transaksi t JOIN dompet d ON t.kddompet = d.kddompet " +
            "JOIN kategori k ON t.kdkategori = k.kdkategori WHERE t.kdtransaksi = ? AND t.idtransaksi <> ?",
        [_kdtransaksi, _idtransaksi]);
    return result;
  }

  Future<List> getalltransaksi() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery("SELECT * FROM transaksi");
    return result;
  }

  Future<List> gettransaksi() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery("SELECT * FROM transaksi");
    return result;
  }

  Future<List> gettransaksikategori(
      _kddompet, _kdkategori, _tanggalmulai, _tanggalakhir) async {
    Database db = await DatabaseHelper.instance.database;
    var result;
    if (_kddompet == 0) {
      result = await db.rawQuery(
          "SELECT t.*,k.codepoint,k.namakategori,k.jenis,k.fontfamily,k.fontpackage,k.color FROM transaksi t " +
              "JOIN kategori k ON t.kdkategori = k.kdkategori WHERE t.kdkategori = ? AND t.tanggaltransaksi BETWEEN ? AND ? " +
              "ORDER BY t.tanggaltransaksi DESC,t.idtransaksi",
          [_kdkategori, _tanggalmulai, _tanggalakhir]);
    } else {
      result = await db.rawQuery(
          "SELECT t.*,k.codepoint,k.namakategori,k.jenis,k.fontfamily,k.fontpackage,k.color FROM transaksi t " +
              "JOIN kategori k ON t.kdkategori = k.kdkategori WHERE t.kddompet = ? AND t.kdkategori = ? " +
              "AND t.tanggaltransaksi BETWEEN ? AND ? ORDER BY t.tanggaltransaksi DESC,t.idtransaksi",
          [_kddompet, _kdkategori, _tanggalmulai, _tanggalakhir]);
    }
    return result;
  }

  Future<List> gettransaksikategoricolumn(
      _kddompet, _tanggalmulai, _tanggalakhir) async {
    Database db = await DatabaseHelper.instance.database;
    var result;
    if (_kddompet == 0) {
      result = await db.rawQuery(
          "SELECT t.*,k.codepoint,k.namakategori,k.jenis,k.fontfamily,k.fontpackage,k.color FROM transaksi t " +
              "JOIN kategori k ON t.kdkategori = k.kdkategori WHERE t.tanggaltransaksi BETWEEN ? AND ? " +
              "ORDER BY t.tanggaltransaksi DESC,t.idtransaksi",
          [_tanggalmulai, _tanggalakhir]);
    } else {
      result = await db.rawQuery(
          "SELECT t.*,k.codepoint,k.namakategori,k.jenis,k.fontfamily,k.fontpackage,k.color FROM transaksi t " +
              "JOIN kategori k ON t.kdkategori = k.kdkategori WHERE t.kddompet = ? AND " +
              "t.tanggaltransaksi BETWEEN ? AND ? ORDER BY t.tanggaltransaksi DESC,t.idtransaksi",
          [_kddompet, _tanggalmulai, _tanggalakhir]);
    }
    return result;
  }

  Future<List> sumtransaksitanggal(
      _kddompet, _tanggalmulai, _tanggalakhir) async {
    Database db = await DatabaseHelper.instance.database;
    var result;
    if (_kddompet == 0) {
      result = await db.rawQuery(
          "SELECT tanggaltransaksi,(IFNULL(SUM(masuk),0)-IFNULL(SUM(keluar),0)) as sumtransaksi FROM transaksi " +
              "WHERE tanggaltransaksi BETWEEN ? AND ? GROUP BY tanggaltransaksi ORDER BY tanggaltransaksi DESC",
          [_tanggalmulai, _tanggalakhir]);
    } else {
      result = await db.rawQuery(
          "SELECT tanggaltransaksi,(IFNULL(SUM(masuk),0)-IFNULL(SUM(keluar),0)) as sumtransaksi FROM transaksi " +
              "WHERE kddompet=? AND tanggaltransaksi BETWEEN ? AND ? GROUP BY tanggaltransaksi ORDER BY tanggaltransaksi DESC",
          [_kddompet, _tanggalmulai, _tanggalakhir]);
    }
    return result;
  }

  Future<List> sumtransaksi(_kddompet, _tanggalmulai, _tanggalakhir) async {
    Database db = await DatabaseHelper.instance.database;
    var result;
    if (_kddompet == 0) {
      result = await db.rawQuery(
          "SELECT IFNULL(SUM(masuk),0) as summasuk,IFNULL(SUM(keluar),0) as sumkeluar FROM transaksi " +
              "WHERE tanggaltransaksi BETWEEN ? AND ?",
          [_tanggalmulai, _tanggalakhir]);
    } else {
      result = await db.rawQuery(
          "SELECT IFNULL(SUM(masuk),0) as summasuk,IFNULL(SUM(keluar),0) as sumkeluar FROM transaksi " +
              "WHERE kddompet = ? AND tanggaltransaksi BETWEEN ? AND ?",
          [_kddompet, _tanggalmulai, _tanggalakhir]);
    }
    return result;
  }

  Future<List> sumtransaksinontransfer(
      _kddompet, _tanggalmulai, _tanggalakhir) async {
    Database db = await DatabaseHelper.instance.database;
    var result;
    if (_kddompet == 0) {
      result = await db.rawQuery(
          "SELECT IFNULL(SUM(t.masuk),0) as summasuk,IFNULL(SUM(t.keluar),0) as sumkeluar FROM transaksi t" +
              " JOIN kategori k ON t.kdkategori = k.kdkategori" +
              " AND k.jenis <> 't' WHERE t.tanggaltransaksi BETWEEN ? AND ?",
          [_tanggalmulai, _tanggalakhir]);
    } else {
      result = await db.rawQuery(
          "SELECT IFNULL(SUM(t.masuk),0) as summasuk, IFNULL(SUM(t.keluar),0) as sumkeluar FROM transaksi t" +
              " JOIN kategori k ON t.kdkategori = k.kdkategori" +
              " AND k.jenis <> 't' WHERE t.kddompet = ? AND t.tanggaltransaksi BETWEEN ? AND ?",
          [_kddompet, _tanggalmulai, _tanggalakhir]);
    }
    return result;
  }

  Future<List> sumtransaksitransfer(
      _kddompet, _tanggalmulai, _tanggalakhir) async {
    Database db = await DatabaseHelper.instance.database;
    var result;
    if (_kddompet == 0) {
      result = await db.rawQuery(
          "SELECT IFNULL(SUM(t.masuk),0) - IFNULL(SUM(t.keluar),0) as sumtransfer FROM transaksi t" +
              " JOIN kategori k ON t.kdkategori = k.kdkategori" +
              " AND k.jenis = 't' WHERE t.tanggaltransaksi BETWEEN ? AND ?",
          [_tanggalmulai, _tanggalakhir]);
    } else {
      result = await db.rawQuery(
          "SELECT IFNULL(SUM(t.masuk),0) - IFNULL(SUM(t.keluar),0) as sumtransfer FROM transaksi t" +
              " JOIN kategori k ON t.kdkategori = k.kdkategori" +
              " AND k.jenis = 't' WHERE t.kddompet = ? AND t.tanggaltransaksi BETWEEN ? AND ?",
          [_kddompet, _tanggalmulai, _tanggalakhir]);
    }
    return result;
  }

  Future<List> sumtransaksinontransferperbulan(_kddompet, _arrtanggal) async {
    Database db = await DatabaseHelper.instance.database;
    var result;
    if (_kddompet == 0) {
      result = await db.rawQuery(
          "SELECT b.bulan,IFNULL(SUM(t.masuk),0) as summasuk,IFNULL(SUM(t.keluar),0) as sumkeluar" +
              " FROM (SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan) b" +
              " LEFT JOIN transaksi t ON b.bulan = strftime('%Y-%m',t.tanggaltransaksi)" +
              " LEFT JOIN kategori k ON t.kdkategori = k.kdkategori AND k.jenis <> 't'" +
              " GROUP BY b.bulan",
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
          "SELECT b.bulan,IFNULL(SUM(t.masuk),0) as summasuk,IFNULL(SUM(t.keluar),0) as sumkeluar" +
              " FROM (SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan UNION" +
              " SELECT ? as bulan) b" +
              " LEFT JOIN transaksi t ON b.bulan = strftime('%Y-%m',t.tanggaltransaksi)" +
              " LEFT JOIN kategori k ON t.kdkategori = k.kdkategori AND k.jenis <> 't'" +
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
    print(result.toString());
    return result;
  }

  Future<List> sumtransaksisemuadompet() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT IFNULL(SUM(masuk),0) as summasuk,IFNULL(SUM(keluar),0) as sumkeluar FROM transaksi");
    return result;
  }

  Future<List> sumtransaksiperdompet(_kddompet) async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery(
        "SELECT IFNULL(SUM(masuk),0) as summasuk,IFNULL(SUM(keluar),0) as sumkeluar FROM transaksi WHERE kddompet = ?",
        [_kddompet]);
    return result;
  }

  Future<List> sumtransaksikategori(
      _kddompet, _kdkategori, _tanggalmulai, _tanggalakhir) async {
    Database db = await DatabaseHelper.instance.database;
    var result;
    if (_kddompet == 0) {
      result = await db.rawQuery(
          "SELECT k.codepoint,k.namakategori,k.jenis,k.fontfamily,k.fontpackage,k.color," +
              " IFNULL(SUM(t.masuk),0) as summasuk,IFNULL(SUM(t.keluar),0) as sumkeluar, t.tanggaltransaksi" +
              " FROM transaksi t JOIN kategori k ON t.kdkategori = k.kdkategori WHERE t.kdkategori = ? AND t.tanggaltransaksi BETWEEN ? AND ?" +
              " GROUP BY t.tanggaltransaksi ORDER BY t.tanggaltransaksi DESC",
          [_kdkategori, _tanggalmulai, _tanggalakhir]);
    } else {
      result = await db.rawQuery(
          "SELECT k.codepoint,k.namakategori,k.jenis,k.fontfamily,k.fontpackage,k.color," +
              " IFNULL(SUM(t.masuk),0) as summasuk,IFNULL(SUM(t.keluar),0) as sumkeluar, t.tanggaltransaksi" +
              " FROM transaksi t JOIN kategori k ON t.kdkategori = k.kdkategori WHERE t.kddompet = ?" +
              " AND t.kdkategori = ? AND t.tanggaltransaksi BETWEEN ? AND ?" +
              " GROUP BY t.tanggaltransaksi ORDER BY t.tanggaltransaksi DESC",
          [_kddompet, _kdkategori, _tanggalmulai, _tanggalakhir]);
    }
    return result;
  }

  Future<List> sumtransaksikategoritanggal(
      _kddompet, _tanggalmulai, _tanggalakhir) async {
    Database db = await DatabaseHelper.instance.database;
    var result;
    if (_kddompet == 0) {
      result = await db.rawQuery(
          "SELECT k.kdkategori,k.namakategori,k.jenis,k.codepoint,k.fontfamily,k.fontpackage,k.color," +
              " IFNULL(SUM(t.masuk),0) as summasuk,IFNULL(SUM(t.keluar),0) as sumkeluar" +
              " FROM transaksi t JOIN kategori k ON t.kdkategori = k.kdkategori" +
              " AND k.jenis <> 't' WHERE t.tanggaltransaksi BETWEEN ? AND ?" +
              " GROUP BY t.kdkategori ORDER BY summasuk DESC,sumkeluar DESC",
          [_tanggalmulai, _tanggalakhir]);
    } else {
      result = await db.rawQuery(
          "SELECT k.kdkategori,k.namakategori,k.jenis,k.codepoint,k.fontfamily,k.fontpackage,k.color," +
              " IFNULL(SUM(t.masuk),0) as summasuk,IFNULL(SUM(t.keluar),0) as sumkeluar" +
              " FROM transaksi t JOIN kategori k ON t.kdkategori = k.kdkategori" +
              " AND k.jenis <> 't' WHERE t.kddompet = ? AND t.tanggaltransaksi BETWEEN ? AND ?" +
              " GROUP BY t.kdkategori ORDER BY summasuk DESC,sumkeluar DESC",
          [_kddompet, _tanggalmulai, _tanggalakhir]);
    }
    return result;
  }
}
