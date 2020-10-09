import 'dart:async';
import 'package:rekap_keuangan/models/detailmemo.dart';
import 'package:rekap_keuangan/models/memo.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';

abstract class TambahDetailMemoState {}

class TambahDetailMemoInitialState extends TambahDetailMemoState {}

class TambahDetailMemoLoadingState extends TambahDetailMemoState {}

class TambahDetailMemoLoadFailureState extends TambahDetailMemoState {}

class TambahDetailMemoEmptyState extends TambahDetailMemoState {}

class TambahDetailMemoLoadedState extends TambahDetailMemoState {
  List<Map<String, dynamic>> detailmemolist;
  TambahDetailMemoLoadedState({@required this.detailmemolist});
}

class TambahDetailMemoDeletedState extends TambahDetailMemoState {}

abstract class TambahDetailMemoEvent {}

class SetdetailmemoEvent extends TambahDetailMemoEvent {
  var kdmemo, namadmemo, total;
  SetdetailmemoEvent({this.kdmemo, this.namadmemo, this.total});
}

class SetstatusdetailmemoEvent extends TambahDetailMemoEvent {
  var kdmemo, kddetailmemo, status;
  SetstatusdetailmemoEvent({this.kdmemo, this.kddetailmemo, this.status});
}

class UpdatedetailmemoEvent extends TambahDetailMemoEvent {
  var kdmemo, kddetailmemo, namadmemo, total;
  UpdatedetailmemoEvent(
      {this.kdmemo, this.kddetailmemo, this.namadmemo, this.total});
}

class UpdatejudulmemoEvent extends TambahDetailMemoEvent {
  var kdmemo, judul;
  UpdatejudulmemoEvent({this.kdmemo, this.judul});
}

class DeletememoEvent extends TambahDetailMemoEvent {
  var kdmemo;
  DeletememoEvent({this.kdmemo});
}

class GetdetailmemoEvent extends TambahDetailMemoEvent {
  var kdmemo;
  GetdetailmemoEvent({this.kdmemo});
}

class TambahDetailMemoBloc
    extends Bloc<TambahDetailMemoEvent, TambahDetailMemoState> {
  TambahDetailMemoBloc() : super(TambahDetailMemoInitialState());

  @override
  Stream<TambahDetailMemoState> mapEventToState(
      TambahDetailMemoEvent event) async* {
    final _repository = MyRepository();

    try {
      if (event is SetdetailmemoEvent) {
        print('masukevent');
        yield TambahDetailMemoLoadingState();
        final DetailMemo mDetailMemo = new DetailMemo(
            kdmemo: event.kdmemo,
            namadmemo: event.namadmemo,
            total: event.total,
            status: 0);
        await _repository.setdetailmemo(mDetailMemo);
        List<Map<String, dynamic>> detailmemolist =
            await _repository.getdatadetailmemo(event.kdmemo);
        if (detailmemolist.length > 0) {
          yield TambahDetailMemoLoadedState(detailmemolist: detailmemolist);
        } else {
          yield TambahDetailMemoEmptyState();
        }
      }
      if (event is SetstatusdetailmemoEvent) {
        final DetailMemo mDetailMemo = new DetailMemo(
            kddetailmemo: event.kddetailmemo, status: event.status);
        await _repository.updatestatusdetailmemo(mDetailMemo);
        List<Map<String, dynamic>> detailmemolist =
            await _repository.getdatadetailmemo(event.kdmemo);
        if (detailmemolist.length > 0) {
          yield TambahDetailMemoLoadedState(detailmemolist: detailmemolist);
        } else {
          yield TambahDetailMemoEmptyState();
        }
      }
      if (event is UpdatedetailmemoEvent) {
        final DetailMemo mDetailMemo = new DetailMemo(
            kddetailmemo: event.kddetailmemo,
            namadmemo: event.namadmemo,
            total: event.total);
        await _repository.updatedetailmemo(mDetailMemo);
        List<Map<String, dynamic>> detailmemolist =
            await _repository.getdatadetailmemo(event.kdmemo);
        if (detailmemolist.length > 0) {
          yield TambahDetailMemoLoadedState(detailmemolist: detailmemolist);
        } else {
          yield TambahDetailMemoEmptyState();
        }
      }
      print('masuk event');
      if (event is UpdatejudulmemoEvent) {
        print('masuk judul memo');
        final Memo mMemo = new Memo(kdmemo: event.kdmemo, judul: event.judul);
        await _repository.updatememo(mMemo);
        List<Map<String, dynamic>> detailmemolist =
            await _repository.getdatadetailmemo(event.kdmemo);
        if (detailmemolist.length > 0) {
          yield TambahDetailMemoLoadedState(detailmemolist: detailmemolist);
        } else {
          yield TambahDetailMemoEmptyState();
        }
      }
      if (event is DeletememoEvent) {
        //Memo mMemo = new Memo(kdmemo)
        await _repository.deletememo(event.kdmemo);
        yield TambahDetailMemoDeletedState();
      }
      if (event is GetdetailmemoEvent) {
        yield TambahDetailMemoLoadingState();
        List<Map<String, dynamic>> detailmemolist =
            await _repository.getdatadetailmemo(event.kdmemo);
        if (detailmemolist.length > 0) {
          print(detailmemolist.toString());
          yield TambahDetailMemoLoadedState(detailmemolist: detailmemolist);
        } else {
          yield TambahDetailMemoEmptyState();
        }
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield TambahDetailMemoLoadFailureState();
    }
  }
}
