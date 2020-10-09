import 'dart:async';
import 'package:rekap_keuangan/models/transaksi.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';

abstract class InitDompetState {}

class InitDompetInitialState extends InitDompetState {}

class InitDompetSuccessState extends InitDompetState {}

class InitDompetFailureState extends InitDompetState {}

class InitDompetLoadingState extends InitDompetState {}

abstract class InitDompetEvent {}

class SetinitdompetEvent extends InitDompetEvent {
  var namadompet, saldo, catatan, codepoint, fontfamily, fontpackage, color;

  SetinitdompetEvent(
      {this.namadompet,
      this.saldo,
      this.catatan,
      this.codepoint,
      this.fontfamily,
      this.fontpackage,
      this.color});
}

class InitDompetBloc extends Bloc<InitDompetEvent, InitDompetState> {
  InitDompetBloc() : super(InitDompetInitialState());

  @override
  Stream<InitDompetState> mapEventToState(InitDompetEvent event) async* {
    final _repository = MyRepository();

    try {
      if (event is SetinitdompetEvent) {
        yield InitDompetLoadingState();
        final Dompet mDompet = new Dompet(
            namadompet: event.namadompet,
            saldo: 0,
            catatan: event.catatan,
            codepoint: event.codepoint,
            fontfamily: event.fontfamily,
            fontpackage: event.fontpackage,
            color: event.color);
        var kddompet = await _repository.setdompet(mDompet);
        if (event.saldo > 0) {
          var kdtransaksi = await _repository.getkdtransaksi() + 1;
          final Transaksi mTransaksi = new Transaksi(
              kdtransaksi: kdtransaksi,
              kddompet: kddompet,
              kdkategori: 5,
              catatan: 'Saldo Awal',
              tanggaltransaksi: DateFormat('yyyy-MM-dd').format(DateTime.now()),
              keluar: 0,
              masuk: event.saldo);
          await _repository.settransaksi(mTransaksi);
        }
        yield InitDompetSuccessState();
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield InitDompetFailureState();
    }
  }
}
