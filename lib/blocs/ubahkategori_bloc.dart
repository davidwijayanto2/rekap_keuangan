import 'dart:async';
import 'package:rekap_keuangan/models/kategori.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';

class UbahKategoriState {
  final bool isDuplicate;
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;
  final bool isLoaded;
  final bool isDeleted;
  Map<String, dynamic> kategoridata;
  UbahKategoriState({
    this.isDuplicate: false,
    this.isFailure: false,
    this.isLoading: false,
    this.isSuccess: false,
    this.isLoaded: false,
    this.isDeleted: false,
    this.kategoridata,
  });
}

abstract class UbahKategoriEvent {}

class GetkategorieditdataEvent extends UbahKategoriEvent {
  var kdkategori;

  GetkategorieditdataEvent({this.kdkategori});
}

class EditkategoriEvent extends UbahKategoriEvent {
  var kdkategori,
      namakategori,
      jenis,
      codepoint,
      fontfamily,
      fontpackage,
      color;

  EditkategoriEvent(
      {this.kdkategori,
      this.namakategori,
      this.jenis,
      this.codepoint,
      this.fontfamily,
      this.fontpackage,
      this.color});
}

class DeletekategoriEvent extends UbahKategoriEvent {
  var kdkategori;

  DeletekategoriEvent({this.kdkategori});
}

class UbahKategoriBloc extends Bloc<UbahKategoriEvent, UbahKategoriState> {
  UbahKategoriBloc() : super(UbahKategoriState());

  @override
  Stream<UbahKategoriState> mapEventToState(UbahKategoriEvent event) async* {
    final _repository = MyRepository();
    print('masukbloc');
    UbahKategoriState(isLoading: false);
    UbahKategoriState(isSuccess: false);
    UbahKategoriState(isFailure: false);
    UbahKategoriState(isDuplicate: false);
    UbahKategoriState(isLoaded: false);
    UbahKategoriState(isDeleted: false);
    UbahKategoriState(kategoridata: {});
    try {
      if (event is GetkategorieditdataEvent) {
        yield UbahKategoriState(isLoading: true);
        List<Map<String, dynamic>> arrBack =
            await _repository.getdatakategori(event.kdkategori);
        if (arrBack.length > 0) {
          yield UbahKategoriState(kategoridata: arrBack[0], isLoaded: true);
        }
      } else if (event is EditkategoriEvent) {
        yield UbahKategoriState(isLoading: true);
        int countkategori = await _repository.countkategoriedit(
            event.kdkategori, event.namakategori);

        if (countkategori == 0) {
          final Kategori mKategori = new Kategori(
              kdkategori: event.kdkategori,
              namakategori: event.namakategori,
              jenis: event.jenis,
              codepoint: event.codepoint,
              fontfamily: event.fontfamily,
              fontpackage: event.fontpackage,
              color: event.color);
          await _repository.updatekategori(mKategori);
          yield UbahKategoriState(isSuccess: true);
        } else {
          yield UbahKategoriState(isDuplicate: true);
        }
      } else if (event is DeletekategoriEvent) {
        yield UbahKategoriState(isLoading: true);
        await _repository.deletetransaksikategori(event.kdkategori);
        await _repository.deletekategori(event.kdkategori);
        yield UbahKategoriState(isDeleted: true);
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield UbahKategoriState(isFailure: true);
    }
  }
}
