import 'dart:async';

import 'package:rekap_keuangan/blocs/detilrekap_bloc.dart';
import 'package:rekap_keuangan/blocs/main_bloc.dart';
import 'package:rekap_keuangan/blocs/rekap_bloc.dart';
import 'package:rekap_keuangan/blocs/transaksi_bloc.dart';
import 'package:rekap_keuangan/ui/listdompet_screen.dart';
import 'package:rekap_keuangan/ui/main_screen.dart';
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

class DetilRekapScreen extends StatelessWidget {
  final kdkategori;
  final namakategori;
  final codepoint;
  final fontpackage;
  final fontfamily;
  final color;
  final sum;
  final gaugebar;
  final percentage;
  DetilRekapScreen(
      {this.kdkategori,
      this.namakategori,
      this.codepoint,
      this.fontpackage,
      this.fontfamily,
      this.color,
      this.sum,
      this.gaugebar,
      this.percentage,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => DetilRekapBloc(),
        child: Scaffold(
          body: SafeArea(
              child: DetilRekapScreenBody(
                  kdkategori: this.kdkategori,
                  namakategori: this.namakategori,
                  codepoint: this.codepoint,
                  fontfamily: this.fontfamily,
                  fontpackage: this.fontpackage,
                  color: this.color,
                  sum: this.sum,
                  gaugebar: this.gaugebar,
                  percentage: this.percentage)),
        ));
  }
}

class DetilRekapScreenBody extends StatefulWidget {
  final kdkategori;
  final namakategori;
  final codepoint;
  final fontpackage;
  final fontfamily;
  final color;
  final sum;
  final gaugebar;
  final percentage;
  DetilRekapScreenBody(
      {this.kdkategori,
      this.namakategori,
      this.codepoint,
      this.fontfamily,
      this.fontpackage,
      this.color,
      this.sum,
      this.gaugebar,
      this.percentage});
  @override
  _DetilRekapScreenState createState() => _DetilRekapScreenState();
}

class _DetilRekapScreenState extends State<DetilRekapScreenBody> {
  _DetilRekapScreenState({Key key});
  DetilRekapBloc _detilrekapBloc;
  Color mColor, mColorpicked, mColorbg, mColorbgpicked;
  //final _nativeAdController = NativeAdmobController();
  //double _height = 0;
  //StreamSubscription _subscription;
  var percentage;
  // @override
  // void initstate(){
  //   super.initState();
  // }
  // @override
  // void dispose(){

  // }
  @override
  void initState() {
    percentage = widget.percentage;
    _detilrekapBloc = BlocProvider.of<DetilRekapBloc>(context);
    _detilrekapBloc.add(GetdetilrekapEvent(
        kddompet: MainScreen.mDompet.kddompet,
        kdkategori: widget.kdkategori,
        tanggalmulai: MainScreen.mTanggalmulai,
        tanggalakhir: MainScreen.mTanggalakhir));
    super.initState();
    //_subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
  }

  @override
  void dispose() {
    super.dispose();
    // _subscription.cancel();
    // _nativeAdController.dispose();
  }

  // void _onStateChanged(AdLoadState state) {
  //   switch (state) {
  //     case AdLoadState.loading:
  //       setState(() {
  //         _height = 0;
  //       });
  //       break;

  //     case AdLoadState.loadCompleted:
  //       setState(() {
  //         _height = MyScreens.safeVertical * 12;
  //       });
  //       break;

  //     default:
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    MyScreens().initScreen(context);
    return BlocBuilder(
        cubit: _detilrekapBloc,
        builder: (context, state) {
          if (state is DetilRekapLoadingState) {
            return MyWidgets.buildLoadingWidget(context);
          } else if (state is DetilRekapLoadedState) {
            Map<String, dynamic> maprekap = state.maprekap;
            return Scaffold(
              appBar: AppBar(
                title: Text('Detil Rekap'),
                backgroundColor: MyColors.blue,
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(FontAwesomeIcons.arrowLeft),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: SafeArea(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                      child: ListView(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(
                              top: MyScreens.safeVertical * 1,
                              bottom: MyScreens.safeVertical * 1,
                              right: MyScreens.safeHorizontal * 3,
                              left: MyScreens.safeHorizontal * 3),
                          child: Text(
                            MainScreen.mDompet.namadompet +
                                ' (' +
                                MainScreen.filtertext +
                                ')',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                      Container(
                          padding: EdgeInsets.only(
                              top: MyScreens.safeVertical * 1,
                              bottom: MyScreens.safeVertical * 1,
                              right: MyScreens.safeHorizontal * 3,
                              left: MyScreens.safeHorizontal * 3),
                          child: Row(children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(
                                    right: MyScreens.safeHorizontal * 2),
                                width: MyScreens.safeVertical * 5,
                                height: MyScreens.safeVertical * 5,
                                decoration: new BoxDecoration(
                                    color: MyConst.fromHex(widget.color),
                                    shape: BoxShape.circle),
                                child: new Center(
                                  child: FaIcon(
                                    IconData(widget.codepoint,
                                        fontFamily: widget.fontfamily,
                                        fontPackage: widget.fontpackage),
                                    color: Colors.white,
                                    size: MyScreens.safeVertical * 3,
                                  ),
                                )),
                            Column(
                              children: <Widget>[
                                Container(
                                  width: MyScreens.safeHorizontal * 82,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        widget.namakategori,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text('Rp. ' +
                                          MyConst.thousandseparator(
                                              widget.sum)),
                                    ],
                                  ),
                                ),
                                Container(
                                    width: MyScreens.safeHorizontal * 82,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                height: MyScreens.safeVertical *
                                                    1.5,
                                                width: (widget.gaugebar *
                                                    widget.percentage),
                                                decoration: BoxDecoration(
                                                    color: MyConst.fromHex(
                                                        widget.color),
                                                    borderRadius:
                                                        new BorderRadius.only(
                                                      bottomLeft: Radius
                                                          .circular(MyScreens
                                                                  .safeVertical *
                                                              1),
                                                      topLeft: Radius.circular(
                                                          MyScreens
                                                                  .safeVertical *
                                                              1),
                                                      bottomRight: Radius
                                                          .circular(MyScreens
                                                                  .safeVertical *
                                                              1),
                                                      topRight: Radius.circular(
                                                          MyScreens
                                                                  .safeVertical *
                                                              1),
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
                                                    widget.color))),
                                      ],
                                    ))
                              ],
                            ),
                          ])),
                      listrekap(maprekap['sumrekap'], maprekap['rekaplist']),
                    ],
                  )),
                  // Container(
                  //   height: _height,
                  //   padding: EdgeInsets.all(MyScreens.safeVertical * 1),
                  //   margin: EdgeInsets.only(bottom: MyScreens.safeVertical * 1),
                  //   child: NativeAdmob(
                  //     adUnitID: MyConst.nativeAdsUnitID,
                  //     controller: _nativeAdController,
                  //     type: NativeAdmobType.banner,
                  //   ),
                  // ),
                ],
              )),
            );
          } else if (state is DetilRekapFailedState) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Detil Rekap'),
                backgroundColor: MyColors.blue,
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(FontAwesomeIcons.arrowLeft),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: SafeArea(
                  child: Column(children: <Widget>[
                Flexible(
                    child: Container(
                  alignment: Alignment.center,
                  child: Text('Gagal memuat transaksi'),
                ))
              ])),
            );
          } else if (state is DetilRekapEmptyState) {
            Map<String, dynamic> maprekap = state.maprekap;
            return Scaffold(
              appBar: AppBar(
                title: Text('Detil Rekap'),
                backgroundColor: MyColors.blue,
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(FontAwesomeIcons.arrowLeft),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: SafeArea(
                  child: Column(children: <Widget>[
                Flexible(
                    child: ListView(
                  children: <Widget>[
                    listrekap(maprekap['sumtransaksi'], maprekap['rekaplist']),
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

  Widget listrekap(sumtransaksi, rekaplist) {
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
                    MyConst.thousandseparator((sumtransaksi[i]['summasuk'] == 0)
                        ? sumtransaksi[i]['sumkeluar']
                        : sumtransaksi[i]['summasuk']),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ]),
      ));
      for (int j = 0; j < rekaplist.length; j++) {
        if (sumtransaksi[i]['tanggaltransaksi'] ==
            rekaplist[j]['tanggaltransaksi']) {
          Widget jumlahtransaksi;
          if (rekaplist[j]['keluar'] > 0) {
            jumlahtransaksi = Text(
              'Rp. -' + MyConst.thousandseparator(rekaplist[j]['keluar']),
              style: TextStyle(color: MyColors.red),
            );
          } else {
            jumlahtransaksi = Text(
              'Rp. ' + MyConst.thousandseparator(rekaplist[j]['masuk']),
              style: TextStyle(color: MyColors.green),
            );
          }
          transaksiwidget.add(
            Container(
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
                          color: MyConst.fromHex(rekaplist[j]['color']),
                          shape: BoxShape.circle),
                      child: new Center(
                        child: FaIcon(
                          IconData(rekaplist[j]['codepoint'],
                              fontFamily: rekaplist[j]['fontfamily'],
                              fontPackage: rekaplist[j]['fontpackage']),
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
                              rekaplist[j]['namakategori'],
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
                            if (rekaplist[j]['catatan'] != "")
                              (rekaplist[j]['catatan'].length > 60)
                                  ? Text(
                                      rekaplist[j]['catatan'].substring(0, 40) +
                                          ' ....',
                                      style: TextStyle(color: MyColors.gray))
                                  : Text(rekaplist[j]['catatan'],
                                      style: TextStyle(color: MyColors.gray))
                          ],
                        ),
                      )
                    ],
                  ),
                ])),
          );
        }
      }
    }
    return Column(
      children: transaksiwidget,
    );
  }
}
