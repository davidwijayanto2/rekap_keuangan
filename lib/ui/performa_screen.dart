import 'dart:async';
import 'dart:math';

import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as chartText;
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:rekap_keuangan/blocs/performa_bloc.dart';
import 'package:rekap_keuangan/ui/main_screen.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PerformaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => PerformaBloc(),
        child: Scaffold(
            body: SafeArea(
          child: PerformaScreenBody(),
        )));
  }
}

class PerformaScreenBody extends StatefulWidget {
  @override
  _PerformaScreenState createState() => _PerformaScreenState();
}

class _PerformaScreenState extends State<PerformaScreenBody> {
  var mTanggalmulai, mTanggalakhir;
  List<String> arrtanggal = [];
  PerformaBloc _performaBloc;
  final _nativeAdController = NativeAdmobController();
  double _height = 0;
  StreamSubscription _subscription;
  @override
  void initState() {
    mTanggalmulai = DateFormat('yyyy-MM-dd')
        .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
    for (int i = 0; i < 6; i++) {
      arrtanggal.add(DateFormat('yyyy-MM')
          .format(DateTime(DateTime.now().year, DateTime.now().month - i, 1)));
    }
    mTanggalakhir = MyConst.subDateFormat(
        DateFormat('yyyy-MM-dd')
            .format(DateTime(DateTime.now().year, DateTime.now().month + 1, 1)),
        1);
    _performaBloc = BlocProvider.of<PerformaBloc>(context);
    _performaBloc.add(GetperformaEvent(
        kddompet: MainScreen.mDompet.kddompet,
        tanggalmulai: mTanggalmulai,
        tanggalakhir: mTanggalakhir,
        arrtanggal: arrtanggal));
    super.initState();
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
    _nativeAdController.dispose();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _height = MyScreens.safeVertical * 12;
        });
        // MyConst.adsdelay = true;
        // MyConst.adstimer = 70;
        // MyConst.setAdsTimer();
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    MyScreens().initScreen(context);
    return BlocBuilder(
        cubit: _performaBloc,
        builder: (context, state) {
          if (state is PerformaLoadingState) {
            return MyWidgets.buildLoadingWidget(context);
          } else if (state is PerformaLoadedState) {
            Map<String, dynamic> mapperforma = state.mapperforma;
            return Scaffold(
              appBar: AppBar(
                title: Text("Performa"),
                backgroundColor: MyColors.blue,
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(FontAwesomeIcons.arrowLeft),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                              width: MyScreens.safeHorizontal * 7.5,
                              child: Center(
                                  child: FaIcon(
                                FontAwesomeIcons.chevronLeft,
                                color: Colors.white,
                              ))),
                          onTap: () {
                            setState(() {
                              // mTanggalmulaigrafik = MyConst.subDateFormat(
                              //     DateFormat('yyyy-MM-dd').format(DateTime(
                              //         DateTime.parse(mTanggalmulaigrafik).year,
                              //         DateTime.parse(mTanggalmulaigrafik)
                              //                 .month -
                              //             1,
                              //         1)),
                              //     1);

                              mTanggalmulai = DateFormat('yyyy-MM-dd').format(
                                  DateTime(
                                      DateTime.parse(mTanggalmulai).year,
                                      DateTime.parse(mTanggalmulai).month - 1,
                                      1));

                              mTanggalakhir = MyConst.subDateFormat(
                                  DateFormat('yyyy-MM-dd').format(DateTime(
                                      DateTime.parse(mTanggalakhir).year,
                                      DateTime.parse(mTanggalakhir).month,
                                      1)),
                                  1);
                              print('tangalmulai' + mTanggalmulai);
                              print('tanggalakhir' + mTanggalakhir);
                              for (int i = 0; i < 6; i++) {
                                arrtanggal[i] = DateFormat('yyyy-MM').format(
                                    DateTime(
                                        DateTime.parse(mTanggalakhir).year,
                                        DateTime.parse(mTanggalakhir).month - i,
                                        1));
                              }
                              _performaBloc.add(GetperformaEvent(
                                  kddompet: MainScreen.mDompet.kddompet,
                                  tanggalmulai: mTanggalmulai,
                                  tanggalakhir: mTanggalakhir,
                                  arrtanggal: arrtanggal));
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            width: MyScreens.safeHorizontal * 30,
                            child: Center(
                              child: Text(
                                DateFormat.MMM('id')
                                        .format(DateTime.parse(mTanggalakhir)) +
                                    DateFormat(' yyyy')
                                        .format(DateTime.parse(mTanggalakhir)),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          onTap: () {
                            showMonthPicker(
                                    context: context,
                                    initialDate: new DateFormat('yyyy-MM-dd')
                                        .parse(mTanggalmulai),
                                    firstDate:
                                        new DateTime(DateTime.now().year - 10),
                                    lastDate:
                                        new DateTime(DateTime.now().year + 7),
                                    locale: Locale('id'))
                                .then((picked) {
                              if (picked != null) {
                                setState(() {
                                  mTanggalmulai = DateFormat('yyyy-MM-dd')
                                      .format(DateTime(
                                          picked.year, picked.month, 1));
                                  mTanggalakhir = MyConst.subDateFormat(
                                      DateFormat('yyyy-MM-dd').format(DateTime(
                                          picked.year, picked.month + 1, 1)),
                                      1);
                                  for (int i = 0; i < 6; i++) {
                                    arrtanggal[i] = DateFormat('yyyy-MM')
                                        .format(DateTime(
                                            DateTime.parse(mTanggalakhir).year,
                                            DateTime.parse(mTanggalakhir)
                                                    .month -
                                                i,
                                            1));
                                  }
                                  _performaBloc.add(GetperformaEvent(
                                      kddompet: MainScreen.mDompet.kddompet,
                                      tanggalmulai: mTanggalmulai,
                                      tanggalakhir: mTanggalakhir,
                                      arrtanggal: arrtanggal));
                                });
                              }
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                              width: MyScreens.safeHorizontal * 7.5,
                              child: Center(
                                  child: FaIcon(
                                FontAwesomeIcons.chevronRight,
                                color: Colors.white,
                              ))),
                          onTap: () {
                            setState(() {
                              mTanggalmulai = DateFormat('yyyy-MM-dd').format(
                                  DateTime(
                                      DateTime.parse(mTanggalmulai).year,
                                      DateTime.parse(mTanggalmulai).month + 1,
                                      1));
                              mTanggalakhir = MyConst.subDateFormat(
                                  DateFormat('yyyy-MM-dd').format(DateTime(
                                      DateTime.parse(mTanggalakhir).year,
                                      DateTime.parse(mTanggalakhir).month + 2,
                                      1)),
                                  1);
                              for (int i = 0; i < 6; i++) {
                                arrtanggal[i] = DateFormat('yyyy-MM').format(
                                    DateTime(
                                        DateTime.parse(mTanggalakhir).year,
                                        DateTime.parse(mTanggalakhir).month - i,
                                        1));
                              }
                              _performaBloc.add(GetperformaEvent(
                                  kddompet: MainScreen.mDompet.kddompet,
                                  tanggalmulai: mTanggalmulai,
                                  tanggalakhir: mTanggalakhir,
                                  arrtanggal: arrtanggal));
                            });
                          },
                        )
                      ])
                ],
              ),
              body: SafeArea(
                  child: Column(
                children: <Widget>[
                  Flexible(
                      child: ListView(
                    children: <Widget>[
                      Container(
                          height: _height,
                          padding: EdgeInsets.all(MyScreens.safeVertical * 1),
                          margin: EdgeInsets.only(
                              bottom: MyScreens.safeVertical * 1),
                          //   child: (!MyConst.adsdelay)
                          //       ? NativeAdmob(
                          //           adUnitID: MyConst.nativeAdsUnitID,
                          //           controller: _nativeAdController,
                          //           type: NativeAdmobType.banner,
                          //         )
                          //       : null,
                          // ),
                          child: NativeAdmob(
                            adUnitID: MyConst.nativeAdsUnitID,
                            controller: _nativeAdController,
                            type: NativeAdmobType.banner,
                          )),
                      saldosection(mapperforma['sumsaldo'][0],
                          mapperforma['sumtransaksi'][0]),
                      timechartsection(mapperforma['sumsaldoperbulan']),
                      barchartsection(
                          mapperforma['sumtransaksinontransferperbulan']),
                      //listtransaksi(maptransaksi),
                      Container(
                        height: MyScreens.safeVertical * 10,
                      )
                    ],
                  ))
                ],
              )),
            );
          } else if (state is PerformaFailedState) {
            return Scaffold(
              appBar: AppBar(
                title: Text(MainScreen.mDompet.namadompet),
                backgroundColor: MyColors.blue,
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(FontAwesomeIcons.arrowLeft),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                              width: MyScreens.safeHorizontal * 7.5,
                              child: Center(
                                  child: FaIcon(
                                FontAwesomeIcons.chevronLeft,
                                color: Colors.white,
                              ))),
                          onTap: () {
                            setState(() {
                              // mTanggalmulaigrafik = MyConst.subDateFormat(
                              //     DateFormat('yyyy-MM-dd').format(DateTime(
                              //         DateTime.parse(mTanggalmulaigrafik).year,
                              //         DateTime.parse(mTanggalmulaigrafik)
                              //                 .month -
                              //             1,
                              //         1)),
                              //     1);

                              mTanggalmulai = DateFormat('yyyy-MM-dd').format(
                                  DateTime(
                                      DateTime.parse(mTanggalmulai).year,
                                      DateTime.parse(mTanggalmulai).month - 1,
                                      1));
                              mTanggalakhir = MyConst.subDateFormat(
                                  DateFormat('yyyy-MM-dd').format(DateTime(
                                      DateTime.parse(mTanggalakhir).year,
                                      DateTime.parse(mTanggalakhir).month - 1,
                                      DateTime.parse(mTanggalakhir).day)),
                                  1);
                              for (int i = 0; i < 6; i++) {
                                arrtanggal[i] = DateFormat('yyyy-MM').format(
                                    DateTime(
                                        DateTime.parse(mTanggalakhir).year,
                                        DateTime.parse(mTanggalakhir).month - i,
                                        1));
                              }
                              _performaBloc.add(GetperformaEvent(
                                  kddompet: MainScreen.mDompet.kddompet,
                                  tanggalmulai: mTanggalmulai,
                                  tanggalakhir: mTanggalakhir,
                                  arrtanggal: arrtanggal));
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            width: MyScreens.safeHorizontal * 30,
                            child: Center(
                              child: Text(
                                DateFormat.MMMM('id')
                                        .format(DateTime.parse(mTanggalakhir)) +
                                    DateFormat(' yyyy')
                                        .format(DateTime.parse(mTanggalakhir)),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          onTap: () {
                            showMonthPicker(
                                    context: context,
                                    initialDate: new DateFormat('yyyy-MM-dd')
                                        .parse(mTanggalmulai),
                                    firstDate:
                                        new DateTime(DateTime.now().year - 10),
                                    lastDate:
                                        new DateTime(DateTime.now().year + 7),
                                    locale: Locale('id'))
                                .then((picked) {
                              if (picked != null) {
                                setState(() {
                                  mTanggalmulai = DateFormat('yyyy-MM-dd')
                                      .format(DateTime(
                                          picked.year, picked.month, 1));
                                  mTanggalakhir = MyConst.subDateFormat(
                                      DateFormat('yyyy-MM-dd').format(DateTime(
                                          picked.year, picked.month + 1, 1)),
                                      1);
                                  for (int i = 0; i < 6; i++) {
                                    arrtanggal[i] = DateFormat('yyyy-MM')
                                        .format(DateTime(
                                            DateTime.parse(mTanggalakhir).year,
                                            DateTime.parse(mTanggalakhir)
                                                    .month -
                                                i,
                                            1));
                                  }
                                  _performaBloc.add(GetperformaEvent(
                                      kddompet: MainScreen.mDompet.kddompet,
                                      tanggalmulai: mTanggalmulai,
                                      tanggalakhir: mTanggalakhir,
                                      arrtanggal: arrtanggal));
                                });
                              }
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                              width: MyScreens.safeHorizontal * 7.5,
                              child: Center(
                                  child: FaIcon(
                                FontAwesomeIcons.chevronRight,
                                color: Colors.white,
                              ))),
                          onTap: () {
                            setState(() {
                              mTanggalmulai = DateFormat('yyyy-MM-dd').format(
                                  DateTime(
                                      DateTime.parse(mTanggalmulai).year,
                                      DateTime.parse(mTanggalmulai).month + 1,
                                      1));
                              mTanggalakhir = MyConst.subDateFormat(
                                  DateFormat('yyyy-MM-dd').format(DateTime(
                                      DateTime.parse(mTanggalakhir).year,
                                      DateTime.parse(mTanggalakhir).month + 1,
                                      DateTime.parse(mTanggalakhir).day)),
                                  1);
                              for (int i = 0; i < 6; i++) {
                                arrtanggal[i] = DateFormat('yyyy-MM').format(
                                    DateTime(
                                        DateTime.parse(mTanggalakhir).year,
                                        DateTime.parse(mTanggalakhir).month - i,
                                        1));
                              }
                              _performaBloc.add(GetperformaEvent(
                                  kddompet: MainScreen.mDompet.kddompet,
                                  tanggalmulai: mTanggalmulai,
                                  tanggalakhir: mTanggalakhir,
                                  arrtanggal: arrtanggal));
                            });
                          },
                        )
                      ])
                ],
              ),
              body: SafeArea(
                  child: Column(
                children: <Widget>[
                  Flexible(
                      child: ListView(
                    children: <Widget>[
                      Container(
                          height: _height,
                          padding: EdgeInsets.all(MyScreens.safeVertical * 1),
                          margin: EdgeInsets.only(
                              bottom: MyScreens.safeVertical * 1),
                          //   child: (!MyConst.adsdelay)
                          //       ? NativeAdmob(
                          //           adUnitID: MyConst.nativeAdsUnitID,
                          //           controller: _nativeAdController,
                          //           type: NativeAdmobType.banner,
                          //         )
                          //       : null,
                          // ),
                          child: NativeAdmob(
                            adUnitID: MyConst.nativeAdsUnitID,
                            controller: _nativeAdController,
                            type: NativeAdmobType.banner,
                          )),
                      Flexible(
                          child: Container(
                        alignment: Alignment.center,
                        child: Text('Gagal memuat transaksi'),
                      ))
                    ],
                  ))
                ],
              )),
            );
          } else {
            return Container();
          }
        });
  }

  Widget saldosection(sumsaldo, sumtransaksi) {
    return Container(
        margin: EdgeInsets.only(
            top: MyScreens.safeVertical * 2,
            right: MyScreens.safeHorizontal * 2,
            left: MyScreens.safeHorizontal * 2,
            bottom: MyScreens.safeVertical * 2),
        padding: EdgeInsets.only(
            right: MyScreens.safeHorizontal * 3,
            left: MyScreens.safeHorizontal * 3,
            bottom: MyScreens.safeVertical * 2,
            top: MyScreens.safeVertical * 1),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(
                Radius.circular(MyScreens.safeVertical * 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Saldo - ' + MainScreen.mDompet.namadompet,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(
              height: MyScreens.safeVertical * 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MyScreens.safeHorizontal * 42.5,
                  margin:
                      EdgeInsets.only(right: MyScreens.safeHorizontal * 2.5),
                  decoration: BoxDecoration(
                      border: Border(
                          right:
                              BorderSide(width: 1, color: MyColors.graylight))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Awal Periode',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Rp. ' +
                            MyConst.thousandseparator(sumsaldo['saldoawal']),
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
                Container(
                    width: MyScreens.safeHorizontal * 42.5,
                    margin:
                        EdgeInsets.only(left: MyScreens.safeHorizontal * 2.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Akhir Periode', style: TextStyle(fontSize: 12)),
                        Text(
                            'Rp. ' +
                                MyConst.thousandseparator(
                                    sumsaldo['saldoakhir']),
                            style: TextStyle(fontSize: 16))
                      ],
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: MyScreens.safeHorizontal * 42.5,
                    margin: EdgeInsets.only(top: MyScreens.safeVertical * 2),
                    padding: EdgeInsets.only(
                        right: MyScreens.safeHorizontal * 2,
                        left: MyScreens.safeHorizontal * 2,
                        bottom: MyScreens.safeVertical * 1,
                        top: MyScreens.safeVertical * 1),
                    decoration: BoxDecoration(
                        color: MyColors.green,
                        borderRadius: new BorderRadius.all(
                            Radius.circular(MyScreens.safeVertical * 1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Arus Masuk',
                            style: TextStyle(
                                fontSize: MyScreens.safeVertical * 1.7,
                                color: Colors.white)),
                        Text(
                            'Rp. ' +
                                MyConst.thousandseparator(
                                    sumtransaksi['summasuk']),
                            style: TextStyle(
                                fontSize: MyScreens.safeVertical * 1.7,
                                color: Colors.white))
                      ],
                    )),
                Container(
                    width: MyScreens.safeHorizontal * 42.5,
                    margin: EdgeInsets.only(top: MyScreens.safeVertical * 2),
                    padding: EdgeInsets.only(
                        right: MyScreens.safeHorizontal * 2,
                        left: MyScreens.safeHorizontal * 2,
                        bottom: MyScreens.safeVertical * 1,
                        top: MyScreens.safeVertical * 1),
                    decoration: BoxDecoration(
                        color: MyColors.red,
                        borderRadius: new BorderRadius.all(
                            Radius.circular(MyScreens.safeVertical * 1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Arus Keluar',
                            style: TextStyle(
                                fontSize: MyScreens.safeVertical * 1.7,
                                color: Colors.white)),
                        Text(
                            'Rp. ' +
                                MyConst.thousandseparator(
                                    sumtransaksi['sumkeluar']),
                            style: TextStyle(
                                fontSize: MyScreens.safeVertical * 1.7,
                                color: Colors.white))
                      ],
                    )),
              ],
            )
          ],
        ));
  }

  Widget timechartsection(sumsaldoperbulan) {
    return Container(
        margin: EdgeInsets.only(
            right: MyScreens.safeHorizontal * 2,
            left: MyScreens.safeHorizontal * 2,
            bottom: MyScreens.safeVertical * 2),
        padding: EdgeInsets.only(
            right: MyScreens.safeHorizontal * 3,
            left: MyScreens.safeHorizontal * 3,
            bottom: MyScreens.safeVertical * 1,
            top: MyScreens.safeVertical * 1),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(
                Radius.circular(MyScreens.safeVertical * 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Saldo Bulanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: MyScreens.safeVertical * 30,
              child: TimeChartWidget(sumsaldoperbulan: sumsaldoperbulan),
            )
          ],
        ));
  }

  Widget barchartsection(sumtransaksiperbulan) {
    return Container(
        margin: EdgeInsets.only(
            right: MyScreens.safeHorizontal * 2,
            left: MyScreens.safeHorizontal * 2,
            bottom: MyScreens.safeVertical * 2),
        padding: EdgeInsets.only(
            right: MyScreens.safeHorizontal * 3,
            left: MyScreens.safeHorizontal * 3,
            bottom: MyScreens.safeVertical * 1,
            top: MyScreens.safeVertical * 1),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(
                Radius.circular(MyScreens.safeVertical * 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Pemasukan & Pengeluaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: MyScreens.safeVertical * 30,
              child: BarChartWidget(sumtransaksiperbulan: sumtransaksiperbulan),
            )
          ],
        ));
  }
}

class TimeSeries {
  final String time;
  final int saldo;
  TimeSeries(this.time, this.saldo);
}

class TimeChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> sumsaldoperbulan;
  TimeChartWidget({this.sumsaldoperbulan});

  @override
  Widget build(BuildContext context) {
    return TimeChartStateful(
      sumsaldoperbulan: this.sumsaldoperbulan,
    );
  }
}

class TimeChartStateful extends StatefulWidget {
  final List<Map<String, dynamic>> sumsaldoperbulan;
  @override
  TimeChartState createState() => TimeChartState();
  TimeChartStateful({this.sumsaldoperbulan, Key key}) : super(key: key);
}

class TimeChartState extends State<TimeChartStateful> {
  List<charts.Series> seriesList;
  static String pointerValue;
  List<charts.Series<TimeSeries, String>> _createSampleData() {
    List<TimeSeries> data = [];
    //var flagyear = '',
    var strdate = '';
    for (int i = 0; i < widget.sumsaldoperbulan.length; i++) {
      //List<String> dateexplode = widget.sumsaldoperbulan[i]['bulan'].split('-');
      if (i == 0) {
        strdate = DateFormat.MMM('id').format(DateTime(
                DateTime.parse(widget.sumsaldoperbulan[i]['bulan'] + '-01')
                    .year,
                DateTime.parse(widget.sumsaldoperbulan[i]['bulan'] + '-01')
                    .month,
                1)) +
            DateFormat(' yy').format(DateTime(
                DateTime.parse(widget.sumsaldoperbulan[i]['bulan'] + '-01')
                    .year,
                DateTime.parse(widget.sumsaldoperbulan[i]['bulan'] + '-01')
                    .month,
                1));
      } else {
        strdate = DateFormat.MMM('id').format(DateTime(
            DateTime.parse(widget.sumsaldoperbulan[i]['bulan'] + '-01').year,
            DateTime.parse(widget.sumsaldoperbulan[i]['bulan'] + '-01').month,
            1));
      }
      data.add(
          new TimeSeries(strdate, widget.sumsaldoperbulan[i]['saldo'].round()));
    }
    return [
      new charts.Series<TimeSeries, String>(
        id: 'Saldo',
        domainFn: (TimeSeries gauge, _) => gauge.time,
        measureFn: (TimeSeries gauge, _) => gauge.saldo,
        measureUpperBoundFn: (TimeSeries sales, _) => sales.saldo + 100000,
        measureLowerBoundFn: (TimeSeries sales, _) => sales.saldo - 50000,
        areaColorFn: (TimeSeries gauge, _) => charts.Color.transparent,
        colorFn: (TimeSeries gauge, _) => charts.Color.fromHex(code: '#ff6600'),
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    seriesList = _createSampleData();
    return new charts.OrdinalComboChart(seriesList,
        animate: false,
        behaviors: [
          charts.LinePointHighlighter(
              symbolRenderer: CustomCircleSymbolRenderer())
        ],
        selectionModels: [
          charts.SelectionModelConfig(
              changedListener: (charts.SelectionModel model) {
            if (model.hasDatumSelection) {
              pointerValue = MyConst.thousandseparator(model.selectedSeries[0]
                  .measureFn(model.selectedDatum[0].index));
            }
          })
        ],
        primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(desiredTickCount: 5),
        ),
        defaultRenderer: new charts.LineRendererConfig(
          includePoints: true,
        ));
  }
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  var size = MyScreens.safeHorizontal * 100;
  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.FillPatternType fillPattern,
      charts.Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    num tipTextLen = ("Saldo " + TimeChartState.pointerValue).length;
    num rectWidth = bounds.width + tipTextLen * 8.3;
    num rectHeight = bounds.height + 10;
    num left = bounds.left > (size ?? 300) / 2
        ? (bounds.left > size / 4
            ? bounds.left - rectWidth
            : bounds.left - rectWidth / 2)
        : bounds.left - 40;
    canvas.drawRect(Rectangle(left, bounds.top - 30, rectWidth, rectHeight),
        fill: charts.Color.fromHex(code: "#666666"));
    var textStyle = chartText.TextStyle();
    textStyle.color = charts.Color.white;
    textStyle.fontSize = 15;
    canvas.drawText(
        TextElement("Saldo: " + TimeChartState.pointerValue, style: textStyle),
        left.round() + 5,
        (bounds.top - 28).round());
  }
}

class BarSeries {
  final String time;
  final int transaksi;
  BarSeries(this.time, this.transaksi);
}

class BarChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> sumtransaksiperbulan;
  BarChartWidget({this.sumtransaksiperbulan});

  @override
  Widget build(BuildContext context) {
    return BarChartStateful(
      sumtransaksiperbulan: this.sumtransaksiperbulan,
    );
  }
}

class BarChartStateful extends StatefulWidget {
  final List<Map<String, dynamic>> sumtransaksiperbulan;
  @override
  BarChartState createState() => BarChartState();
  BarChartStateful({this.sumtransaksiperbulan, Key key}) : super(key: key);
}

class BarChartState extends State<BarChartStateful> {
  static String pointerValue;
  List<charts.Series> seriesList;
  List<charts.Series<BarSeries, String>> _createSampleData() {
    var flagyear = '', strdate = '';
    List<BarSeries> datakeluar = [];
    List<BarSeries> datamasuk = [];
    for (int i = 0; i < widget.sumtransaksiperbulan.length; i++) {
      List<String> dateexplode =
          widget.sumtransaksiperbulan[i]['bulan'].split('-');
      if (dateexplode[0] == flagyear) {
        strdate = DateFormat.MMM('id').format(DateTime(
            DateTime.parse(widget.sumtransaksiperbulan[i]['bulan'] + '-01')
                .year,
            DateTime.parse(widget.sumtransaksiperbulan[i]['bulan'] + '-01')
                .month,
            1));
      } else {
        strdate = DateFormat.MMM('id').format(DateTime(
                DateTime.parse(widget.sumtransaksiperbulan[i]['bulan'] + '-01')
                    .year,
                DateTime.parse(widget.sumtransaksiperbulan[i]['bulan'] + '-01')
                    .month,
                1)) +
            DateFormat(' yy').format(DateTime(
                DateTime.parse(widget.sumtransaksiperbulan[i]['bulan'] + '-01')
                    .year,
                DateTime.parse(widget.sumtransaksiperbulan[i]['bulan'] + '-01')
                    .month,
                1));
        flagyear = dateexplode[0];
      }
      datakeluar.add(new BarSeries(
          strdate, widget.sumtransaksiperbulan[i]['sumkeluar'].round()));
      datamasuk.add(new BarSeries(
          strdate, widget.sumtransaksiperbulan[i]['summasuk'].round()));
    }
    return [
      new charts.Series<BarSeries, String>(
        id: 'Masuk',
        domainFn: (BarSeries gauge, _) => gauge.time,
        measureFn: (BarSeries gauge, _) => gauge.transaksi,
        measureUpperBoundFn: (BarSeries sales, _) => sales.transaksi + 100000,
        measureLowerBoundFn: (BarSeries sales, _) => 0,
        areaColorFn: (BarSeries gauge, _) => charts.Color.transparent,
        colorFn: (BarSeries gauge, _) => charts.Color.fromHex(code: '#42C856'),
        data: datamasuk,
      ),
      new charts.Series<BarSeries, String>(
        id: 'Keluar',
        domainFn: (BarSeries gauge, _) => gauge.time,
        measureFn: (BarSeries gauge, _) => gauge.transaksi,
        measureUpperBoundFn: (BarSeries sales, _) => sales.transaksi + 100000,
        measureLowerBoundFn: (BarSeries sales, _) => 0,
        areaColorFn: (BarSeries gauge, _) => charts.Color.transparent,
        colorFn: (BarSeries gauge, _) => charts.Color.fromHex(code: '#EC6853'),
        data: datakeluar,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    seriesList = _createSampleData();
    return new charts.BarChart(
      seriesList,
      animate: false,
      // behaviors: [
      //   charts.LinePointHighlighter(symbolRenderer: CustomBarSymbolRenderer())
      // ],
      // selectionModels: [
      //   charts.SelectionModelConfig(
      //       changedListener: (charts.SelectionModel model) {
      //     if (model.hasDatumSelection) {
      //       pointerValue = MyConst.thousandseparator(model.selectedSeries[0]
      //           .measureFn(model.selectedDatum[0].index));
      //     }
      //   })
      // ],
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec:
            new charts.BasicNumericTickProviderSpec(desiredTickCount: 4),
      ),
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }
}

class CustomBarSymbolRenderer extends charts.CircleSymbolRenderer {
  var size = MyScreens.safeHorizontal * 100;
  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.FillPatternType fillPattern,
      charts.Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    num tipTextLen = ("Saldo " + BarChartState.pointerValue).length;
    num rectWidth = bounds.width + tipTextLen * 8.3;
    num rectHeight = bounds.height + 10;
    num left = bounds.left > (size ?? 300) / 2
        ? (bounds.left > size / 4
            ? bounds.left - rectWidth
            : bounds.left - rectWidth / 2)
        : bounds.left - 40;
    canvas.drawRect(Rectangle(left, bounds.top - 30, rectWidth, rectHeight),
        fill: charts.Color.fromHex(code: "#666666"));
    var textStyle = chartText.TextStyle();
    textStyle.color = charts.Color.white;
    textStyle.fontSize = 15;
    canvas.drawText(
        TextElement("Saldo: " + BarChartState.pointerValue, style: textStyle),
        left.round() + 5,
        (bounds.top - 28).round());
  }
}
