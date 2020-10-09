import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';

class UbahDompetState {
  final bool isDuplicate;
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;
  final bool isLoaded;
  final bool isDeleted;
  Map<String, dynamic> dompetdata;
  UbahDompetState({
    this.isDuplicate: false,
    this.isFailure: false,
    this.isLoading: false,
    this.isSuccess: false,
    this.isLoaded: false,
    this.isDeleted: false,
    this.dompetdata,
  });
}

abstract class UbahDompetEvent {}

class GetdompeteditdataEvent extends UbahDompetEvent {
  var kddompet;

  GetdompeteditdataEvent({this.kddompet});
}

class EditdompetEvent extends UbahDompetEvent {
  var kddompet, namadompet, catatan, codepoint, fontfamily, fontpackage, color;

  EditdompetEvent(
      {this.kddompet,
      this.namadompet,
      this.catatan,
      this.codepoint,
      this.fontfamily,
      this.fontpackage,
      this.color});
}

class DeletedompetEvent extends UbahDompetEvent {
  var kddompet;

  DeletedompetEvent({this.kddompet});
}

class UbahDompetBloc extends Bloc<UbahDompetEvent, UbahDompetState> {
  UbahDompetBloc() : super(UbahDompetState());

  @override
  Stream<UbahDompetState> mapEventToState(UbahDompetEvent event) async* {
    final _repository = MyRepository();
    print('masukbloc');
    UbahDompetState(isLoading: false);
    UbahDompetState(isSuccess: false);
    UbahDompetState(isFailure: false);
    UbahDompetState(isDuplicate: false);
    UbahDompetState(isLoaded: false);
    UbahDompetState(isDeleted: false);
    UbahDompetState(dompetdata: {});
    try {
      if (event is GetdompeteditdataEvent) {
        yield UbahDompetState(isLoading: true);
        List<Map<String, dynamic>> arrBack =
            await _repository.getdatadompet(event.kddompet);
        if (arrBack.length > 0) {
          yield UbahDompetState(dompetdata: arrBack[0], isLoaded: true);
        }
      } else if (event is EditdompetEvent) {
        yield UbahDompetState(isLoading: true);
        int countdompet =
            await _repository.countdompetedit(event.kddompet, event.namadompet);

        if (countdompet == 0) {
          final Dompet mDompet = new Dompet(
              kddompet: event.kddompet,
              namadompet: event.namadompet,
              catatan: event.catatan,
              codepoint: event.codepoint,
              fontfamily: event.fontfamily,
              fontpackage: event.fontpackage,
              color: event.color);
          await _repository.updatedompet(mDompet);
          yield UbahDompetState(isSuccess: true);
        } else {
          yield UbahDompetState(isDuplicate: true);
        }
      } else if (event is DeletedompetEvent) {
        yield UbahDompetState(isLoading: true);
        await _repository.deletetransaksidompet(event.kddompet);
        await _repository.deletedompet(event.kddompet);
        yield UbahDompetState(isDeleted: true);
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield UbahDompetState(isFailure: true);
    }
  }
}
