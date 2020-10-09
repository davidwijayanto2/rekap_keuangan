import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';

abstract class KategoriState {}

class KategoriInitialState extends KategoriState {}

class KategoriLoadingState extends KategoriState {}

class KategoriLoadFailureState extends KategoriState {}

class KategoriEmptyState extends KategoriState {}

class KategoriLoadedState extends KategoriState {
  List<Map<String, dynamic>> kategorilist;
  KategoriLoadedState({@required this.kategorilist});
}

class KategoriKMLoadedState extends KategoriState {
  Map<String, dynamic> kategorilist;
  List<Map<String, dynamic>> listkategori;
  KategoriKMLoadedState({this.kategorilist, this.listkategori});
}

abstract class KategoriEvent {}

class GetallkategoriEvent extends KategoriEvent {}

class GetkategorikeluarmasukEvent extends KategoriEvent {}

class GetkategorikeluarEvent extends KategoriEvent {}

class GetkategorimasukEvent extends KategoriEvent {}

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  KategoriBloc() : super(KategoriInitialState());

  @override
  Stream<KategoriState> mapEventToState(KategoriEvent event) async* {
    final _repository = MyRepository();

    try {
      if (event is GetallkategoriEvent) {
        yield KategoriLoadingState();
        List<Map<String, dynamic>> kategorilist =
            await _repository.getallkategori();
        if (kategorilist.length > 0) {
          yield KategoriLoadedState(kategorilist: kategorilist);
        } else {
          yield KategoriEmptyState();
        }
      }
      if (event is GetkategorikeluarmasukEvent) {
        print('masuk event');
        yield KategoriLoadingState();
        List<Map<String, dynamic>> kategorimasuklist =
            await _repository.getkategorimasuk();
        List<Map<String, dynamic>> kategorikeluarlist =
            await _repository.getkategorikeluar();
        if (kategorikeluarlist.length > 0 || kategorimasuklist.length > 0) {
          Map<String, dynamic> arrBack = {
            'keluar': kategorikeluarlist,
            'masuk': kategorimasuklist
          };
          yield KategoriKMLoadedState(kategorilist: arrBack);
        } else {
          yield KategoriEmptyState();
        }
      }
      if (event is GetkategorikeluarEvent) {
        yield KategoriLoadingState();
        List<Map<String, dynamic>> kategorikeluarlist =
            await _repository.getkategorikeluar();
        if (kategorikeluarlist.length > 0) {
          List<Map<String, dynamic>> arrBack = kategorikeluarlist;
          yield KategoriKMLoadedState(listkategori: arrBack);
        } else {
          yield KategoriEmptyState();
        }
      }
      if (event is GetkategorimasukEvent) {
        yield KategoriLoadingState();
        List<Map<String, dynamic>> kategorimasuklist =
            await _repository.getkategorimasuk();
        if (kategorimasuklist.length > 0) {
          List<Map<String, dynamic>> arrBack = kategorimasuklist;
          yield KategoriKMLoadedState(listkategori: arrBack);
        } else {
          yield KategoriEmptyState();
        }
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield KategoriLoadFailureState();
    }
  }
}
