import 'dart:async';
import 'package:rekap_keuangan/models/transaksi.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';

class TambahDompetState {
  final bool isDuplicate;
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;
  TambahDompetState(
      {this.isDuplicate: false,
      this.isFailure: false,
      this.isLoading: false,
      this.isSuccess: false});
}

abstract class TambahDompetEvent {}

class SetdompetEvent extends TambahDompetEvent {
  var namadompet, saldo, catatan, codepoint, fontfamily, fontpackage, color;

  SetdompetEvent(
      {this.namadompet,
      this.saldo,
      this.catatan,
      this.codepoint,
      this.fontfamily,
      this.fontpackage,
      this.color});
}

class TambahDompetBloc extends Bloc<TambahDompetEvent, TambahDompetState> {
  TambahDompetBloc() : super(TambahDompetState());

  @override
  Stream<TambahDompetState> mapEventToState(TambahDompetEvent event) async* {
    final _repository = MyRepository();
    print('masukbloc');
    TambahDompetState(isLoading: false);
    TambahDompetState(isSuccess: false);
    TambahDompetState(isFailure: false);
    TambahDompetState(isDuplicate: false);
    try {
      if (event is SetdompetEvent) {
        print('masukevent');
        yield TambahDompetState(isLoading: true);
        int countdompet = await _repository.countdompetnama(event.namadompet);
        if (countdompet == 0) {
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
                tanggaltransaksi:
                    DateFormat('yyyy-MM-dd').format(DateTime.now()),
                keluar: 0,
                masuk: event.saldo);
            await _repository.settransaksi(mTransaksi);
          }
          yield TambahDompetState(isSuccess: true);
        } else {
          yield TambahDompetState(isDuplicate: true);
        }
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield TambahDompetState(isFailure: true);
    }
  }
}
