import 'dart:async';

import 'package:rekap_keuangan/blocs/tambahdompet_bloc.dart';
import 'package:rekap_keuangan/ui/main_screen.dart';
import 'package:rekap_keuangan/blocs/dompet_bloc.dart';
import 'package:rekap_keuangan/blocs/initdompet_bloc.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/IconPicker/iconPicker.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahDompetScreen extends StatelessWidget {
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
            create: (BuildContext context) => TambahDompetBloc(),
            child: TambahDompetScreenBody()));
  }
}

class TambahDompetScreenBody extends StatefulWidget {
  @override
  _TambahDompetScreenState createState() => _TambahDompetScreenState();
}

class _TambahDompetScreenState extends State<TambahDompetScreenBody> {
  IconData mIcon = IconData(62805,
      fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter');
  //IconData mIcon=IconDataSolid(0xf555);
  Color mColor = MyColors.blue;
  final txtdompet = TextEditingController();
  final txtsaldoawal = MoneyMaskedTextController(
      thousandSeparator: '.', precision: 0, decimalSeparator: '');
  final txtcatatan = TextEditingController();
  final FocusNode _txtdompetfocus = FocusNode();
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
    mIcon = IconData(62805,
        fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter');
    mColor = MyColors.blue;
    appbar = AppBar(
      title: Text('Tambah Dompet'),
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

    return BlocListener<TambahDompetBloc, TambahDompetState>(
        cubit: BlocProvider.of<TambahDompetBloc>(context),
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
                Fluttertoast.showToast(msg: "Dompet berhasil ditambahkan");
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
        child: BlocBuilder<TambahDompetBloc, TambahDompetState>(
            cubit: BlocProvider.of<TambahDompetBloc>(context),
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
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: Container(
                                        padding: EdgeInsets.all(20.0),
                                        child: Column(
                                          children: <Widget>[
                                            TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: txtdompet,
                                              focusNode: _txtdompetfocus,
                                              maxLength: 40,
                                              onFieldSubmitted: (value) {
                                                MyConst.fieldFocusChange(
                                                    context,
                                                    _txtdompetfocus,
                                                    _txtsaldoawalfocus);
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Dompet',
                                              ),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Nama dompet harus diisi';
                                                }
                                                if (isDuplicate) {
                                                  isDuplicate = false;
                                                  return 'Nama dompet tidak boleh sama';
                                                }
                                                return null;
                                              },
                                            ),
                                            Focus(
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  WhitelistingTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                controller: txtsaldoawal,
                                                focusNode: _txtsaldoawalfocus,
                                                decoration: InputDecoration(
                                                  labelText: 'Saldo Awal',
                                                ),
                                                onFieldSubmitted: (value) {
                                                  setState(() {
                                                    if (txtsaldoawal.text
                                                        .trim()
                                                        .isEmpty) {
                                                      txtsaldoawal.text = '0';
                                                    }
                                                  });
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _txtcatatanfocus);
                                                },
                                              ),
                                              onFocusChange: (hasfocus) {
                                                if (!hasfocus) {
                                                  setState(() {
                                                    if (txtsaldoawal.text
                                                        .trim()
                                                        .isEmpty) {
                                                      txtsaldoawal.text = '0';
                                                    }
                                                  });
                                                }
                                              },
                                            ),
                                            TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: txtcatatan,
                                              maxLength: 70,
                                              decoration: InputDecoration(
                                                  labelText:
                                                      'Catatan (optional)'),
                                            )
                                          ],
                                        )),
                                  )
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
                                    BlocProvider.of<TambahDompetBloc>(context)
                                        .add(SetdompetEvent(
                                            namadompet: txtdompet.text.trim(),
                                            saldo: int.parse(
                                                MyConst.removeseparator(
                                                    txtsaldoawal.text)),
                                            catatan: txtcatatan.text.trim(),
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
