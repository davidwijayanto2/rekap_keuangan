import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';

abstract class DompetState {}

class DompetInitialState extends DompetState {}

class DompetLoadingState extends DompetState {}

class DompetLoadFailureState extends DompetState {}

class DompetEmptyState extends DompetState {}

class DompetLoadedState extends DompetState {
  List<Map<String, dynamic>> dompetlist;
  DompetLoadedState({@required this.dompetlist});
}

class DompetLoadedGlobalState extends DompetState {
  List<Map<String, dynamic>> dompetlist;
  Dompet globaldompet;
  DompetLoadedGlobalState({@required this.dompetlist, this.globaldompet});
}

abstract class DompetEvent {}

class GetalldompetEvent extends DompetEvent {}

class GetalldompetglobalEvent extends DompetEvent {}

class DompetBloc extends Bloc<DompetEvent, DompetState> {
  DompetBloc() : super(DompetInitialState());

  @override
  Stream<DompetState> mapEventToState(DompetEvent event) async* {
    final _repository = MyRepository();

    try {
      if (event is GetalldompetEvent) {
        yield DompetLoadingState();
        List<Map<String, dynamic>> dompetlist =
            await _repository.getalldompetsumsaldo();
        if (dompetlist.length > 0) {
          yield DompetLoadedState(dompetlist: dompetlist);
        } else {
          yield DompetEmptyState();
        }
      }
      if (event is GetalldompetglobalEvent) {
        yield DompetLoadingState();
        List<Map<String, dynamic>> dompetlist =
            await _repository.getalldompetsumsaldo();
        if (dompetlist.length > 0) {
          double sumsaldo = await _repository.sumdompet();
          List<Map<String, dynamic>> sumtransaksi =
              await _repository.sumtransaksisemuadompet();
          if (sumtransaksi.length > 0) {
            sumsaldo = sumsaldo +
                sumtransaksi[0]['summasuk'] -
                sumtransaksi[0]['sumkeluar'];
          }
          Dompet globaldompet = new Dompet(kddompet: 0, saldo: sumsaldo);
          yield DompetLoadedGlobalState(
              dompetlist: dompetlist, globaldompet: globaldompet);
        } else {
          yield DompetEmptyState();
        }
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield DompetLoadFailureState();
    }
  }
}
