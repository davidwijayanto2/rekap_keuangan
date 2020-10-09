import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MemoState {}

class MemoInitialState extends MemoState {}

class MemoLoadingState extends MemoState {}

class MemoLoadFailureState extends MemoState {}

class MemoEmptyState extends MemoState {}

class MemoShareEmptyState extends MemoState {}

class MemoLoadedState extends MemoState {
  List<Map<String, dynamic>> memolist;
  MemoLoadedState({@required this.memolist});
}

class MemoShareState extends MemoState {
  List<Map<String, dynamic>> detailmemolist;
  var judul;
  MemoShareState({@required this.detailmemolist, this.judul});
}

abstract class MemoEvent {}

class GetallmemoEvent extends MemoEvent {}

class GetdetailshareEvent extends MemoEvent {
  var kdmemo, judul;
  GetdetailshareEvent({this.kdmemo, this.judul});
}

class MemoBloc extends Bloc<MemoEvent, MemoState> {
  MemoBloc() : super(MemoInitialState());

  @override
  Stream<MemoState> mapEventToState(MemoEvent event) async* {
    final _repository = MyRepository();

    try {
      if (event is GetallmemoEvent) {
        yield MemoLoadingState();
        List<Map<String, dynamic>> memolist =
            await _repository.getallmemocountdetail();
        if (memolist.length > 0) {
          yield MemoLoadedState(memolist: memolist);
        } else {
          yield MemoEmptyState();
        }
      }
      if (event is GetdetailshareEvent) {
        List<Map<String, dynamic>> detailmemolist =
            await _repository.getdatadetailmemo(event.kdmemo);
        if (detailmemolist.length > 0) {
          print(detailmemolist.toString());
          yield MemoShareState(
              detailmemolist: detailmemolist, judul: event.judul);
        } else {
          yield MemoShareEmptyState();
        }
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield MemoLoadFailureState();
    }
  }
}
