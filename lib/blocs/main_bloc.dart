import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';

abstract class MainState {}

class MainInitialState extends MainState {}

class MainLoadingState extends MainState {}

class MainLoadFailureState extends MainState {}

class MainEmptyState extends MainState {}

class MainLoadedState extends MainState {
  Dompet dompetlist;
  MainLoadedState({@required this.dompetlist});
}

abstract class MainEvent {}

class GetdompetEvent extends MainEvent {
  var kddompet, tanggalmulai, tanggalakhir;
  GetdompetEvent({this.kddompet, tanggalmulai, tanggalakhir});
}

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitialState());

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    final _repository = MyRepository();

    try {
      if (event is GetdompetEvent) {
        yield MainLoadingState();
        if (event.kddompet == 0) {
          double sumsaldo = await _repository.sumdompet();
          List<Map<String, dynamic>> sumtransaksi =
              await _repository.sumtransaksisemuadompet();
          if (sumtransaksi.length > 0) {
            sumsaldo = sumsaldo +
                sumtransaksi[0]['summasuk'] -
                sumtransaksi[0]['sumkeluar'];
          }
          Dompet dompetlist =
              new Dompet(kddompet: event.kddompet, saldo: sumsaldo);
          yield MainLoadedState(dompetlist: dompetlist);
        } else {
          List<Map<String, dynamic>> dompetlist =
              await _repository.getdatadompetsumsaldo(event.kddompet);
          if (dompetlist.length > 0) {
            Dompet mDompet = new Dompet(
                kddompet: dompetlist[0]['kddompet'],
                namadompet: dompetlist[0]['namadompet'],
                catatan: dompetlist[0]['catatan'],
                saldo: dompetlist[0]['saldo'],
                codepoint: dompetlist[0]['codepoint'],
                fontfamily: dompetlist[0]['fontfamily'],
                fontpackage: dompetlist[0]['fontpackage'],
                color: dompetlist[0]['color']);
            yield MainLoadedState(dompetlist: mDompet);
          }
        }
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield MainLoadFailureState();
    }
  }
}
