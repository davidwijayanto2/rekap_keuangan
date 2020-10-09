import 'dart:async';
import 'package:rekap_keuangan/models/kategori.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rekap_keuangan/repositories/my_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';

class TambahKategoriState {
  final bool isDuplicate;
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;
  TambahKategoriState(
      {this.isDuplicate: false,
      this.isFailure: false,
      this.isLoading: false,
      this.isSuccess: false});
}

abstract class TambahKategoriEvent {}

class SetkategoriEvent extends TambahKategoriEvent {
  var namakategori, jenis, codepoint, fontfamily, fontpackage, color;

  SetkategoriEvent(
      {this.namakategori,
      this.jenis,
      this.codepoint,
      this.fontfamily,
      this.fontpackage,
      this.color});
}

class TambahKategoriBloc
    extends Bloc<TambahKategoriEvent, TambahKategoriState> {
  TambahKategoriBloc() : super(TambahKategoriState());

  @override
  Stream<TambahKategoriState> mapEventToState(
      TambahKategoriEvent event) async* {
    final _repository = MyRepository();
    print('masukbloc');
    TambahKategoriState(isLoading: false);
    TambahKategoriState(isSuccess: false);
    TambahKategoriState(isFailure: false);
    TambahKategoriState(isDuplicate: false);
    try {
      if (event is SetkategoriEvent) {
        print('masukevent');
        yield TambahKategoriState(isLoading: true);
        int countkategori =
            await _repository.countkategorinama(event.namakategori);
        if (countkategori == 0) {
          final Kategori mKategori = new Kategori(
              namakategori: event.namakategori,
              jenis: event.jenis,
              codepoint: event.codepoint,
              fontfamily: event.fontfamily,
              fontpackage: event.fontpackage,
              color: event.color);
          await _repository.setkategori(mKategori);
          yield TambahKategoriState(isSuccess: true);
        } else {
          yield TambahKategoriState(isDuplicate: true);
        }
      }
    } catch (e) {
      print('message failure: ' + e.toString());
      yield TambahKategoriState(isFailure: true);
    }
  }
}
