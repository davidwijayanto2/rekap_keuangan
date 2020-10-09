import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/transaksi.dart';

class CatatTransaksiState {
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;
  Map<String, dynamic> initdata;
  CatatTransaksiState({
    this.isFailure: false,
    this.isLoading: false,
    this.isSuccess: false,
    this.initdata,
  });
}

abstract class CatatTransaksiEvent {}

class SettransaksiEvent extends CatatTransaksiEvent {
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

class GetkategorikeluarmasukEvent extends CatatTransaksiEvent {}

class GetalldompetEvent extends CatatTransaksiEvent {}

class CatatTransaksiBloc
    extends Bloc<CatatTransaksiEvent, CatatTransaksiState> {
  CatatTransaksiBloc() : super(CatatTransaksiState());

  @override
  Stream<CatatTransaksiState> mapEventToState(
      CatatTransaksiEvent event) async* {
    final _repository = MyRepository();
    print('masukbloc');
    CatatTransaksiState(isLoading: false);
    CatatTransaksiState(isSuccess: false);
    CatatTransaksiState(isFailure: false);
    try {
      if (event is SettransaksiEvent) {
        print('masukevent');
        yield CatatTransaksiState(isLoading: true);
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
        yield CatatTransaksiState(isSuccess: true);
      }
      if (event is GetkategorikeluarmasukEvent) {
        print('masuk event');
        yield CatatTransaksiState(isLoading: true);
        List<Map<String, dynamic>> kategorimasuklist =
            await _repository.getkategorimasuk();
        List<Map<String, dynamic>> kategorikeluarlist =
            await _repository.getkategorikeluar();
        List<Map<String, dynamic>> dompetlist =
            await _repository.getalldompet();
        if (kategorikeluarlist.length > 0 || kategorimasuklist.length > 0) {
          Map<String, dynamic> arrBack = {
            'keluar': kategorikeluarlist,
            'masuk': kategorimasuklist,
            'dompet': dompetlist
          };
          yield CatatTransaksiState(initdata: arrBack);
        }
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield CatatTransaksiState(isFailure: true);
    }
  }
}
