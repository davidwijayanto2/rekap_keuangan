import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/transaksi.dart';

class UbahTransaksiState {
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;
  final bool isLoaded;
  final bool isDeleted;
  final bool isCheckedtransfer;
  Map<String, dynamic> initdata;
  List<Map<String, dynamic>> listtransaksiedit;
  UbahTransaksiState(
      {this.isFailure: false,
      this.isLoading: false,
      this.isSuccess: false,
      this.isLoaded: false,
      this.isDeleted: false,
      this.isCheckedtransfer: false,
      this.initdata,
      this.listtransaksiedit});
}

abstract class UbahTransaksiEvent {}

class EdittransaksiEvent extends UbahTransaksiEvent {
  var kdtransaksi,
      kdkategori,
      kddompet,
      tanggaltransaksi,
      keluar,
      masuk,
      catatan,
      foto;

  EdittransaksiEvent(
      {this.kdtransaksi,
      this.kdkategori,
      this.kddompet,
      this.tanggaltransaksi,
      this.keluar,
      this.masuk,
      this.catatan,
      this.foto});
}

class EdittransaksitransferEvent extends UbahTransaksiEvent {
  var idtransaksi,
      idtransaksi2,
      kddompet,
      tanggaltransaksi,
      keluar,
      masuk,
      keluar2,
      masuk2,
      catatan;

  EdittransaksitransferEvent(
      {this.idtransaksi,
      this.idtransaksi2,
      this.kddompet,
      this.tanggaltransaksi,
      this.keluar,
      this.masuk,
      this.keluar2,
      this.masuk2,
      this.catatan});
}

class GetkategorikeluarmasukEvent extends UbahTransaksiEvent {}

class GetalldompetEvent extends UbahTransaksiEvent {}

class GetdatatransaksiEvent extends UbahTransaksiEvent {
  var idtransaksi;
  GetdatatransaksiEvent({this.idtransaksi});
}

class GetdatatransaksitransferEvent extends UbahTransaksiEvent {
  var kdtransaksi, idtransaksi;
  GetdatatransaksitransferEvent({this.kdtransaksi, this.idtransaksi});
}

class DeletetransaksiEvent extends UbahTransaksiEvent {
  var kdtransaksi;
  DeletetransaksiEvent({this.kdtransaksi});
}

class UbahTransaksiBloc extends Bloc<UbahTransaksiEvent, UbahTransaksiState> {
  UbahTransaksiBloc() : super(UbahTransaksiState());

  @override
  Stream<UbahTransaksiState> mapEventToState(UbahTransaksiEvent event) async* {
    final _repository = MyRepository();
    print('masukbloc');
    UbahTransaksiState(isLoading: false);
    UbahTransaksiState(isSuccess: false);
    UbahTransaksiState(isFailure: false);
    UbahTransaksiState(isLoaded: false);
    UbahTransaksiState(isDeleted: false);
    UbahTransaksiState(isCheckedtransfer: false);
    UbahTransaksiState(listtransaksiedit: List());
    try {
      if (event is EdittransaksiEvent) {
        print('masukeventedit');
        yield UbahTransaksiState(isLoading: true);
        final Transaksi mTransaksi = new Transaksi(
            kdtransaksi: event.kdtransaksi,
            kddompet: event.kddompet,
            kdkategori: event.kdkategori,
            catatan: event.catatan,
            tanggaltransaksi: event.tanggaltransaksi,
            foto: event.foto,
            keluar: event.keluar,
            masuk: event.masuk);
        print('tran ' + mTransaksi.kdtransaksi.toString());
        await _repository.edittransaksi(mTransaksi);
        yield UbahTransaksiState(isSuccess: true);
      } else if (event is EdittransaksitransferEvent) {
        yield UbahTransaksiState(isLoading: true);
        final Transaksi mTransaksi = new Transaksi(
            idtransaksi: event.idtransaksi,
            kddompet: event.kddompet,
            catatan: event.catatan,
            tanggaltransaksi: event.tanggaltransaksi,
            keluar: event.keluar,
            masuk: event.masuk);
        final Transaksi mTransaksi2 = new Transaksi(
            idtransaksi: event.idtransaksi2,
            tanggaltransaksi: event.tanggaltransaksi,
            keluar: event.keluar2,
            masuk: event.masuk2);
        await _repository.edittransaksitransfer(mTransaksi, mTransaksi2);
        yield UbahTransaksiState(isSuccess: true);
      } else if (event is GetdatatransaksiEvent) {
        yield UbahTransaksiState(isLoading: true);
        List<Map<String, dynamic>> listtransaksiedit =
            await _repository.getdatatransaksiid(event.idtransaksi);
        yield UbahTransaksiState(
            listtransaksiedit: listtransaksiedit, isLoaded: true);
      } else if (event is DeletetransaksiEvent) {
        yield UbahTransaksiState(isLoading: true);
        await _repository.deletetransaksi(event.kdtransaksi);
        yield UbahTransaksiState(isDeleted: true);
      } else if (event is GetdatatransaksitransferEvent) {
        List<Map<String, dynamic>> listtransaksiedit = await _repository
            .getdatatransaksikd(event.kdtransaksi, event.idtransaksi);
        yield UbahTransaksiState(
            listtransaksiedit: listtransaksiedit, isCheckedtransfer: true);
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield UbahTransaksiState(isFailure: true);
    }
  }
}
