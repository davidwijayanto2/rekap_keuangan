import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/transaksi.dart';

class TambahTransaksiState {
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;
  Map<String, dynamic> initdata;
  TambahTransaksiState({
    this.isFailure: false,
    this.isLoading: false,
    this.isSuccess: false,
    this.initdata,
  });
}

abstract class TambahTransaksiEvent {}

class SettransaksiEvent extends TambahTransaksiEvent {
  var kdkategori, kddompet, tanggaltransaksi, keluar, masuk, catatan, foto;

  SettransaksiEvent(
      {this.kdkategori,
      this.kddompet,
      this.tanggaltransaksi,
      this.keluar,
      this.masuk,
      this.catatan,
      this.foto});
}

class SettransaksitransferEvent extends TambahTransaksiEvent {
  var kddompetasal,
      kddompettujuan,
      tanggaltransaksi,
      transfer,
      catatanasal,
      catatantujuan;

  SettransaksitransferEvent(
      {this.kddompetasal,
      this.kddompettujuan,
      this.tanggaltransaksi,
      this.transfer,
      this.catatanasal,
      this.catatantujuan});
}

class GetkategorikeluarmasukEvent extends TambahTransaksiEvent {}

class GetalldompetEvent extends TambahTransaksiEvent {}

class TambahTransaksiBloc
    extends Bloc<TambahTransaksiEvent, TambahTransaksiState> {
  TambahTransaksiBloc() : super(TambahTransaksiState());

  @override
  Stream<TambahTransaksiState> mapEventToState(
      TambahTransaksiEvent event) async* {
    final _repository = MyRepository();
    print('masukbloc');
    TambahTransaksiState(isLoading: false);
    TambahTransaksiState(isSuccess: false);
    TambahTransaksiState(isFailure: false);
    try {
      if (event is SettransaksiEvent) {
        print('masukevent');
        yield TambahTransaksiState(isLoading: true);
        var kdtransaksi = await _repository.getkdtransaksi() + 1;
        final Transaksi mTransaksi = new Transaksi(
            kdtransaksi: kdtransaksi,
            kddompet: event.kddompet,
            kdkategori: event.kdkategori,
            catatan: event.catatan,
            tanggaltransaksi: event.tanggaltransaksi,
            foto: event.foto,
            keluar: event.keluar,
            masuk: event.masuk);
        await _repository.settransaksi(mTransaksi);
        yield TambahTransaksiState(isSuccess: true);
      }
      if (event is SettransaksitransferEvent) {
        yield TambahTransaksiState(isLoading: true);
        var kdtransaksi = await _repository.getkdtransaksi() + 1;
        final Transaksi mTransaksiasal = new Transaksi(
            kdtransaksi: kdtransaksi,
            kddompet: event.kddompetasal,
            kdkategori: 1,
            catatan: event.catatanasal,
            tanggaltransaksi: event.tanggaltransaksi,
            keluar: event.transfer,
            masuk: 0);
        final Transaksi mTransaksitujuan = new Transaksi(
            kdtransaksi: kdtransaksi,
            kddompet: event.kddompettujuan,
            kdkategori: 1,
            catatan: event.catatantujuan,
            tanggaltransaksi: event.tanggaltransaksi,
            keluar: 0,
            masuk: event.transfer);
        await _repository.settransaksitransfer(
            mTransaksiasal, mTransaksitujuan);
        yield TambahTransaksiState(isSuccess: true);
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield TambahTransaksiState(isFailure: true);
    }
  }
}
