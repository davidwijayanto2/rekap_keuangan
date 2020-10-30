import 'dart:async';

import 'package:rekap_keuangan/blocs/tambahmemo_bloc.dart';
import 'package:rekap_keuangan/blocs/initdompet_bloc.dart';
import 'package:rekap_keuangan/ui/tambahdmemo_screen.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahMemoScreen extends StatelessWidget {
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
            create: (BuildContext context) => TambahMemoBloc(),
            child: TambahMemoScreenBody()));
  }
}

class TambahMemoScreenBody extends StatefulWidget {
  @override
  _TambahMemoScreenState createState() => _TambahMemoScreenState();
}

class _TambahMemoScreenState extends State<TambahMemoScreenBody> {
  IconData mIcon = IconData(62805,
      fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter');
  //IconData mIcon=IconDataSolid(0xf555);
  Color mColor = MyColors.blue;
  final txtmemo = TextEditingController();
  final txtsaldoawal = TextEditingController();
  final txtcatatan = TextEditingController();
  final FocusNode _txtmemofocus = FocusNode();
  final FocusNode _txtsaldoawalfocus = FocusNode();
  final FocusNode _txtcatatanfocus = FocusNode();
  final _formkey = GlobalKey<FormState>();
  bool isDuplicate = false;
  SharedPreferences prefs;
  bool firstinit = true, adsShown = false;
  //final _nativeAdController = NativeAdmobController();
  double _height = 0;
  //StreamSubscription _subscription;
  AppBar appbar;
  @override
  void initState() {
    // TODO: implement initState
    print('init: ' + mIcon.codePoint.toString());
    mIcon = IconData(62805,
        fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter');
    mColor = MyColors.blue;
    appbar = AppBar(
      title: Text('Tambah Memo'),
      backgroundColor: MyColors.blue,
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: Icon(FontAwesomeIcons.arrowLeft),
        onPressed: () => Navigator.pop(context),
      ),
    );
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
    MyWidgets().buildLoadingDialog(context);
    MyScreens().initScreen(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //print(((widget.screenwidth*5)/(widget.screenheight*15)));
      if (firstinit) {
        txtsaldoawal.text = '0';
        firstinit = false;
      }
    });

    return BlocListener<TambahMemoBloc, TambahMemoState>(
        cubit: BlocProvider.of<TambahMemoBloc>(context),
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
                Fluttertoast.showToast(msg: "Memo berhasil ditambahkan");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return TambahDMemoScreen(
                        kdmemo: state.kdmemo, judul: txtmemo.text.trim());
                  }),
                ).then((val) => Navigator.pop(context, true));
                // Navigator.push(context, MaterialPageRoute(builder: (context){
                //   return TambahDMemoScreen(kdmemo: state.kdmemo,judul: txtmemo.text.trim());
                // }));
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
          if (state.isFailure) {
            Future.delayed(Duration(seconds: 1)).then((value) {
              MyWidgets.dialog.hide().whenComplete(() {
                print(MyWidgets.dialog.isShowing());
              });
            });
            Fluttertoast.showToast(
                msg: "Gagal menambahkan memo. Silahkan coba lagi!");
          }
        },
        child: BlocBuilder<TambahMemoBloc, TambahMemoState>(
            cubit: BlocProvider.of<TambahMemoBloc>(context),
            builder: (context, state) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: appbar,
                  body: SafeArea(
                      child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          top: MyScreens.safeVertical * 12 - _height,
                          bottom: MyScreens.safeVertical * 1,
                        ),
                        child: Text('Buat Memo Belanja',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22.0)),
                      ),
                      Container(
                        child: Text(
                          'Catat daftar belanja Anda agar tidak lupa!',
                          style: TextStyle(color: MyColors.gray),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Form(
                          key: _formkey,
                          child: Column(children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(
                                    top: MyScreens.safeVertical * 10),
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: txtmemo,
                                      maxLength: 50,
                                      decoration: InputDecoration(
                                        labelText: 'Memo',
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Nama memo harus diisi';
                                        }
                                        if (isDuplicate) {
                                          isDuplicate = false;
                                          return 'Nama memo tidak boleh sama';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (value) {
                                        if (!state.isLoading) {
                                          print('masuknotloading');
                                          if (_formkey.currentState
                                              .validate()) {
                                            print('masukvalidate');
                                            BlocProvider.of<TambahMemoBloc>(
                                                    context)
                                                .add(SetmemoEvent(
                                                    judul:
                                                        txtmemo.text.trim()));
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                )),
                            Container(
                                margin: EdgeInsets.only(
                                    top: MyScreens.safeVertical * 5),
                                padding: EdgeInsets.only(
                                    left: MyScreens.safeHorizontal * 25,
                                    right: MyScreens.safeHorizontal * 25),
                                height: MyScreens.safeVertical * 6.7,
                                child: ButtonTheme(
                                    minWidth: MyScreens.safeHorizontal * 50,
                                    child: RaisedButton(
                                      onPressed: () {
                                        if (!state.isLoading) {
                                          print('masuknotloading');
                                          if (_formkey.currentState
                                              .validate()) {
                                            print('masukvalidate');
                                            BlocProvider.of<TambahMemoBloc>(
                                                    context)
                                                .add(SetmemoEvent(
                                                    judul:
                                                        txtmemo.text.trim()));
                                          }
                                        }
                                      },
                                      color: MyColors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: MyColors.bluelight,
                                            width: 2.0),
                                      ),
                                      child: Text(
                                        'BUAT MEMO',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )))
                          ]))
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
