import 'dart:async';

import 'package:rekap_keuangan/blocs/ubahkategori_bloc.dart';
import 'package:rekap_keuangan/ui/main_screen.dart';
import 'package:rekap_keuangan/blocs/kategori_bloc.dart';
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

class UbahKategoriScreen extends StatelessWidget {
  final kdkategori;
  UbahKategoriScreen({Key key, @required this.kdkategori}) : super(key: key);
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
            create: (BuildContext context) => UbahKategoriBloc(),
            child: UbahKategoriScreenBody(
              kdkategori: this.kdkategori,
            )));
  }
}

class UbahKategoriScreenBody extends StatefulWidget {
  final kdkategori;
  @override
  _UbahKategoriScreenState createState() => _UbahKategoriScreenState();
  UbahKategoriScreenBody({this.kdkategori});
}

class _UbahKategoriScreenState extends State<UbahKategoriScreenBody> {
  IconData mIcon;
  //IconData mIcon=IconDataSolid(0xf555);
  Color mColor;
  final txtkategori = TextEditingController();
  final FocusNode _txtkategorifocus = FocusNode();
  final _formkey = GlobalKey<FormState>();
  bool isDuplicate = false;
  UbahKategoriBloc _ubahKategoriBloc;
  bool firstinit = true, adsShown = false;
  final _nativeAdController = NativeAdmobController();
  double _height = 0;
  StreamSubscription _subscription;
  @override
  void initState() {
    print('masuk initstate');
    mIcon = IconData(62805,
        fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter');
    mColor = MyColors.blue;
    _ubahKategoriBloc = BlocProvider.of<UbahKategoriBloc>(context);
    _ubahKategoriBloc
        .add(GetkategorieditdataEvent(kdkategori: widget.kdkategori));
    super.initState();
    //_subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    //_UbahkategoriBloc =
  }

  @override
  void dispose() {
    super.dispose();
    //_subscription.cancel();
    _nativeAdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyWidgets().buildLoadingDialog(context);
    MyScreens().initScreen(context);

    return BlocListener<UbahKategoriBloc, UbahKategoriState>(
        cubit: BlocProvider.of<UbahKategoriBloc>(context),
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
                Fluttertoast.showToast(msg: "Kategori berhasil diubah");
                Navigator.pop(context, true);
              });
            });
          }
          if (state.isDeleted) {
            Future.delayed(Duration(seconds: 1)).then((value) {
              MyWidgets.dialog.hide().whenComplete(() {
                Fluttertoast.showToast(msg: "Kategori berhasil dihapus");
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
          if (state.isLoaded) {
            Future.delayed(Duration(seconds: 1)).then((value) {
              MyWidgets.dialog.hide().whenComplete(() {
                print(MyWidgets.dialog.isShowing());
              });
            });
            if (firstinit) {
              print('masuk callback');
              txtkategori.text = state.kategoridata['namakategori'];
              mIcon = IconData(state.kategoridata['codepoint'],
                  fontFamily: state.kategoridata['fontfamily'],
                  fontPackage: state.kategoridata['fontpackage']);
              mColor = MyConst.fromHex(state.kategoridata['color']);
              firstinit = false;
            }
          }
        },
        child: BlocBuilder<UbahKategoriBloc, UbahKategoriState>(
            cubit: BlocProvider.of<UbahKategoriBloc>(context),
            builder: (context, state) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: Text('Ubah Kategori'),
                    backgroundColor: MyColors.blue,
                    automaticallyImplyLeading: true,
                    leading: IconButton(
                      icon: Icon(FontAwesomeIcons.arrowLeft),
                      onPressed: () => Navigator.pop(context),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.trash),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Peringatan'),
                                  content: Text(
                                      'Transaksi yang berhubungan dengan kategori ini akan ikut terhapus. Apakah anda yakin akan menghapus kategori ini?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Batal'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Hapus'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _ubahKategoriBloc.add(
                                            DeletekategoriEvent(
                                                kdkategori: widget.kdkategori));
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                      )
                    ],
                  ),
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
                                              labelText: 'Kategori',
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Nama kategori harus diisi';
                                              }
                                              if (isDuplicate) {
                                                isDuplicate = false;
                                                return 'Nama kategori tidak boleh sama';
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
                                    BlocProvider.of<UbahKategoriBloc>(context)
                                        .add(EditkategoriEvent(
                                            kdkategori: widget.kdkategori,
                                            namakategori:
                                                txtkategori.text.trim(),
                                            codepoint: mIcon.codePoint,
                                            fontfamily: mIcon.fontFamily,
                                            fontpackage: mIcon.fontPackage,
                                            color: MyConst.toHex(mColor)));
                                  }
                                }
                              },
                            )),
                      ),
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
  }
}
