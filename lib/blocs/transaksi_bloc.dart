import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TransaksiState {}

class TransaksiInitialState extends TransaksiState {}

class TransaksiLoadingState extends TransaksiState {}

class TransaksiLoadFailureState extends TransaksiState {}

class TransaksiEmptyState extends TransaksiState {}

class TransaksiLoadedState extends TransaksiState {
  Map<String, dynamic> maptransaksi;
  TransaksiLoadedState({@required this.maptransaksi});
}

abstract class TransaksiEvent {}

class GetalltransaksiEvent extends TransaksiEvent {
  var tanggalmulai, tanggalakhir, kddompet;
  GetalltransaksiEvent({this.kddompet, this.tanggalmulai, this.tanggalakhir});
}

class TransaksiBloc extends Bloc<TransaksiEvent, TransaksiState> {
  TransaksiBloc() : super(TransaksiInitialState());

  @override
  Stream<TransaksiState> mapEventToState(TransaksiEvent event) async* {
    final _repository = MyRepository();

    try {
      if (event is GetalltransaksiEvent) {
        print('kddompet: ' + event.kddompet.toString());
        List<Map<String, dynamic>> transaksilist =
            await _repository.gettransaksikategoricolumn(
                event.kddompet, event.tanggalmulai, event.tanggalakhir);
        List<Map<String, dynamic>> sumtransaksitanggal =
            await _repository.sumtransaksitanggal(
                event.kddompet, event.tanggalmulai, event.tanggalakhir);
        List<Map<String, dynamic>> sumtransaksi =
            await _repository.sumtransaksi(
                event.kddompet, event.tanggalmulai, event.tanggalakhir);
        List<Map<String, dynamic>> sumsaldo =
            await _repository.sumsaldoawalakhir(
                event.kddompet, event.tanggalmulai, event.tanggalakhir);
        print(sumtransaksi.toList());
        if (transaksilist.length > 0) {
          Map<String, dynamic> maptransaksi = {
            'sumsaldo': sumsaldo,
            'sumtransaksi': sumtransaksi,
            'transaksilist': transaksilist,
            'sumtransaksitanggal': sumtransaksitanggal,
          };
          yield TransaksiLoadedState(maptransaksi: maptransaksi);
        } else {
          yield TransaksiEmptyState();
        }
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield TransaksiLoadFailureState();
    }
  }
}
