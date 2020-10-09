import 'dart:async';
import 'package:rekap_keuangan/models/detailmemo.dart';
import 'package:rekap_keuangan/models/memo.dart';

import 'db_helper.dart';
import 'package:rekap_keuangan/models/iconlist.dart';
import 'package:rekap_keuangan/models/dompet.dart';
import 'package:rekap_keuangan/models/transaksi.dart';
import 'package:rekap_keuangan/models/kategori.dart';

class MyRepository {
  final dbhelper = DatabaseHelper.instance;
  IconList iconlist = new IconList();
  Dompet dompet = new Dompet();
  Kategori kategori = new Kategori();
  Transaksi transaksi = new Transaksi();
  Memo memo = new Memo();
  DetailMemo detailmemo = new DetailMemo();

  Future<List> geticonlist() async => await iconlist.geticonlist();
  Future<void> seticonlist() async => await iconlist.inserticon(iconlist);

  Future<int> setdompet(_dompet) async => await dompet.insertdompet(_dompet);
  Future<void> updatedompet(_dompet) async =>
      await dompet.updatedompet(_dompet);
  Future<void> deletedompet(_kddompet) async =>
      await dompet.deletedompet(_kddompet);
  Future<List> getalldompet() async => await dompet.getalldompet();
  Future<List> getdatadompet(_kddompet) async =>
      await dompet.getdatadompet(_kddompet);
  Future<List> getdatadompetsumsaldo(_kddompet) async =>
      await dompet.getdatadompetsumsaldo(_kddompet);
  Future<List> getalldompetsumsaldo() async =>
      await dompet.getalldompetsumsaldo();
  Future<int> countdompetnama(_namadompet) async =>
      await dompet.countdompetnama(_namadompet);
  Future<int> countdompetedit(_kddompet, _namadompet) async =>
      await dompet.countdompetedit(_kddompet, _namadompet);
  Future<double> sumdompet() async => await dompet.sumdompet();
  Future<List> sumsaldoawalakhir(
          _kddompet, _tanggalmulai, _tanggalakhir) async =>
      await dompet.sumsaldoawalakhir(_kddompet, _tanggalmulai, _tanggalakhir);
  Future<List> sumsaldoperbulan(_kddompet, _arrtanggal) async =>
      await dompet.sumsaldoperbulan(_kddompet, _arrtanggal);
  Future<void> setkategori(_kategori) async =>
      await kategori.insertkategori(_kategori);
  Future<void> updatekategori(_kategori) async =>
      await kategori.updatekategori(_kategori);
  Future<void> deletekategori(_kdkategori) async =>
      await kategori.deletekategori(_kdkategori);
  Future<List> getallkategori() async => await kategori.getallkategori();
  Future<List> getdatakategori(_kdkategori) async =>
      await kategori.getdatakategori(_kdkategori);
  Future<List> getkategorimasuk() async => await kategori.getkategorimasuk();
  Future<List> getkategorikeluar() async => await kategori.getkategorikeluar();
  Future<int> countkategorinama(_namakategori) async =>
      await kategori.countkategorinama(_namakategori);
  Future<int> countkategoriedit(_kdkategori, _namakategori) async =>
      await kategori.countkategoriedit(_kdkategori, _namakategori);

  Future<void> settransaksi(_transaksi) async =>
      await transaksi.inserttransaksi(_transaksi);
  Future<void> settransaksitransfer(_transaksiasal, _transaksitujuan) async =>
      await transaksi.inserttransaksitransfer(_transaksiasal, _transaksitujuan);
  Future<List> getalltransaksi() async => await transaksi.getalltransaksi();
  Future<List> gettransaksi() async => await transaksi.gettransaksi();
  Future<int> getkdtransaksi() async => await transaksi.getkdtransaksi();
  Future<List> gettransaksikategori(
          _kddompet, _kdkategori, _tanggalmulai, _tanggalakhir) async =>
      await transaksi.gettransaksikategori(
          _kddompet, _kdkategori, _tanggalmulai, _tanggalakhir);
  Future<List> gettransaksikategoricolumn(
          _kddompet, _tanggalmulai, _tanggalakhir) async =>
      await transaksi.gettransaksikategoricolumn(
          _kddompet, _tanggalmulai, _tanggalakhir);
  Future<List> sumtransaksitanggal(
          _kddompet, _tanggalmulai, _tanggalakhir) async =>
      await transaksi.sumtransaksitanggal(
          _kddompet, _tanggalmulai, _tanggalakhir);
  Future<List> sumtransaksitransfer(
          _kddompet, _tanggalmulai, _tanggalakhir) async =>
      await transaksi.sumtransaksitransfer(
          _kddompet, _tanggalmulai, _tanggalakhir);
  Future<List> getdatatransaksiid(_idtransaksi) async =>
      await transaksi.getdatatransaksiid(_idtransaksi);
  Future<List> getdatatransaksikd(_kdtransaksi, _idtransaksi) async =>
      await transaksi.getdatatransaksikd(_kdtransaksi, _idtransaksi);
  Future<List> sumtransaksi(_kddompet, _tanggalmulai, _tanggalakhir) async =>
      await transaksi.sumtransaksi(_kddompet, _tanggalmulai, _tanggalakhir);
  Future<List> sumtransaksinontransfer(
          _kddompet, _tanggalmulai, _tanggalakhir) async =>
      await transaksi.sumtransaksinontransfer(
          _kddompet, _tanggalmulai, _tanggalakhir);
  Future<List> sumtransaksinontransferperbulan(_kddompet, _arrtanggal) async =>
      await transaksi.sumtransaksinontransferperbulan(_kddompet, _arrtanggal);
  Future<List> sumtransaksisemuadompet() async =>
      await transaksi.sumtransaksisemuadompet();
  Future<List> sumtransaksiperdompet(_kddompet) async =>
      await transaksi.sumtransaksiperdompet(_kddompet);
  Future<List> sumtransaksikategoritanggal(
          _kddompet, _tanggalmulai, _tanggalakhir) async =>
      await transaksi.sumtransaksikategoritanggal(
          _kddompet, _tanggalmulai, _tanggalakhir);
  Future<List> sumtransaksikategori(
          _kddompet, _kdkategori, _tanggalmulai, _tanggalakhir) async =>
      await transaksi.sumtransaksikategori(
          _kddompet, _kdkategori, _tanggalmulai, _tanggalakhir);
  Future<void> edittransaksi(_transaksi) async =>
      await transaksi.updatetransaksi(_transaksi);
  Future<void> edittransaksitransfer(_transaksi, _transaksi2) async =>
      await transaksi.updatetransaksitransfer(_transaksi, _transaksi2);
  Future<void> deletetransaksi(_kdtransaksi) async =>
      await transaksi.deletetransaksi(_kdtransaksi);
  Future<void> deletetransaksidompet(_kdkategori) async =>
      await transaksi.deletetransaksidompet(_kdkategori);
  Future<void> deletetransaksikategori(_kdkategori) async =>
      await transaksi.deletetransaksikategori(_kdkategori);

  Future<int> setmemo(_memo) async => await memo.insertmemo(_memo);
  Future<void> updatememo(_memo) async => await memo.updatememo(_memo);
  Future<void> deletememo(_kdmemo) async => await memo.deletememo(_kdmemo);
  Future<List> getallmemo() async => await memo.getallmemo();
  Future<List> getallmemocountdetail() async =>
      await memo.getallmemocountdetail();
  Future<List> getdatamemo(_kdmemo) async => await memo.getdatamemo(_kdmemo);
  Future<int> countmemojudul(_judul) async => await memo.countmemojudul(_judul);
  Future<int> countmemoedit(_kdmemo, _judul) async =>
      await memo.countmemoedit(_kdmemo, _judul);

  Future<void> setdetailmemo(_detailmemo) async =>
      await detailmemo.insertdetailmemo(_detailmemo);
  Future<void> updatedetailmemo(_memo) async =>
      await detailmemo.updatedetailmemo(_memo);
  Future<void> updatestatusdetailmemo(_memo) async =>
      await detailmemo.updatestatusdetailmemo(_memo);
  Future<void> deletedetailmemo(_kddetailmemo) async =>
      await detailmemo.deletedetailmemo(_kddetailmemo);
  Future<void> deleteall(_kdmemo) async =>
      await detailmemo.deletealldetailmemo(_kdmemo);
  Future<List> getalldetailmemo() async => await detailmemo.getalldetailmemo();
  Future<List> getdatadetailmemo(_kdmemo) async =>
      await detailmemo.getdatadetailmemo(_kdmemo);
  Future<int> countcheckeddetailmemo(_kdmemo) async =>
      await detailmemo.countcheckeddetailmemo(_kdmemo);
  Future<int> countuncheckeddetailmemo(_kdmemo) async =>
      await detailmemo.countuncheckeddetailmemo(_kdmemo);

  //Future<ResponseData> getalllastdeviceapi() => apiprovider.getAllLastDevice();
  // Future<ResponseObject> login(_email,_password,_token) =>apiprovider.login(_email,_password,_token);

  // Future<ResponseData> getalllastdevicepositionapi() => apiprovider.getAllLastDevicePosition();

  // Future<ResponseData> getnotifyapi() => apiprovider.getnotify();

  // Future<ResponseData> getnotifapi() => apiprovider.getnotif();

  // Future<String> setnotifapi(_header,_message,_notifdate,_notify,_every,_periode) => apiprovider.setnotif(_header,_message,_notifdate,_notify,_every,_periode);

  // Future<int> insertTrackdb(Device device) => dbhelper.insertTrack(device);

  // Future<List> getAllLastTrackdb() => dbhelper.getAllLastTrack();

}
