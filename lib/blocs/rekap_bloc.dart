import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';

abstract class RekapState {}

class RekapInitialState extends RekapState {}

class RekapLoadingState extends RekapState {}

class RekapLoadedState extends RekapState {
  Map<String, dynamic> maprekap;
  RekapLoadedState({@required this.maprekap});
}

class RekapFailedState extends RekapState {}

class RekapEmptyState extends RekapState {
  Map<String, dynamic> maprekap;
  RekapEmptyState({@required this.maprekap});
}

abstract class RekapEvent {}

class GetrekapEvent extends RekapEvent {
  var tanggalmulai, tanggalakhir, kddompet;
  GetrekapEvent({this.kddompet, this.tanggalmulai, this.tanggalakhir});
}

class RekapBloc extends Bloc<RekapEvent, RekapState> {
  RekapBloc() : super(RekapInitialState());

  @override
  Stream<RekapState> mapEventToState(RekapEvent event) async* {
    final _repository = MyRepository();

    try {
      if (event is GetrekapEvent) {
        List<Map<String, dynamic>> sumtransaksi =
            await _repository.sumtransaksinontransfer(
                event.kddompet, event.tanggalmulai, event.tanggalakhir);
        List<Map<String, dynamic>> sumtransaksikategori =
            await _repository.sumtransaksikategoritanggal(
                event.kddompet, event.tanggalmulai, event.tanggalakhir);
        Map<String, dynamic> maprekap = {
          'sumtransaksi': sumtransaksi,
          'rekaplist': sumtransaksikategori,
        };
        if (sumtransaksikategori.length > 0) {
          yield RekapLoadedState(maprekap: maprekap);
        } else {
          yield RekapEmptyState(maprekap: maprekap);
        }
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield RekapFailedState();
    }
  }
}
