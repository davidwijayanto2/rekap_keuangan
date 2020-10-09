import 'dart:async';
import 'package:rekap_keuangan/models/iconlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';

abstract class IconListState {}

class IconInitialState extends IconListState {}

class IconLoadingState extends IconListState {}

class IconFailureState extends IconListState {}

class IconEmptyState extends IconListState {}

class IconLoadedState extends IconListState {
  List<Map<String, dynamic>> iconlist;
  IconLoadedState({@required this.iconlist});
}

abstract class IconListEvent {}

class GetalliconEvent extends IconListEvent {}

class SeticonEvent extends IconListEvent {}

class IconBloc extends Bloc<IconListEvent, IconListState> {
  IconBloc() : super(IconInitialState());

  @override
  Stream<IconListState> mapEventToState(IconListEvent event) async* {
    final _repository = MyRepository();

    yield IconLoadingState();
    try {
      if (event is GetalliconEvent) {
        List<Map<String, dynamic>> iconlist = await _repository.geticonlist();
        if (iconlist.length > 0) {
          print(iconlist);
          yield IconLoadedState(iconlist: iconlist);
        } else {
          yield IconEmptyState();
        }
      } else if (event is SeticonEvent) {}
    } catch (e) {
      print('message failure: ' + e.toString());
      yield IconFailureState();
    }
  }
}
