import 'dart:async';
import 'package:rekap_keuangan/models/memo.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';

class TambahMemoState {
  final bool isDuplicate;
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;
  final int kdmemo;
  TambahMemoState(
      {this.isDuplicate: false,
      this.isFailure: false,
      this.isLoading: false,
      this.isSuccess: false,
      this.kdmemo});
}

abstract class TambahMemoEvent {}

class SetmemoEvent extends TambahMemoEvent {
  var judul;
  SetmemoEvent({this.judul});
}

class TambahMemoBloc extends Bloc<TambahMemoEvent, TambahMemoState> {
  TambahMemoBloc() : super(TambahMemoState());

  @override
  Stream<TambahMemoState> mapEventToState(TambahMemoEvent event) async* {
    final _repository = MyRepository();
    print('masukbloc');
    TambahMemoState(isLoading: false);
    TambahMemoState(isSuccess: false);
    TambahMemoState(isFailure: false);
    TambahMemoState(isDuplicate: false);
    try {
      if (event is SetmemoEvent) {
        print('masukevent');
        yield TambahMemoState(isLoading: true);
        int countmemo = await _repository.countmemojudul(event.judul);
        if (countmemo == 0) {
          DateTime now = DateTime.now();
          String tanggalbuat = DateFormat('y-M-d H:m').format(now);
          final Memo mMemo =
              new Memo(judul: event.judul, tanggalbuat: tanggalbuat);
          int resultid = await _repository.setmemo(mMemo);
          yield TambahMemoState(isSuccess: true, kdmemo: resultid);
        } else {
          yield TambahMemoState(isDuplicate: true);
        }
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield TambahMemoState(isFailure: true);
    }
  }
}
