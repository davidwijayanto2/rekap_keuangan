import 'dart:async';

import 'package:rekap_keuangan/blocs/main_bloc.dart';
import 'package:rekap_keuangan/blocs/rekap_bloc.dart';
import 'package:rekap_keuangan/blocs/transaksi_bloc.dart';
import 'package:rekap_keuangan/ui/detilrekap_screen.dart';
import 'package:rekap_keuangan/ui/listdompet_screen.dart';
import 'package:rekap_keuangan/ui/main_screen.dart';
import 'package:rekap_keuangan/ui/performa_screen.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RekapScreen extends StatelessWidget {
  RekapScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.bluesharp, //or set color with: Color(0xFF0000FF)
    ));
    return BlocProvider(
        create: (BuildContext context) => RekapBloc(),
        child: Scaffold(
          body: SafeArea(child: RekapScreenBody()),
        ));
  }
}

class RekapScreenBody extends StatefulWidget {
  @override
  _RekapScreenState createState() => _RekapScreenState();
}

class _RekapScreenState extends State<RekapScreenBody> {
  _RekapScreenState({Key key});
  RekapBloc _rekapBloc;
  Color mColor, mColorpicked, mColorbg, mColorbgpicked;
  final _nativeAdController = NativeAdmobController();
  double _height = 0;
  StreamSubscription _subscription;
  // @override
  // void dispose(){

  // }
  @override
  void initState() {
    _rekapBloc = BlocProvider.of<RekapBloc>(context);
    _rekapBloc.add(GetrekapEvent(
        kddompet: MainScreen.mDompet.kddompet,
        tanggalmulai: MainScreen.mTanggalmulai,
        tanggalakhir: MainScreen.mTanggalakhir));
    mColor = MyColors.darkgray;
    mColorpicked = Colors.white;
    mColorbg = Colors.white;
    mColorbgpicked = MyColors.bluesharp;
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
        print('delay: ' + MyConst.adsdelay.toString());
        //settimer();
        break;

      default:
        break;
    }
  }

  // void settimer() {
  //   int time = 2;
  //   const oneSec = const Duration(seconds: 1);
  //   Timer timers;
  //   timers = new Timer.periodic(oneSec, (Timer timer) {
  //     if (time < 1) {
  //       timer.cancel();
  //       MyConst.adsdelay = true;
  //       MyConst.adstimer = 70;
  //       MyConst.setAdsTimer();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    MyScreens().initScreen(context);
    return BlocBuilder(
        cubit: _rekapBloc,
        builder: (context, state) {
          if (state is RekapLoadingState) {
            return MyWidgets.buildLoadingWidget(context);
          } else if (state is RekapLoadedState) {
            Map<String, dynamic> maprekap = state.maprekap;
            return Scaffold(
              body: SafeArea(
                  child: Column(
                children: <Widget>[
                  dompetSection(),
                  filterbar(),
                  Flexible(
                      child: ListView(
                    children: <Widget>[
                      Container(
                          height: _height,
                          padding: EdgeInsets.all(MyScreens.safeVertical * 1),
                          margin: EdgeInsets.only(
                              bottom: MyScreens.safeVertical * 1),
                          // child: (!MyConst.adsdelay)
                          //     ? NativeAdmob(
                          //         adUnitID: NativeAd
                          //             .testAdUnitId, //MyConst.nativeAdsUnitID,
                          //         controller: _nativeAdController,
                          //         type: NativeAdmobType.banner,
                          //       )
                          //     : null,
                          child: NativeAdmob(
                            adUnitID: NativeAd
                                .testAdUnitId, //MyConst.nativeAdsUnitID,
                            controller: _nativeAdController,
                            type: NativeAdmobType.banner,
                          )),
                      graphsection(maprekap['sumtransaksi'][0]),
                      listrekap(
                          maprekap['sumtransaksi'][0], maprekap['rekaplist']),
                      Container(
                        height: MyScreens.safeVertical * 10,
                      )
                    ],
                  ))
                ],
              )),
            );
          } else if (state is RekapFailedState) {
            return Scaffold(
              body: SafeArea(
                  child: Column(children: <Widget>[
                dompetSection(),
                filterbar(),
                Flexible(
                    child: ListView(children: <Widget>[
                  Container(
                      height: _height,
                      padding: EdgeInsets.all(MyScreens.safeVertical * 1),
                      margin:
                          EdgeInsets.only(bottom: MyScreens.safeVertical * 1),
                      // child: (!MyConst.adsdelay)
                      //     ? NativeAdmob(
                      //         adUnitID: NativeAd
                      //             .testAdUnitId, //MyConst.nativeAdsUnitID,
                      //         controller: _nativeAdController,
                      //         type: NativeAdmobType.banner,
                      //       )
                      //     : null,
                      child: NativeAdmob(
                        adUnitID:
                            NativeAd.testAdUnitId, //MyConst.nativeAdsUnitID,
                        controller: _nativeAdController,
                        type: NativeAdmobType.banner,
                      )),
                  Container(
                    alignment: Alignment.center,
                    child: Text('Gagal memuat transaksi'),
                  )
                ]))
              ])),
            );
          } else if (state is RekapEmptyState) {
            Map<String, dynamic> maprekap = state.maprekap;
            return Scaffold(
              body: SafeArea(
                  child: Column(children: <Widget>[
                dompetSection(),
                filterbar(),
                Flexible(
                    child: ListView(
                  children: <Widget>[
                    Container(
                        height: _height,
                        padding: EdgeInsets.all(MyScreens.safeVertical * 1),
                        margin:
                            EdgeInsets.only(bottom: MyScreens.safeVertical * 1),
                        // child: (!MyConst.adsdelay)
                        //     ? NativeAdmob(
                        //         adUnitID: NativeAd
                        //             .testAdUnitId, //MyConst.nativeAdsUnitID,
                        //         controller: _nativeAdController,
                        //         type: NativeAdmobType.banner,
                        //       )
                        //     : null,
                        child: NativeAdmob(
                          adUnitID:
                              MyConst.nativeAdsUnitID,
                          controller: _nativeAdController,
                          type: NativeAdmobType.banner,
                        )),
                    graphsection(maprekap['sumtransaksi'][0]),
                    listrekap(
                        maprekap['sumtransaksi'][0], maprekap['rekaplist']),
                    Container(
                      height: MyScreens.safeVertical * 10,
                    )
                  ],
                ))
              ])),
            );
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
                        _rekapBloc.add(GetrekapEvent(
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
                                _rekapBloc.add(GetrekapEvent(
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
                          ))
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

  Widget graphsection(sumtransaksi) {
    var total = sumtransaksi['summasuk'] + sumtransaksi['sumkeluar'];
    double percentagemasuk = 0.0, percentagekeluar = 0.0;
    if (total > 0) {
      percentagemasuk =
          MyConst.roundDouble(sumtransaksi['summasuk'] / total * 100, 1);
      percentagekeluar =
          MyConst.roundDouble(sumtransaksi['sumkeluar'] / total * 100, 1);
    }
    return Container(
        margin: EdgeInsets.only(
            top: MyScreens.safeVertical * 2,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.centerLeft,
                    width: MyScreens.safeHorizontal * 50,
                    height: MyScreens.safeVertical * 30,
                    child: (total > 0)
                        ? ChartWidget(
                            percentagemasuk: percentagemasuk,
                            percentagekeluar: percentagekeluar,
                          )
                        : ChartWidget(
                            percentagekosong: 100.0,
                          )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Container(
                          width: MyScreens.safeVertical * 3.5,
                          height: MyScreens.safeVertical * 3.5,
                          color: MyColors.green,
                          margin: EdgeInsets.only(
                              right: MyScreens.safeHorizontal * 2)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Total Pemasukan',
                              style: TextStyle(
                                  fontSize: MyScreens.safeVertical * 1.5)),
                          Text(
                              'Rp. ' +
                                  MyConst.thousandseparator(
                                      sumtransaksi['summasuk']),
                              style: TextStyle(
                                  fontSize: MyScreens.safeVertical * 1.5,
                                  fontWeight: FontWeight.bold))
                        ],
                      )
                    ]),
                    SizedBox(
                      height: MyScreens.safeVertical * 1,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                            width: MyScreens.safeVertical * 3.5,
                            height: MyScreens.safeVertical * 3.5,
                            color: MyColors.red,
                            margin: EdgeInsets.only(
                                right: MyScreens.safeHorizontal * 2)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Total Pengeluaran',
                                style: TextStyle(
                                    fontSize: MyScreens.safeVertical * 1.5)),
                            Text(
                                'Rp. ' +
                                    MyConst.thousandseparator(
                                        sumtransaksi['sumkeluar']),
                                style: TextStyle(
                                    fontSize: MyScreens.safeVertical * 1.5,
                                    fontWeight: FontWeight.bold))
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: MyScreens.safeVertical * 1,
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.arrowsAltH,
                              color: MyColors.green,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MyScreens.safeHorizontal * 2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Selisih',
                                style: TextStyle(
                                    fontSize: MyScreens.safeVertical * 1.5)),
                            Text(
                                'Rp. ' +
                                    MyConst.thousandseparator(
                                        sumtransaksi['summasuk'] -
                                            sumtransaksi['sumkeluar']),
                                style: TextStyle(
                                    fontSize: MyScreens.safeVertical * 1.5,
                                    fontWeight: FontWeight.bold))
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            // Container(
            //     alignment: Alignment.center,
            //     child: FlatButton(
            //       onPressed: () {
            //         setState(() {
            //           // MainScreen.selectedIndex = 0;
            //           // RekapScreen(key: PageStorageKey('Page1'));
            //         });
            //       },
            //       color: MyColors.greenlightest,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(18.0),
            //       ),
            //       child: Text(
            //         'Lihat Performa Keuangan',
            //         style: TextStyle(
            //             color: MyColors.green, fontWeight: FontWeight.bold),
            //       ),
            //     ))
          ],
        ));
  }

  Widget listrekap(sumtransaksi, rekaplist) {
    List<Widget> rekapwidget = <Widget>[];
    rekapwidget.add(Container(
      color: MyColors.green,
      margin: EdgeInsets.only(
          top: MyScreens.safeVertical * 1, bottom: MyScreens.safeVertical * 1),
      padding: EdgeInsets.only(
          top: MyScreens.safeVertical * 1,
          bottom: MyScreens.safeVertical * 1,
          right: MyScreens.safeHorizontal * 4,
          left: MyScreens.safeHorizontal * 3),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          'PEMASUKAN - ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(
          'Rp. ' + MyConst.thousandseparator(sumtransaksi['summasuk']),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ]),
    ));
    var countmasuk = 0, countkeluar = 0;
    for (int i = 0; i < rekaplist.length; i++) {
      if (rekaplist[i]['summasuk'] > 0) {
        var percentage = 0.0;
        var gaugebarlength = (MyScreens.safeHorizontal * 67) / 100;
        if (sumtransaksi['summasuk'] > 0) {
          percentage = MyConst.roundDouble(
              rekaplist[i]['summasuk'] / sumtransaksi['summasuk'] * 100, 1);
        }
        rekapwidget.add(InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetilRekapScreen(
                    kdkategori: rekaplist[i]['kdkategori'],
                    namakategori: rekaplist[i]['namakategori'],
                    codepoint: rekaplist[i]['codepoint'],
                    fontfamily: rekaplist[i]['fontfamily'],
                    fontpackage: rekaplist[i]['fontpackage'],
                    color: rekaplist[i]['color'],
                    sum: rekaplist[i]['summasuk'],
                    gaugebar: gaugebarlength,
                    percentage: percentage);
              }));
            },
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
                          color: MyConst.fromHex(rekaplist[i]['color']),
                          shape: BoxShape.circle),
                      child: new Center(
                        child: FaIcon(
                          IconData(rekaplist[i]['codepoint'],
                              fontFamily: rekaplist[i]['fontfamily'],
                              fontPackage: rekaplist[i]['fontpackage']),
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
                              rekaplist[i]['namakategori'],
                              style: TextStyle(color: Colors.black),
                            ),
                            Text('Rp. ' +
                                MyConst.thousandseparator(
                                    rekaplist[i]['summasuk'])),
                          ],
                        ),
                      ),
                      Container(
                          width: MyScreens.safeHorizontal * 82,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      height: MyScreens.safeVertical * 1.5,
                                      width: (gaugebarlength * percentage),
                                      decoration: BoxDecoration(
                                          color: MyConst.fromHex(
                                              rekaplist[i]['color']),
                                          borderRadius: new BorderRadius.only(
                                            bottomLeft: Radius.circular(
                                                MyScreens.safeVertical * 1),
                                            topLeft: Radius.circular(
                                                MyScreens.safeVertical * 1),
                                            bottomRight: Radius.circular(
                                                MyScreens.safeVertical * 1),
                                            topRight: Radius.circular(
                                                MyScreens.safeVertical * 1),
                                          ))),
                                  // Container(
                                  //   height: MyScreens.safeVertical * 1.5,
                                  //   width: (gaugebarlength * (100 - percentage)),
                                  //   decoration: BoxDecoration(
                                  //     color: MyColors.graylight,
                                  //     borderRadius: new BorderRadius.only(
                                  //         bottomRight: Radius.circular(
                                  //             MyScreens.safeVertical * 1),
                                  //         topRight: Radius.circular(
                                  //             MyScreens.safeVertical * 1)),
                                  //   ),
                                  // ),
                                ],
                              ),
                              Text('$percentage%',
                                  style: TextStyle(
                                      color: MyConst.fromHex(
                                          rekaplist[i]['color']))),
                            ],
                          ))
                    ],
                  ),
                ]))));
        countmasuk++;
      }
    }
    if (countmasuk == 0) {
      rekapwidget.add(Container(
        margin: EdgeInsets.all(MyScreens.safeVertical * 5),
        padding: EdgeInsets.only(
            left: MyScreens.safeHorizontal * 5,
            right: MyScreens.safeHorizontal * 5),
        height: MyScreens.safeVertical * 6.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          color: MyColors.graylight2,
        ),
        child: Center(
            child: Text('Klik transaksi untuk menambah pemasukan',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: MyScreens.safeVertical * 1.5))),
      ));
    }
    rekapwidget.add(Container(
      color: MyColors.red,
      margin: EdgeInsets.only(
          top: MyScreens.safeVertical * 1, bottom: MyScreens.safeVertical * 1),
      padding: EdgeInsets.only(
          top: MyScreens.safeVertical * 1,
          bottom: MyScreens.safeVertical * 1,
          right: MyScreens.safeHorizontal * 4,
          left: MyScreens.safeHorizontal * 3),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          'PENGELUARAN - ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(
          'Rp. ' + MyConst.thousandseparator(sumtransaksi['sumkeluar']),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ]),
    ));
    for (int i = 0; i < rekaplist.length; i++) {
      if (rekaplist[i]['sumkeluar'] > 0) {
        var percentage = 0.0;
        var gaugebarlength = (MyScreens.safeHorizontal * 67) / 100;
        if (sumtransaksi['sumkeluar'] > 0) {
          percentage = MyConst.roundDouble(
              rekaplist[i]['sumkeluar'] / sumtransaksi['sumkeluar'] * 100, 1);
        }
        rekapwidget.add(InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetilRekapScreen(
                    kdkategori: rekaplist[i]['kdkategori'],
                    namakategori: rekaplist[i]['namakategori'],
                    codepoint: rekaplist[i]['codepoint'],
                    fontfamily: rekaplist[i]['fontfamily'],
                    fontpackage: rekaplist[i]['fontpackage'],
                    color: rekaplist[i]['color'],
                    sum: sumtransaksi['sumkeluar'],
                    gaugebar: gaugebarlength,
                    percentage: percentage);
              }));
            },
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
                          color: MyConst.fromHex(rekaplist[i]['color']),
                          shape: BoxShape.circle),
                      child: new Center(
                        child: FaIcon(
                          IconData(rekaplist[i]['codepoint'],
                              fontFamily: rekaplist[i]['fontfamily'],
                              fontPackage: rekaplist[i]['fontpackage']),
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
                              rekaplist[i]['namakategori'],
                              style: TextStyle(color: Colors.black),
                            ),
                            Text('Rp. ' +
                                MyConst.thousandseparator(
                                    rekaplist[i]['sumkeluar'])),
                          ],
                        ),
                      ),
                      Container(
                          width: MyScreens.safeHorizontal * 82,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      height: MyScreens.safeVertical * 1.5,
                                      width: (gaugebarlength * percentage),
                                      decoration: BoxDecoration(
                                          color: MyConst.fromHex(
                                              rekaplist[i]['color']),
                                          borderRadius: new BorderRadius.only(
                                            bottomLeft: Radius.circular(
                                                MyScreens.safeVertical * 1),
                                            topLeft: Radius.circular(
                                                MyScreens.safeVertical * 1),
                                            bottomRight: Radius.circular(
                                                MyScreens.safeVertical * 1),
                                            topRight: Radius.circular(
                                                MyScreens.safeVertical * 1),
                                          ))),
                                  // Container(
                                  //   height: MyScreens.safeVertical * 1.5,
                                  //   width: (gaugebarlength * (100 - percentage)),
                                  //   decoration: BoxDecoration(
                                  //     color: MyColors.graylight,
                                  //     borderRadius: new BorderRadius.only(
                                  //         bottomRight: Radius.circular(
                                  //             MyScreens.safeVertical * 1),
                                  //         topRight: Radius.circular(
                                  //             MyScreens.safeVertical * 1)),
                                  //   ),
                                  // ),
                                ],
                              ),
                              Text('$percentage%',
                                  style: TextStyle(
                                      color: MyConst.fromHex(
                                          rekaplist[i]['color']))),
                            ],
                          ))
                    ],
                  ),
                ]))));
        countkeluar++;
      }
    }
    if (countkeluar == 0) {
      rekapwidget.add(Container(
        margin: EdgeInsets.only(
            left: MyScreens.safeVertical * 5,
            right: MyScreens.safeVertical * 5,
            top: MyScreens.safeVertical * 5),
        padding: EdgeInsets.only(
            left: MyScreens.safeHorizontal * 5,
            right: MyScreens.safeHorizontal * 5),
        height: MyScreens.safeVertical * 6.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          color: MyColors.graylight2,
        ),
        child: Center(
            child: Text('Klik transaksi untuk menambah pengeluaran',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: MyScreens.safeVertical * 1.5))),
      ));
    }
    return Column(
      children: rekapwidget,
    );
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
                print(MainScreen.mTanggalmulai);
              } else {
                MainScreen.mTanggalmulai = MyConst.subDateFormat(
                    MainScreen.mTanggalmulai, MainScreen.range);
                MainScreen.mTanggalakhir = MyConst.subDateFormat(
                    MainScreen.mTanggalakhir, MainScreen.range);
              }
              MyConst.setFilterText();
              _rekapBloc.add(GetrekapEvent(
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
                                              print('a' + tempawal);
                                              print(tempakhir);
                                              MainScreen.mTanggalakhir =
                                                  tempakhir;
                                              MyConst.setFilterText();
                                              _rekapBloc.add(GetrekapEvent(
                                                  kddompet: MainScreen
                                                      .mDompet.kddompet,
                                                  tanggalmulai:
                                                      MainScreen.mTanggalmulai,
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
                                    _rekapBloc.add(GetrekapEvent(
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
                                      _rekapBloc.add(GetrekapEvent(
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
                                      _rekapBloc.add(GetrekapEvent(
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
                                    _rekapBloc.add(GetrekapEvent(
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
                                    _rekapBloc.add(GetrekapEvent(
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
                                    _rekapBloc.add(GetrekapEvent(
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
              _rekapBloc.add(GetrekapEvent(
                  kddompet: MainScreen.mDompet.kddompet,
                  tanggalmulai: MainScreen.mTanggalmulai,
                  tanggalakhir: MainScreen.mTanggalakhir));
            }
          },
        )
      ]),
    );
  }
}

class GaugeIndex {
  final int index;
  final double percentage;
  final charts.Color color;
  GaugeIndex(this.index, this.percentage, this.color);
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

class ChartWidget extends StatelessWidget {
  final double percentagemasuk;
  final double percentagekeluar;
  final double percentagekosong;
  ChartWidget(
      {this.percentagemasuk, this.percentagekeluar, this.percentagekosong});

  @override
  Widget build(BuildContext context) {
    return ChartStateful(
        percentagemasuk: this.percentagemasuk,
        percentagekeluar: this.percentagekeluar,
        percentagekosong: this.percentagekosong);
  }
}

class ChartStateful extends StatefulWidget {
  final double percentagemasuk;
  final double percentagekeluar;
  final double percentagekosong;
  @override
  ChartState createState() => ChartState();
  ChartStateful(
      {this.percentagemasuk,
      this.percentagekeluar,
      this.percentagekosong,
      Key key})
      : super(key: key);
}

class ChartState extends State<ChartStateful> {
  List<charts.Series> seriesList;
  List<charts.Series<GaugeIndex, int>> _createSampleData() {
    final data = [
      new GaugeIndex(
          0, widget.percentagemasuk, charts.Color.fromHex(code: '#42C856')),
      new GaugeIndex(
          1, widget.percentagekeluar, charts.Color.fromHex(code: '#EC6853'))
    ];
    final datakosong = [
      new GaugeIndex(
          0, widget.percentagekosong, charts.Color.fromHex(code: '#C6C6C6')),
    ];
    return (widget.percentagekosong == null)
        ? [
            new charts.Series<GaugeIndex, int>(
              id: 'Transaksi',
              domainFn: (GaugeIndex gauge, _) => gauge.index,
              measureFn: (GaugeIndex gauge, _) => gauge.percentage,
              colorFn: (GaugeIndex gauge, _) => gauge.color,
              data: data,
              labelAccessorFn: (GaugeIndex row, _) => '${row.percentage}%',
            )
          ]
        : [
            new charts.Series<GaugeIndex, int>(
                id: 'Transaksi',
                domainFn: (GaugeIndex gauge, _) => gauge.index,
                measureFn: (GaugeIndex gauge, _) => gauge.percentage,
                colorFn: (GaugeIndex gauge, _) => gauge.color,
                data: datakosong)
          ];
  }

  @override
  Widget build(BuildContext context) {
    seriesList = _createSampleData();
    return (widget.percentagekosong == null)
        ? charts.PieChart(seriesList,
            animate: false,
            // Configure the width of the pie slices to 60px. The remaining space in
            // the chart will be left as a hole in the center.
            defaultRenderer: new charts.ArcRendererConfig(
                arcWidth: (MyScreens.safeVertical * 7).round(),
                arcRendererDecorators: [new charts.ArcLabelDecorator()]))
        : charts.PieChart(seriesList,
            animate: false,
            // Configure the width of the pie slices to 60px. The remaining space in
            // the chart will be left as a hole in the center.
            defaultRenderer: new charts.ArcRendererConfig(
                arcWidth: (MyScreens.safeVertical * 7).round()));
  }
}
