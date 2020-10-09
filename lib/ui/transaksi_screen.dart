import 'package:rekap_keuangan/blocs/main_bloc.dart';
import 'package:rekap_keuangan/blocs/transaksi_bloc.dart';
import 'package:rekap_keuangan/ui/main_screen.dart';
import 'package:rekap_keuangan/ui/performa_screen.dart';
import 'package:rekap_keuangan/ui/rekap_screen.dart';
import 'package:rekap_keuangan/ui/tambahtransaksi_screen.dart';
import 'package:rekap_keuangan/ui/ubahtransaksi_screen.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import 'listdompet_screen.dart';

class TransaksiScreen extends StatelessWidget {
  TransaksiScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.bluesharp, //or set color with: Color(0xFF0000FF)
    ));
    return BlocProvider(
        create: (BuildContext context) => TransaksiBloc(),
        child: TransaksiScreenBody());
  }
}

class TransaksiScreenBody extends StatefulWidget {
  @override
  _TransaksiScreenState createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreenBody> {
  _TransaksiScreenState({Key key});
  List<Widget> listtransaksiwidget = <Widget>[];
  TransaksiBloc _transaksiBloc;
  MainScreen mainscreen = MainScreen();
  Icon mIcon;
  Color mColor, mColorpicked, mColorbg, mColorbgpicked;
  @override
  void initState() {
    _transaksiBloc = BlocProvider.of<TransaksiBloc>(context);
    _transaksiBloc.add(GetalltransaksiEvent(
        kddompet: MainScreen.mDompet.kddompet,
        tanggalmulai: MainScreen.mTanggalmulai,
        tanggalakhir: MainScreen.mTanggalakhir));
    mColor = MyColors.darkgray;
    mColorpicked = Colors.white;
    mColorbg = Colors.white;
    mColorbgpicked = MyColors.bluesharp;
    // //mIcon = Icon(
    //   IconData(MainScreen.mDompet.codepoint,
    //       fontFamily: MainScreen.mDompet.fontfamily,
    //       fontPackage: MainScreen.mDompet.fontpackage),
    //   color: Colors.white,
    // );
    //mColor = MainScreen.mDompet.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyScreens().initScreen(context);
    print(MainScreen.indexfilter.toString());
    return BlocBuilder(
        cubit: _transaksiBloc,
        builder: (context, state) {
          if (state is TransaksiLoadingState) {
            return MyWidgets.buildLoadingWidget(context);
          } else if (state is TransaksiLoadedState) {
            Map<String, dynamic> maptransaksi = state.maptransaksi;

            return Scaffold(
                body: SafeArea(
                    child: Column(
                  children: <Widget>[
                    dompetSection(),
                    filterbar(),
                    Flexible(
                        child: ListView(
                      children: <Widget>[
                        saldosection(maptransaksi['sumsaldo'][0],
                            maptransaksi['sumtransaksi'][0]),
                        listtransaksi(maptransaksi),
                        Container(
                          height: MyScreens.safeVertical * 10,
                        )
                      ],
                    ))
                  ],
                )),
                floatingActionButton: FloatingActionButton(
                    backgroundColor: MyColors.blue,
                    child: Icon(FontAwesomeIcons.plus),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TambahTransaksiScreen();
                      })).then((val) {
                        if (val != null) {
                          MainScreen.mainBloc.add(GetdompetEvent(
                              kddompet: MainScreen.mDompet.kddompet));
                          _transaksiBloc.add(GetalltransaksiEvent(
                              kddompet: MainScreen.mDompet.kddompet,
                              tanggalmulai: MainScreen.mTanggalmulai,
                              tanggalakhir: MainScreen.mTanggalakhir));
                        }
                      });
                    }));
          } else if (state is TransaksiLoadFailureState) {
            return Scaffold(
                body: SafeArea(
                    child: Column(children: <Widget>[
                  dompetSection(),
                  filterbar(),
                  Flexible(
                      child: Container(
                    alignment: Alignment.center,
                    child: Text('Gagal memuat transaksi'),
                  ))
                ])),
                floatingActionButton: FloatingActionButton(
                    backgroundColor: MyColors.blue,
                    child: Icon(FontAwesomeIcons.plus),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TambahTransaksiScreen();
                      })).then((val) {
                        if (val != null) {
                          MainScreen.mainBloc.add(GetdompetEvent(
                              kddompet: MainScreen.mDompet.kddompet));
                          _transaksiBloc.add(GetalltransaksiEvent(
                              kddompet: MainScreen.mDompet.kddompet,
                              tanggalmulai: MainScreen.mTanggalmulai,
                              tanggalakhir: MainScreen.mTanggalakhir));
                        }
                      });
                    }));
          } else if (state is TransaksiEmptyState) {
            return Scaffold(
                body: SafeArea(
                    child: Column(children: <Widget>[
                  dompetSection(),
                  filterbar(),
                  Flexible(
                      child: Container(
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Belum ada transaksi'),
                          Text('Klik tombol + untuk menambahkan'),
                        ]),
                  ))
                ])),
                floatingActionButton: FloatingActionButton(
                    backgroundColor: MyColors.blue,
                    child: Icon(FontAwesomeIcons.plus),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TambahTransaksiScreen();
                      })).then((val) {
                        if (val != null) {
                          MainScreen.mainBloc.add(GetdompetEvent(
                              kddompet: MainScreen.mDompet.kddompet));
                          _transaksiBloc.add(GetalltransaksiEvent(
                              kddompet: MainScreen.mDompet.kddompet,
                              tanggalmulai: MainScreen.mTanggalmulai,
                              tanggalakhir: MainScreen.mTanggalakhir));
                        }
                      });
                    }));
          } else {
            return Container();
          }
        });
  }

  Widget dompetSection() {
    return Container(
        margin: EdgeInsets.only(
            left: MyScreens.safeHorizontal * 4,
            right: MyScreens.safeHorizontal * 4,
            top: MyScreens.safeVertical * 2,
            bottom: MyScreens.safeVertical * 2),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ListDompetScreen(
                          kddompetpicked: MainScreen.mDompet.kddompet,
                          semua: 'semua',
                        );
                      }),
                    ).then((val) {
                      //print(val['color']);
                      setState(() {
                        MainScreen.mDompet.kddompet = val['kddompet'];
                        MainScreen.mainBloc
                            .add(GetdompetEvent(kddompet: val['kddompet']));
                        _transaksiBloc.add(GetalltransaksiEvent(
                            kddompet: MainScreen.mDompet.kddompet,
                            tanggalmulai: MainScreen.mTanggalmulai,
                            tanggalakhir: MainScreen.mTanggalakhir));
                      });
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Ink(
                        decoration: ShapeDecoration(
                          color: MyConst.fromHex(MainScreen.mDompet.color),
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(
                            IconData(MainScreen.mDompet.codepoint,
                                fontFamily: MainScreen.mDompet.fontfamily,
                                fontPackage: MainScreen.mDompet.fontpackage),
                            color: Colors.white,
                          ),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return ListDompetScreen(
                                  kddompetpicked: MainScreen.mDompet.kddompet,
                                  semua: 'semua',
                                );
                              }),
                            ).then((val) {
                              //print(val['color']);
                              setState(() {
                                MainScreen.mDompet.kddompet = val['kddompet'];
                                MainScreen.mainBloc.add(
                                    GetdompetEvent(kddompet: val['kddompet']));
                                _transaksiBloc.add(GetalltransaksiEvent(
                                    kddompet: MainScreen.mDompet.kddompet,
                                    tanggalmulai: MainScreen.mTanggalmulai,
                                    tanggalakhir: MainScreen.mTanggalakhir));
                              });
                            });
                          },
                        ),
                      ),
                      Icon(
                        FontAwesomeIcons.caretDown,
                        size: MyScreens.safeHorizontal * 4,
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              left: MyScreens.safeHorizontal * 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                MainScreen.mDompet.namadompet,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MyScreens.safeHorizontal * 4.5),
                              ),
                              Text(
                                'Rp. ' +
                                    MyConst.thousandseparator(
                                        MainScreen.mDompet.saldo),
                                style: TextStyle(color: MyColors.gray),
                              )
                            ],
                          )),
                    ],
                  )),
              IconButton(
                icon: Icon(FontAwesomeIcons.chartBar),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PerformaScreen();
                  }));
                },
              )
            ]));
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
            Text('Saldo',
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

  Widget filterbar() {
    return Container(
      color: MyColors.blue,
      padding: EdgeInsets.only(
          top: MyScreens.safeVertical * 1,
          bottom: MyScreens.safeVertical * 1,
          right: MyScreens.safeHorizontal * 2,
          left: MyScreens.safeHorizontal * 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
          Widget>[
        InkWell(
          child: Container(
              width: MyScreens.safeHorizontal * 7.5,
              child: Center(
                  child: FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.white,
              ))),
          onTap: () {
            if (MainScreen.indexfilter != 1) {
              if (MainScreen.indexfilter == 6) {
                MainScreen.mTanggalmulai = DateFormat('yyyy-MM-dd').format(
                    DateTime(
                        DateTime.parse(MainScreen.mTanggalmulai).year - 1,
                        DateTime.parse(MainScreen.mTanggalmulai).month,
                        DateTime.parse(MainScreen.mTanggalmulai).day));
                MainScreen.mTanggalakhir = DateFormat('yyyy-MM-dd').format(
                    DateTime(
                            DateTime.parse(MainScreen.mTanggalakhir).year, 1, 1)
                        .subtract(Duration(days: 1)));
              } else if (MainScreen.indexfilter == 5) {
                MainScreen.mTanggalmulai = DateFormat('yyyy-MM-dd').format(
                    DateTime(
                        DateTime.parse(MainScreen.mTanggalmulai).year,
                        DateTime.parse(MainScreen.mTanggalmulai).month - 1,
                        DateTime.parse(MainScreen.mTanggalmulai).day));
                MainScreen.mTanggalakhir = DateFormat('yyyy-MM-dd').format(
                    DateTime(DateTime.parse(MainScreen.mTanggalakhir).year,
                            DateTime.parse(MainScreen.mTanggalakhir).month, 1)
                        .subtract(Duration(days: 1)));
              } else {
                MainScreen.mTanggalmulai = MyConst.subDateFormat(
                    MainScreen.mTanggalmulai, MainScreen.range);
                MainScreen.mTanggalakhir = MyConst.subDateFormat(
                    MainScreen.mTanggalakhir, MainScreen.range);
              }
              MyConst.setFilterText();
              _transaksiBloc.add(GetalltransaksiEvent(
                  kddompet: MainScreen.mDompet.kddompet,
                  tanggalmulai: MainScreen.mTanggalmulai,
                  tanggalakhir: MainScreen.mTanggalakhir));
            }
          },
        ),
        InkWell(
          child: Row(children: <Widget>[
            Container(
              child: (MainScreen.range != 0)
                  ? Container(
                      margin:
                          EdgeInsets.only(right: MyScreens.safeHorizontal * 1),
                      padding: EdgeInsets.only(
                          top: MyScreens.safeVertical * 0.1,
                          bottom: MyScreens.safeVertical * 0.1,
                          right: MyScreens.safeHorizontal * 1,
                          left: MyScreens.safeHorizontal * 1),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2)),
                      child: Text(
                        MainScreen.range.toString(),
                        style: TextStyle(color: MyColors.blue),
                      ),
                    )
                  : null,
            ),
            Text(
              MainScreen.filtertext,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Icon(
              FontAwesomeIcons.caretDown,
              color: Colors.white,
              size: MyScreens.safeVertical * 2.5,
            )
          ]),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return Dialog(
                        child: Container(
                      height: MyScreens.safeVertical * 60,
                      width: MyScreens.safeHorizontal * 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Material(
                            color: (MainScreen.indexfilter == 0)
                                ? mColorbgpicked
                                : mColorbg,
                            child: InkWell(
                              child: Container(
                                height: MyScreens.safeVertical * 18,
                                width: MyScreens.safeHorizontal * 80,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.calendar,
                                        color: (MainScreen.indexfilter == 0)
                                            ? mColorpicked
                                            : mColor,
                                      ),
                                      SizedBox(
                                        height: MyScreens.safeVertical * 1,
                                      ),
                                      Text(
                                        'Periode',
                                        style: TextStyle(
                                          color: (MainScreen.indexfilter == 0)
                                              ? mColorpicked
                                              : mColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: MyScreens.safeVertical * 1,
                                      ),
                                      Text(
                                        MainScreen.filtertext,
                                        style: TextStyle(
                                          color: (MainScreen.indexfilter == 0)
                                              ? mColorpicked
                                              : MyColors.gray,
                                        ),
                                      ),
                                    ]),
                              ),
                              onTap: () {
                                if (MainScreen.indexfilter != 0) {
                                  MainScreen.mTanggalmulai =
                                      DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now());
                                  MainScreen.mTanggalakhir =
                                      DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now());
                                }
                                var tempawal = MainScreen.mTanggalmulai;
                                var tempakhir = MainScreen.mTanggalakhir;
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Pilih Tanggal"),
                                        content: PeriodeWidget(
                                            onTanggalMulaiChanged: (value) {
                                          tempawal = value;
                                        }, onTanggalAkhirChanged: (value) {
                                          tempakhir = value;
                                        }),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('CANCEL'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              MainScreen.range = DateTime.parse(
                                                      tempakhir)
                                                  .difference(
                                                      DateTime.parse(tempawal))
                                                  .inDays;
                                              if (MainScreen.range == 0) {
                                                MainScreen.range = 1;
                                              }
                                              MainScreen.indexfilter = 0;
                                              MainScreen.mTanggalmulai =
                                                  tempawal;
                                              MainScreen.mTanggalakhir =
                                                  tempakhir;
                                              MyConst.setFilterText();
                                              _transaksiBloc.add(
                                                  GetalltransaksiEvent(
                                                      kddompet: MainScreen
                                                          .mDompet.kddompet,
                                                      tanggalmulai: MainScreen
                                                          .mTanggalmulai,
                                                      tanggalakhir: MainScreen
                                                          .mTanggalakhir));
                                              Navigator.pop(context, true);
                                            },
                                          )
                                        ],
                                      );
                                    }).then((value) {
                                  if (value != null) {
                                    Navigator.pop(context);
                                  }
                                });
                              },
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Material(
                                color: (MainScreen.indexfilter == 1)
                                    ? mColorbgpicked
                                    : mColorbg,
                                child: InkWell(
                                  child: Container(
                                    height: MyScreens.safeVertical * 14,
                                    width: MyScreens.safeHorizontal * 39.8,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                width: 1,
                                                color: MyColors.light),
                                            right: BorderSide(
                                                width: 1,
                                                color: MyColors.light))),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.infinity,
                                            color: (MainScreen.indexfilter == 1)
                                                ? mColorpicked
                                                : mColor,
                                          ),
                                          SizedBox(
                                            height: MyScreens.safeVertical * 1,
                                          ),
                                          Text(
                                            'Semua',
                                            style: TextStyle(
                                              color:
                                                  (MainScreen.indexfilter == 1)
                                                      ? mColorpicked
                                                      : mColor,
                                            ),
                                          ),
                                        ]),
                                  ),
                                  onTap: () {
                                    MainScreen.range = 0;
                                    MainScreen.indexfilter = 1;
                                    MainScreen.mTanggalmulai = '0000-00-00';
                                    MainScreen.mTanggalakhir = '9999-99-99';
                                    MyConst.setFilterText();
                                    _transaksiBloc.add(GetalltransaksiEvent(
                                        kddompet: MainScreen.mDompet.kddompet,
                                        tanggalmulai: MainScreen.mTanggalmulai,
                                        tanggalakhir:
                                            MainScreen.mTanggalakhir));
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Material(
                                color: (MainScreen.indexfilter == 2)
                                    ? mColorbgpicked
                                    : mColorbg,
                                child: InkWell(
                                  child: Container(
                                    height: MyScreens.safeVertical * 14,
                                    width: MyScreens.safeHorizontal * 39.8,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                width: 1,
                                                color: MyColors.light))),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.calendarDay,
                                            color: (MainScreen.indexfilter == 2)
                                                ? mColorpicked
                                                : mColor,
                                          ),
                                          SizedBox(
                                            height: MyScreens.safeVertical * 1,
                                          ),
                                          Text(
                                            'Pilih Hari',
                                            style: TextStyle(
                                              color:
                                                  (MainScreen.indexfilter == 2)
                                                      ? mColorpicked
                                                      : mColor,
                                            ),
                                          )
                                        ]),
                                  ),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    DateTime picked = await showDatePicker(
                                        context: context,
                                        initialDate: (MainScreen.indexfilter ==
                                                2)
                                            ? new DateFormat('yyyy-MM-dd')
                                                .parse(MainScreen.mTanggalmulai)
                                            : DateTime.now(),
                                        firstDate: new DateTime(
                                            DateTime.now().year - 10),
                                        lastDate: new DateTime(
                                            DateTime.now().year + 7),
                                        locale: Locale('id'));

                                    if (picked != null) {
                                      MainScreen.range = 1;
                                      MainScreen.indexfilter = 2;
                                      MainScreen.mTanggalmulai =
                                          DateFormat('yyyy-MM-dd')
                                              .format(picked);
                                      MainScreen.mTanggalakhir =
                                          DateFormat('yyyy-MM-dd')
                                              .format(picked);
                                      MyConst.setFilterText();
                                      _transaksiBloc.add(GetalltransaksiEvent(
                                          kddompet: MainScreen.mDompet.kddompet,
                                          tanggalmulai:
                                              MainScreen.mTanggalmulai,
                                          tanggalakhir:
                                              MainScreen.mTanggalakhir));
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Material(
                                  color: (MainScreen.indexfilter == 3)
                                      ? mColorbgpicked
                                      : mColorbg,
                                  child: InkWell(
                                    child: Container(
                                      height: MyScreens.safeVertical * 14,
                                      width: MyScreens.safeHorizontal * 39.8,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  width: 1,
                                                  color: MyColors.light),
                                              right: BorderSide(
                                                  width: 1,
                                                  color: MyColors.light))),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Center(
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    FontAwesomeIcons.calendar,
                                                    color: (MainScreen
                                                                .indexfilter ==
                                                            3)
                                                        ? mColorpicked
                                                        : mColor,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: MyScreens
                                                                .safeVertical *
                                                            1),
                                                    child: Text(
                                                      "1",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: (MainScreen
                                                                    .indexfilter ==
                                                                3)
                                                            ? mColorpicked
                                                            : mColor,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  MyScreens.safeVertical * 1,
                                            ),
                                            Text(
                                              'Hari ini',
                                              style: TextStyle(
                                                color:
                                                    (MainScreen.indexfilter ==
                                                            3)
                                                        ? mColorpicked
                                                        : mColor,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  MyScreens.safeVertical * 1,
                                            ),
                                            Text(
                                              DateFormat.E('id')
                                                      .format(DateTime.now()) +
                                                  ', ' +
                                                  DateFormat('dd ')
                                                      .format(DateTime.now()) +
                                                  DateFormat.MMM('id')
                                                      .format(DateTime.now()) +
                                                  DateFormat(' yyyy')
                                                      .format(DateTime.now()),
                                              style: TextStyle(
                                                color:
                                                    (MainScreen.indexfilter ==
                                                            3)
                                                        ? mColorpicked
                                                        : MyColors.gray,
                                              ),
                                            ),
                                          ]),
                                    ),
                                    onTap: () {
                                      MainScreen.range = 1;
                                      MainScreen.indexfilter = 3;
                                      MainScreen.mTanggalmulai =
                                          DateFormat('yyyy-MM-dd')
                                              .format(DateTime.now());
                                      MainScreen.mTanggalakhir =
                                          DateFormat('yyyy-MM-dd')
                                              .format(DateTime.now());
                                      MyConst.setFilterText();
                                      _transaksiBloc.add(GetalltransaksiEvent(
                                          kddompet: MainScreen.mDompet.kddompet,
                                          tanggalmulai:
                                              MainScreen.mTanggalmulai,
                                          tanggalakhir:
                                              MainScreen.mTanggalakhir));
                                      Navigator.pop(context);
                                    },
                                  )),
                              Material(
                                color: (MainScreen.indexfilter == 4)
                                    ? mColorbgpicked
                                    : mColorbg,
                                child: InkWell(
                                  child: Container(
                                    height: MyScreens.safeVertical * 14,
                                    width: MyScreens.safeHorizontal * 39.8,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                width: 1,
                                                color: MyColors.light))),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  FontAwesomeIcons.calendar,
                                                  color:
                                                      (MainScreen.indexfilter ==
                                                              4)
                                                          ? mColorpicked
                                                          : mColor,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: MyScreens
                                                              .safeVertical *
                                                          1),
                                                  child: Text(
                                                    "7",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: (MainScreen
                                                                  .indexfilter ==
                                                              4)
                                                          ? mColorpicked
                                                          : mColor,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: MyScreens.safeVertical * 1,
                                          ),
                                          Text(
                                            'Minggu ini',
                                            style: TextStyle(
                                              color:
                                                  (MainScreen.indexfilter == 4)
                                                      ? mColorpicked
                                                      : mColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: MyScreens.safeVertical * 1,
                                          ),
                                          Text(
                                            (DateTime.parse(MyConst.subDateFormat(
                                                            DateFormat('yyyy-MM-dd').format(
                                                                DateTime.now()),
                                                            (DateTime.now().weekday %
                                                                7)))
                                                        .month ==
                                                    DateTime.parse(MyConst.addDateFormat(DateFormat('yyyy-MM-dd').format(DateTime.now()), 6 - (DateTime.now().weekday % 7)))
                                                        .month)
                                                ? DateFormat('dd ').format(DateTime.parse(MyConst.subDateFormat(DateFormat('yyyy-MM-dd').format(DateTime.now()), (DateTime.now().weekday % 7)))) +
                                                    ' - ' +
                                                    DateFormat('dd ').format(DateTime.parse(
                                                        MyConst.addDateFormat(
                                                            DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                                            6 - (DateTime.now().weekday % 7)))) +
                                                    DateFormat.MMMM('id').format(DateTime.parse(MyConst.addDateFormat(DateFormat('yyyy-MM-dd').format(DateTime.now()), 6 - (DateTime.now().weekday % 7)))) +
                                                    DateFormat(' yyyy').format(DateTime.parse(MyConst.addDateFormat(DateFormat('yyyy-MM-dd').format(DateTime.now()), 6 - (DateTime.now().weekday % 7))))
                                                : DateFormat('dd ').format(DateTime.parse(MyConst.subDateFormat(DateFormat('yyyy-MM-dd').format(DateTime.now()), (DateTime.now().weekday % 7)))) + DateFormat.MMM('id').format(DateTime.parse(MyConst.subDateFormat(DateFormat('yyyy-MM-dd').format(DateTime.now()), (DateTime.now().weekday % 7)))) + ' - ' + DateFormat('dd ').format(DateTime.parse(MyConst.addDateFormat(DateFormat('yyyy-MM-dd').format(DateTime.now()), 6 - (DateTime.now().weekday % 7)))) + DateFormat.MMM('id').format(DateTime.parse(MyConst.addDateFormat(DateFormat('yyyy-MM-dd').format(DateTime.now()), 6 - (DateTime.now().weekday % 7)))) + DateFormat(' yyyy').format(DateTime.parse(MyConst.addDateFormat(DateFormat('yyyy-MM-dd').format(DateTime.now()), 6 - (DateTime.now().weekday % 7)))),
                                            style: TextStyle(
                                              color:
                                                  (MainScreen.indexfilter == 4)
                                                      ? mColorpicked
                                                      : MyColors.gray,
                                            ),
                                          ),
                                        ]),
                                  ),
                                  onTap: () {
                                    MainScreen.range = 7;
                                    MainScreen.indexfilter = 4;
                                    MainScreen.mTanggalmulai =
                                        MyConst.subDateFormat(
                                            DateFormat('yyyy-MM-dd')
                                                .format(DateTime.now()),
                                            (DateTime.now().weekday % 7));
                                    MainScreen.mTanggalakhir =
                                        MyConst.addDateFormat(
                                            DateFormat('yyyy-MM-dd')
                                                .format(DateTime.now()),
                                            6 - (DateTime.now().weekday % 7));
                                    MyConst.setFilterText();
                                    _transaksiBloc.add(GetalltransaksiEvent(
                                        kddompet: MainScreen.mDompet.kddompet,
                                        tanggalmulai: MainScreen.mTanggalmulai,
                                        tanggalakhir:
                                            MainScreen.mTanggalakhir));
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Material(
                                color: (MainScreen.indexfilter == 5)
                                    ? mColorbgpicked
                                    : mColorbg,
                                child: InkWell(
                                  child: Container(
                                    height: MyScreens.safeVertical * 14,
                                    width: MyScreens.safeHorizontal * 39.8,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                width: 1,
                                                color: MyColors.light),
                                            right: BorderSide(
                                                width: 1,
                                                color: MyColors.light))),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  FontAwesomeIcons.calendar,
                                                  color:
                                                      (MainScreen.indexfilter ==
                                                              5)
                                                          ? mColorpicked
                                                          : mColor,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: MyScreens
                                                              .safeVertical *
                                                          0.5,
                                                      top: MyScreens
                                                              .safeVertical *
                                                          1),
                                                  child: Text(
                                                    "31",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: (MainScreen
                                                                  .indexfilter ==
                                                              5)
                                                          ? mColorpicked
                                                          : mColor,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: MyScreens.safeVertical * 1,
                                          ),
                                          Text(
                                            'Bulan ini',
                                            style: TextStyle(
                                              color:
                                                  (MainScreen.indexfilter == 5)
                                                      ? mColorpicked
                                                      : mColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: MyScreens.safeVertical * 1,
                                          ),
                                          Text(
                                            DateFormat.MMMM('id')
                                                    .format(DateTime.now()) +
                                                DateFormat(' yyyy')
                                                    .format(DateTime.now()),
                                            style: TextStyle(
                                              color:
                                                  (MainScreen.indexfilter == 5)
                                                      ? mColorpicked
                                                      : MyColors.gray,
                                            ),
                                          ),
                                        ]),
                                  ),
                                  onTap: () {
                                    MainScreen.range = DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month + 1,
                                            1)
                                        .subtract(Duration(days: 1))
                                        .day;
                                    MainScreen.indexfilter = 5;
                                    MainScreen.mTanggalmulai =
                                        DateFormat('yyyy-MM-dd').format(
                                            DateTime(DateTime.now().year,
                                                DateTime.now().month, 1));
                                    MainScreen.mTanggalakhir =
                                        DateFormat('yyyy-MM-dd').format(
                                            DateTime(DateTime.now().year,
                                                    DateTime.now().month + 1, 1)
                                                .subtract(Duration(days: 1)));
                                    MyConst.setFilterText();
                                    _transaksiBloc.add(GetalltransaksiEvent(
                                        kddompet: MainScreen.mDompet.kddompet,
                                        tanggalmulai: MainScreen.mTanggalmulai,
                                        tanggalakhir:
                                            MainScreen.mTanggalakhir));
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Material(
                                color: (MainScreen.indexfilter == 6)
                                    ? mColorbgpicked
                                    : mColorbg,
                                child: InkWell(
                                  child: Container(
                                    height: MyScreens.safeVertical * 14,
                                    width: MyScreens.safeHorizontal * 39.8,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                width: 1,
                                                color: MyColors.light))),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.calendarAlt,
                                            color: (MainScreen.indexfilter == 6)
                                                ? mColorpicked
                                                : mColor,
                                          ),
                                          SizedBox(
                                            height: MyScreens.safeVertical * 1,
                                          ),
                                          Text(
                                            'Tahun ini',
                                            style: TextStyle(
                                              color:
                                                  (MainScreen.indexfilter == 6)
                                                      ? mColorpicked
                                                      : mColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: MyScreens.safeVertical * 1,
                                          ),
                                          Text(
                                            DateFormat('yyyy')
                                                .format(DateTime.now()),
                                            style: TextStyle(
                                              color:
                                                  (MainScreen.indexfilter == 6)
                                                      ? mColorpicked
                                                      : MyColors.gray,
                                            ),
                                          ),
                                        ]),
                                  ),
                                  onTap: () {
                                    MainScreen.range = DateTime(
                                            DateTime.now().year + 1, 1, 1)
                                        .difference(
                                            DateTime(DateTime.now().year, 1, 1))
                                        .inDays;
                                    MainScreen.indexfilter = 6;
                                    MainScreen.mTanggalmulai =
                                        DateFormat('yyyy-MM-dd').format(
                                            DateTime(
                                                DateTime.now().year, 1, 1));
                                    MainScreen.mTanggalakhir =
                                        DateFormat('yyyy-MM-dd').format(
                                            DateTime(DateTime.now().year + 1, 1,
                                                    1)
                                                .subtract(Duration(days: 1)));
                                    MyConst.setFilterText();
                                    _transaksiBloc.add(GetalltransaksiEvent(
                                        kddompet: MainScreen.mDompet.kddompet,
                                        tanggalmulai: MainScreen.mTanggalmulai,
                                        tanggalakhir:
                                            MainScreen.mTanggalakhir));
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ));
                  });
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
            if (MainScreen.indexfilter != 1) {
              if (MainScreen.indexfilter == 6) {
                MainScreen.mTanggalmulai = DateFormat('yyyy-MM-dd').format(
                    DateTime(
                        DateTime.parse(MainScreen.mTanggalmulai).year + 1,
                        DateTime.parse(MainScreen.mTanggalmulai).month,
                        DateTime.parse(MainScreen.mTanggalmulai).day));
                MainScreen
                    .mTanggalakhir = DateFormat('yyyy-MM-dd').format(DateTime(
                        DateTime.parse(MainScreen.mTanggalakhir).year + 2, 1, 1)
                    .subtract(Duration(days: 1)));
              } else if (MainScreen.indexfilter == 5) {
                MainScreen.mTanggalmulai = DateFormat('yyyy-MM-dd').format(
                    DateTime(
                        DateTime.parse(MainScreen.mTanggalmulai).year,
                        DateTime.parse(MainScreen.mTanggalmulai).month + 1,
                        DateTime.parse(MainScreen.mTanggalmulai).day));
                MainScreen.mTanggalakhir = DateFormat('yyyy-MM-dd').format(
                    DateTime(
                            DateTime.parse(MainScreen.mTanggalakhir).year,
                            DateTime.parse(MainScreen.mTanggalakhir).month + 2,
                            1)
                        .subtract(Duration(days: 1)));
              } else {
                MainScreen.mTanggalmulai = MyConst.addDateFormat(
                    MainScreen.mTanggalmulai, MainScreen.range);
                MainScreen.mTanggalakhir = MyConst.addDateFormat(
                    MainScreen.mTanggalakhir, MainScreen.range);
              }
              MyConst.setFilterText();
              _transaksiBloc.add(GetalltransaksiEvent(
                  kddompet: MainScreen.mDompet.kddompet,
                  tanggalmulai: MainScreen.mTanggalmulai,
                  tanggalakhir: MainScreen.mTanggalakhir));
            }
          },
        )
      ]),
    );
  }

  Widget aruskeluarmasuk(_sumtransaksi) {
    var total = _sumtransaksi[0]['summasuk'] - _sumtransaksi[0]['sumkeluar'];
    var totalwidget;
    if (total < 0) {
      totalwidget = Text(
        'Rp. ' + MyConst.thousandseparator(total),
        style: TextStyle(color: MyColors.red, fontSize: 16),
      );
    } else if (total > 0) {
      totalwidget = Text(
        'Rp. ' + MyConst.thousandseparator(total),
        style: TextStyle(color: MyColors.green, fontSize: 16),
      );
    } else {
      totalwidget = Text(
        'Rp. ' + MyConst.thousandseparator(total),
        style: TextStyle(fontSize: 16),
      );
    }
    return Container(
        padding: EdgeInsets.only(
            top: MyScreens.safeVertical * 3,
            bottom: MyScreens.safeVertical * 1.5,
            left: MyScreens.safeVertical * 3,
            right: MyScreens.safeVertical * 3),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: MyScreens.safeVertical * 2),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Pemasukan',
                            style:
                                TextStyle(color: MyColors.gray, fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Rp. ' +
                                MyConst.thousandseparator(
                                    _sumtransaksi[0]['summasuk']),
                            style:
                                TextStyle(color: MyColors.green, fontSize: 16),
                          )
                        ],
                      )
                    ]),
              ),
              Container(
                margin: EdgeInsets.only(bottom: MyScreens.safeVertical * 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Pengeluaran',
                          style: TextStyle(color: MyColors.gray, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Rp. ' +
                              MyConst.thousandseparator(
                                  _sumtransaksi[0]['sumkeluar']),
                          style: TextStyle(color: MyColors.red, fontSize: 16),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: MyScreens.safeVertical * 1),
                child: Divider(height: 1, color: Colors.black),
              ),
              Container(
                margin: EdgeInsets.only(bottom: MyScreens.safeVertical * 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Selisih Arus Kas',
                          style: TextStyle(color: MyColors.gray, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[totalwidget],
                    )
                  ],
                ),
              ),
            ]));
  }

  Widget listtransaksi(_maptransaksi) {
    List<Map<String, dynamic>> sumtransaksi =
        _maptransaksi['sumtransaksitanggal'];
    List<Map<String, dynamic>> transaksilist = _maptransaksi['transaksilist'];
    List<Widget> transaksiwidget = <Widget>[];
    for (int i = 0; i < sumtransaksi.length; i++) {
      var tanggaltext = DateFormat.EEEE('id')
              .format(DateTime.parse(sumtransaksi[i]['tanggaltransaksi'])) +
          ', ' +
          DateFormat('dd ')
              .format(DateTime.parse(sumtransaksi[i]['tanggaltransaksi'])) +
          DateFormat.MMMM('id')
              .format(DateTime.parse(sumtransaksi[i]['tanggaltransaksi'])) +
          DateFormat(' yyyy')
              .format(DateTime.parse(sumtransaksi[i]['tanggaltransaksi']));
      transaksiwidget.add(Container(
        color: MyColors.blue,
        margin: EdgeInsets.only(
            top: MyScreens.safeVertical * 1,
            bottom: MyScreens.safeVertical * 1),
        padding: EdgeInsets.only(
            top: MyScreens.safeVertical * 1,
            bottom: MyScreens.safeVertical * 1,
            right: MyScreens.safeHorizontal * 5,
            left: MyScreens.safeHorizontal * 3),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                tanggaltext,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                'Rp. ' +
                    MyConst.thousandseparator(sumtransaksi[i]['sumtransaksi']),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ]),
      ));
      for (int j = 0; j < transaksilist.length; j++) {
        if (sumtransaksi[i]['tanggaltransaksi'] ==
            transaksilist[j]['tanggaltransaksi']) {
          Widget jumlahtransaksi;
          if (transaksilist[j]['keluar'] > 0) {
            jumlahtransaksi = Text(
              'Rp. -' + MyConst.thousandseparator(transaksilist[j]['keluar']),
              style: TextStyle(color: MyColors.red),
            );
          } else {
            jumlahtransaksi = Text(
              'Rp. ' + MyConst.thousandseparator(transaksilist[j]['masuk']),
              style: TextStyle(color: MyColors.green),
            );
          }
          transaksiwidget.add(InkWell(
            child: Container(
                padding: EdgeInsets.only(
                    top: MyScreens.safeVertical * 1,
                    bottom: MyScreens.safeVertical * 1,
                    right: MyScreens.safeHorizontal * 3,
                    left: MyScreens.safeHorizontal * 3),
                child: Row(children: <Widget>[
                  Container(
                      margin:
                          EdgeInsets.only(right: MyScreens.safeHorizontal * 2),
                      width: MyScreens.safeVertical * 5,
                      height: MyScreens.safeVertical * 5,
                      decoration: new BoxDecoration(
                          color: MyConst.fromHex(transaksilist[j]['color']),
                          shape: BoxShape.circle),
                      child: new Center(
                        child: FaIcon(
                          IconData(transaksilist[j]['codepoint'],
                              fontFamily: transaksilist[j]['fontfamily'],
                              fontPackage: transaksilist[j]['fontpackage']),
                          color: Colors.white,
                          size: MyScreens.safeVertical * 2.5,
                        ),
                      )),
                  Column(
                    children: <Widget>[
                      Container(
                        width: MyScreens.safeHorizontal * 82,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              transaksilist[j]['namakategori'],
                              style: TextStyle(color: Colors.black),
                            ),
                            jumlahtransaksi,
                          ],
                        ),
                      ),
                      Container(
                        width: MyScreens.safeHorizontal * 82,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            if (transaksilist[j]['catatan'] != "")
                              (transaksilist[j]['catatan'].length > 60)
                                  ? Text(
                                      transaksilist[j]['catatan']
                                              .substring(0, 40) +
                                          ' ....',
                                      style: TextStyle(color: MyColors.gray))
                                  : Text(transaksilist[j]['catatan'],
                                      style: TextStyle(color: MyColors.gray))
                          ],
                        ),
                      )
                    ],
                  ),
                ])),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return UbahTransaksiScreen(
                      idtransaksi: transaksilist[j]['idtransaksi'],
                      kdtransaksi: transaksilist[j]['kdtransaksi']);
                }),
              ).then((val) {
                if (val != null) {
                  MainScreen.mainBloc.add(
                      GetdompetEvent(kddompet: MainScreen.mDompet.kddompet));
                  _transaksiBloc.add(GetalltransaksiEvent(
                      kddompet: MainScreen.mDompet.kddompet,
                      tanggalmulai: MainScreen.mTanggalmulai,
                      tanggalakhir: MainScreen.mTanggalakhir));
                }
              });
            },
          ));
        }
      }
    }
    return Column(
      children: transaksiwidget,
    );
  }
}

class PeriodeWidget extends StatelessWidget {
  final ValueChanged<String> onTanggalMulaiChanged;
  final ValueChanged<String> onTanggalAkhirChanged;
  PeriodeWidget({this.onTanggalMulaiChanged, this.onTanggalAkhirChanged});

  @override
  Widget build(BuildContext context) {
    return PeriodeStateful(
      onTanggalMulaiChanged: this.onTanggalMulaiChanged,
      onTanggalAkhirChanged: this.onTanggalAkhirChanged,
    );
  }
}

class PeriodeStateful extends StatefulWidget {
  final ValueChanged<String> onTanggalMulaiChanged;
  final ValueChanged<String> onTanggalAkhirChanged;
  @override
  PeriodeState createState() => PeriodeState();
  PeriodeStateful(
      {this.onTanggalMulaiChanged, this.onTanggalAkhirChanged, Key key})
      : super(key: key);
}

class PeriodeState extends State<PeriodeStateful> {
  var tempmulai, valmulai;
  var tempakhir, valakhir;
  @override
  void initState() {
    super.initState();
    tempmulai = DateFormat('dd ')
            .format(DateTime.parse(MainScreen.mTanggalmulai)) +
        DateFormat.MMM('id').format(DateTime.parse(MainScreen.mTanggalmulai)) +
        DateFormat(' yyyy').format(DateTime.parse(MainScreen.mTanggalmulai));
    valmulai = (MainScreen.indexfilter == 0)
        ? DateFormat('yyyy-MM-dd').parse(MainScreen.mTanggalmulai)
        : DateTime.now();
    tempakhir = DateFormat('dd ')
            .format(DateTime.parse(MainScreen.mTanggalakhir)) +
        DateFormat.MMM('id').format(DateTime.parse(MainScreen.mTanggalakhir)) +
        DateFormat(' yyyy').format(DateTime.parse(MainScreen.mTanggalakhir));
    valakhir = (MainScreen.indexfilter == 0)
        ? DateFormat('yyyy-MM-dd').parse(MainScreen.mTanggalakhir)
        : DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        InkWell(
          child: Container(
              height: MyScreens.safeVertical * 10,
              width: MyScreens.safeHorizontal * 30,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 1, color: MyColors.light),
                      bottom: BorderSide(width: 1, color: MyColors.light),
                      right: BorderSide(width: 1, color: MyColors.light),
                      left: BorderSide(width: 1, color: MyColors.light))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Dari"),
                  Text(
                    tempmulai,
                    style: TextStyle(color: MyColors.gray),
                  ),
                ],
              )),
          onTap: () async {
            DateTime picked = await showDatePicker(
                context: context,
                initialDate: valmulai,
                firstDate: new DateTime(DateTime.now().year - 10),
                lastDate: valakhir,
                locale: Locale('id'));
            print(picked.toString());
            if (picked != null) {
              print('masuk');
              setState(() {
                tempmulai = DateFormat('dd ').format(picked) +
                    DateFormat.MMM('id').format(picked) +
                    DateFormat(' yyyy').format(picked);
                valmulai = picked;
                widget.onTanggalMulaiChanged(
                    DateFormat('yyyy-MM-dd').format(picked));
              });
            }
          },
        ),
        InkWell(
          child: Container(
            height: MyScreens.safeVertical * 10,
            width: MyScreens.safeHorizontal * 30,
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(width: 1, color: MyColors.light),
              bottom: BorderSide(width: 1, color: MyColors.light),
              right: BorderSide(width: 1, color: MyColors.light),
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Sampai"),
                Text(
                  tempakhir,
                  style: TextStyle(color: MyColors.gray),
                )
              ],
            ),
          ),
          onTap: () async {
            DateTime picked = await showDatePicker(
                context: context,
                initialDate: valakhir,
                firstDate: valmulai,
                lastDate: new DateTime(DateTime.now().year + 7),
                locale: Locale('id'));

            if (picked != null) {
              setState(() {
                tempakhir = DateFormat('dd ').format(picked) +
                    DateFormat.MMM('id').format(picked) +
                    DateFormat(' yyyy').format(picked);
                valakhir = picked;
                widget.onTanggalAkhirChanged(
                    DateFormat('yyyy-MM-dd').format(picked));
              });
            }
          },
        )
      ],
    );
  }
}
