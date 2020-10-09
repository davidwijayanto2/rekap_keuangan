import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';

abstract class DetilRekapState {}

class DetilRekapInitialState extends DetilRekapState {}

class DetilRekapLoadingState extends DetilRekapState {}

class DetilRekapLoadedState extends DetilRekapState {
  Map<String, dynamic> maprekap;
  DetilRekapLoadedState({@required this.maprekap});
}

class DetilRekapFailedState extends DetilRekapState {}

class DetilRekapEmptyState extends DetilRekapState {
  Map<String, dynamic> maprekap;
  DetilRekapEmptyState({@required this.maprekap});
}

abstract class DetilRekapEvent {}

class GetdetilrekapEvent extends DetilRekapEvent {
  var tanggalmulai, tanggalakhir, kddompet, kdkategori;
  GetdetilrekapEvent(
      {this.kddompet, this.kdkategori, this.tanggalmulai, this.tanggalakhir});
}

class DetilRekapBloc extends Bloc<DetilRekapEvent, DetilRekapState> {
  DetilRekapBloc() : super(DetilRekapInitialState());

  @override
  Stream<DetilRekapState> mapEventToState(DetilRekapEvent event) async* {
    final _repository = MyRepository();

    try {
      if (event is GetdetilrekapEvent) {
        List<Map<String, dynamic>> sumrekap =
            await _repository.sumtransaksikategori(event.kddompet,
                event.kdkategori, event.tanggalmulai, event.tanggalakhir);
        List<Map<String, dynamic>> listrekap =
            await _repository.gettransaksikategori(event.kddompet,
                event.kdkategori, event.tanggalmulai, event.tanggalakhir);
        Map<String, dynamic> maprekap = {
          'sumrekap': sumrekap,
          'rekaplist': listrekap,
        };
        if (listrekap.length > 0) {
          yield DetilRekapLoadedState(maprekap: maprekap);
        } else {
          yield DetilRekapEmptyState(maprekap: maprekap);
        }
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield DetilRekapFailedState();
    }
  }
}
