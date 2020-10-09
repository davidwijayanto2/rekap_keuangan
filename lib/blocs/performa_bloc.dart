import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';

abstract class PerformaState {}

class PerformaInitialState extends PerformaState {}

class PerformaLoadingState extends PerformaState {}

class PerformaLoadedState extends PerformaState {
  Map<String, dynamic> mapperforma;
  PerformaLoadedState({@required this.mapperforma});
}

class PerformaFailedState extends PerformaState {}

abstract class PerformaEvent {}

class GetperformaEvent extends PerformaEvent {
  var tanggalmulai, tanggalakhir, arrtanggal, kddompet;
  GetperformaEvent(
      {this.kddompet, this.tanggalmulai, this.tanggalakhir, this.arrtanggal});
}

class PerformaBloc extends Bloc<PerformaEvent, PerformaState> {
  PerformaBloc() : super(PerformaInitialState());

  @override
  Stream<PerformaState> mapEventToState(PerformaEvent event) async* {
    final _repository = MyRepository();

    try {
      if (event is GetperformaEvent) {
        List<Map<String, dynamic>> sumsaldo =
            await _repository.sumsaldoawalakhir(
                event.kddompet, event.tanggalmulai, event.tanggalakhir);
        List<Map<String, dynamic>> sumsaldoperbulan = await _repository
            .sumsaldoperbulan(event.kddompet, event.arrtanggal);
        List<Map<String, dynamic>> sumtransaksi =
            await _repository.sumtransaksi(
                event.kddompet, event.tanggalmulai, event.tanggalakhir);
        List<Map<String, dynamic>> sumtransaksinontransferperbulan =
            await _repository.sumtransaksinontransferperbulan(
                event.kddompet, event.arrtanggal);
        Map<String, dynamic> mapperforma = {
          'sumsaldo': sumsaldo,
          'sumtransaksi': sumtransaksi,
          'sumsaldoperbulan': sumsaldoperbulan,
          'sumtransaksinontransferperbulan': sumtransaksinontransferperbulan,
        };
        yield PerformaLoadedState(mapperforma: mapperforma);
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield PerformaFailedState();
    }
  }
}
