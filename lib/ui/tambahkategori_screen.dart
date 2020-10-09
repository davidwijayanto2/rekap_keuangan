import 'dart:async';

import 'package:rekap_keuangan/blocs/tambahdompet_bloc.dart';
import 'package:rekap_keuangan/blocs/tambahkategori_bloc.dart';
import 'package:rekap_keuangan/ui/main_screen.dart';
import 'package:rekap_keuangan/blocs/Kategori_bloc.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/IconPicker/iconPicker.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahKategoriScreen extends StatelessWidget {
  final mJenis;
  TambahKategoriScreen({Key key, @required this.mJenis});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: BlocProvider(
            create: (BuildContext context) => TambahKategoriBloc(),
            child: TambahKategoriScreenBody(
              mJenis: this.mJenis,
            )));
  }
}

class TambahKategoriScreenBody extends StatefulWidget {
  final mJenis;
  @override
  _TambahKategoriScreenState createState() => _TambahKategoriScreenState();
  TambahKategoriScreenBody({this.mJenis});
}

class _TambahKategoriScreenState extends State<TambahKategoriScreenBody> {
  IconData mIcon = IconData(62805,
      fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter');
  //IconData mIcon=IconDataSolid(0xf555);
  Color mColor = MyColors.blue;
  final txtkategori = TextEditingController();
  final txtsaldoawal = TextEditingController();
  final txtcatatan = TextEditingController();
  final FocusNode _txtkategorifocus = FocusNode();
  final FocusNode _txtsaldoawalfocus = FocusNode();
  final FocusNode _txtcatatanfocus = FocusNode();
  final _formkey = GlobalKey<FormState>();
  bool isDuplicate = false;
  SharedPreferences prefs;
  bool firstinit = true, adsShown = false;
  final _nativeAdController = NativeAdmobController();
  double _height = 0;
  StreamSubscription _subscription;
  AppBar appbar;
  @override
  void initState() {
    // TODO: implement initState
    print('init: ' + mIcon.codePoint.toString());

    var texttitle;
    if (widget.mJenis == 'm') {
      texttitle = 'Tambah Kategori Pemasukan';
    } else if (widget.mJenis == 'k') {
      texttitle = 'Tambah Kategori Pengeluaran';
    }
    mIcon = IconData(62805,
        fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter');
    mColor = MyColors.blue;
    appbar = AppBar(
      title: Text(texttitle),
      backgroundColor: MyColors.blue,
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: Icon(FontAwesomeIcons.arrowLeft),
        onPressed: () => Navigator.pop(context),
      ),
    );
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
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    MyWidgets().buildLoadingDialog(context);
    MyScreens().initScreen(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //print(((widget.screenwidth*5)/(widget.screenheight*15)));
      if (firstinit) {
        txtsaldoawal.text = '0';
        firstinit = false;
      }
    });
    print('jenis: ' + widget.mJenis);
    return BlocListener<TambahKategoriBloc, TambahKategoriState>(
        cubit: BlocProvider.of<TambahKategoriBloc>(context),
        listener: (context, state) async {
          print('masuklistener');
          if (state.isLoading) {
            print('masuk loading');
            await MyWidgets.dialog.show();
          }
          if (state.isSuccess) {
            print('masuk success');
            Future.delayed(Duration(seconds: 1)).then((value) {
              MyWidgets.dialog.hide().whenComplete(() {
                Fluttertoast.showToast(msg: "Kategori berhasil ditambahkan");
                Navigator.pop(context, true);
              });
            });
          }
          if (state.isDuplicate) {
            Future.delayed(Duration(seconds: 1)).then((value) {
              MyWidgets.dialog.hide().whenComplete(() {
                print(MyWidgets.dialog.isShowing());
              });
            });
            print('masuk duplicate');
            isDuplicate = true;
            _formkey.currentState.validate();
          }
        },
        child: BlocBuilder<TambahKategoriBloc, TambahKategoriState>(
            cubit: BlocProvider.of<TambahKategoriBloc>(context),
            builder: (context, state) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: appbar,
                  body: SafeArea(
                      child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            Container(
                              height: _height,
                              padding:
                                  EdgeInsets.all(MyScreens.safeVertical * 1),
                              margin: EdgeInsets.only(
                                  bottom: MyScreens.safeVertical * 1),
                              child: NativeAdmob(
                                adUnitID: MyConst.nativeAdsUnitID,
                                controller: _nativeAdController,
                                type: NativeAdmobType.banner,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: MyScreens.safeVertical * 12 - _height,
                                  bottom: 5.0),
                              child: Center(
                                child: Ink(
                                  decoration: ShapeDecoration(
                                    color: mColor,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    icon: FaIcon(mIcon),
                                    color: Colors.white,
                                    onPressed: () {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      _pickIcon();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            // Container(
                            //   margin: const EdgeInsets.only(top:30.0),
                            //   width: 50.0,
                            //   height: 50.0,
                            //   decoration: new BoxDecoration(
                            //     color: Colors.green,
                            //     shape: BoxShape.circle,
                            //   ),
                            //   child: FlatButton(
                            //     onPressed: _pickIcon,
                            //     padding: EdgeInsets.all(0.0),
                            //     child: Center(
                            //       child: FaIcon(
                            //         FontAwesomeIcons.wallet,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'GANTI ICON',
                                style: TextStyle(color: MyColors.gray),
                              ),
                            ),
                            Form(
                                key: _formkey,
                                child: Column(children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.all(20.0),
                                      child: Column(
                                        children: <Widget>[
                                          TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller: txtkategori,
                                            focusNode: _txtkategorifocus,
                                            decoration: InputDecoration(
                                              labelText: (widget.mJenis == 'm')
                                                  ? 'Kategori Pemasukan'
                                                  : 'Kategori Pengeluaran',
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Nama Kategori harus diisi';
                                              }
                                              if (isDuplicate) {
                                                isDuplicate = false;
                                                return 'Nama Kategori tidak boleh sama';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      )),
                                ]))
                          ],
                        ),
                      ),
                      Container(
                        height: MyScreens.safeVertical * 7.5,
                        margin: EdgeInsets.only(right: 1, left: 1),
                        child: Material(
                            color: MyColors.blue,
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'SIMPAN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: MyScreens.safeVertical * 3),
                                  ),
                                ],
                              ),
                              onTap: () {
                                print('masuktap');
                                if (!state.isLoading) {
                                  print('masuknotloading');
                                  if (_formkey.currentState.validate()) {
                                    print('masukvalidate');
                                    BlocProvider.of<TambahKategoriBloc>(context)
                                        .add(SetkategoriEvent(
                                            namakategori:
                                                txtkategori.text.trim(),
                                            jenis: widget.mJenis,
                                            codepoint: mIcon.codePoint,
                                            fontfamily: mIcon.fontFamily,
                                            fontpackage: mIcon.fontPackage,
                                            color: MyConst.toHex(mColor)));
                                  }
                                }
                              },
                            )),
                      ),
                      // Container(
                      //   height: MyScreens.safeVertical*60,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.stretch,
                      //     mainAxisSize: MainAxisSize.max,
                      //     children: <Widget>[
                      //       Expanded(
                      //         child: Container(
                      //           color: MyColors.blue,
                      //           child: Row(
                      //             crossAxisAlignment: CrossAxisAlignment.end,
                      //             children:<Widget>[
                      //               Expanded(
                      //                 child: RaisedButton(
                      //                   onPressed: () {
                      //                     if(state is ! DompetLoadingState){
                      //                       BlocProvider.of<DompetBloc>(context).add(
                      //                         SetdompetEvent(
                      //                           namadompet: txtdompet.text,
                      //                           saldo: txtsaldoawal.text,
                      //                           codepoint: mIcon.codePoint,
                      //                           fontfamily: mIcon.fontFamily,
                      //                           fontpackage: mIcon.fontPackage,
                      //                           color: MyConst.toHex(mColor)
                      //                         )
                      //                       );
                      //                     }
                      //                   },
                      //                   color: MyColors.blue,
                      //                   child: Text('BUAT DOMPET',style: TextStyle(color: Colors.white),),
                      //                 ),
                      //               )

                      //             ]
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  )));
            }));
  }

  void _pickIcon() async {
    Map<String, dynamic> mapback = await MyWidgets.showiconpickerdialog(context,
        iconPackMode: IconPack.fontAwesomeIcons,
        screenheight: MyScreens.safeVertical,
        screenwidth: MyScreens.safeHorizontal,
        pickedcolor: mColor,
        pickedicon: mIcon);
    setState(() {
      if (mapback != null &&
          mapback['icon'] != null &&
          mapback['color'] != null) {
        mIcon = mapback['icon'];
        mColor = mapback['color'];
      }
    });
    //   IconData icon = await FlutterIconPicker.showIconPicker(context,iconPackMode: IconPack.fontAwesomeIcons);
    //   cobaicon = Icon(icon);
    //   setState((){});
  }
}
