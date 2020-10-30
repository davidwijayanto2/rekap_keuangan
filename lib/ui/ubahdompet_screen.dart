import 'dart:async';

import 'package:rekap_keuangan/blocs/Ubahdompet_bloc.dart';
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

class UbahDompetScreen extends StatelessWidget {
  final kddompet;
  UbahDompetScreen({Key key, @required this.kddompet}) : super(key: key);
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
            create: (BuildContext context) => UbahDompetBloc(),
            child: UbahDompetScreenBody(
              kddompet: this.kddompet,
            )));
  }
}

class UbahDompetScreenBody extends StatefulWidget {
  final kddompet;
  @override
  _UbahDompetScreenState createState() => _UbahDompetScreenState();
  UbahDompetScreenBody({this.kddompet});
}

class _UbahDompetScreenState extends State<UbahDompetScreenBody> {
  IconData mIcon;
  //IconData mIcon=IconDataSolid(0xf555);
  Color mColor;
  final txtdompet = TextEditingController();
  final txtcatatan = TextEditingController();
  final FocusNode _txtdompetfocus = FocusNode();
  final FocusNode _txtcatatanfocus = FocusNode();
  final _formkey = GlobalKey<FormState>();
  bool isDuplicate = false;
  UbahDompetBloc _ubahDompetBloc;
  bool firstinit = true, adsShown = false;
  //final _nativeAdController = NativeAdmobController();
  double _height = 0;
  //StreamSubscription _subscription;
  @override
  void initState() {
    print('masuk initstate');
    mIcon = IconData(62805,
        fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter');
    mColor = MyColors.blue;
    _ubahDompetBloc = BlocProvider.of<UbahDompetBloc>(context);
    _ubahDompetBloc.add(GetdompeteditdataEvent(kddompet: widget.kddompet));
    super.initState();
    //_subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    //_UbahDompetBloc =
  }

  @override
  void dispose() {
    super.dispose();
    //_subscription.cancel();
    //_nativeAdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyWidgets().buildLoadingDialog(context);
    MyScreens().initScreen(context);

    return BlocListener<UbahDompetBloc, UbahDompetState>(
        cubit: BlocProvider.of<UbahDompetBloc>(context),
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
                Fluttertoast.showToast(msg: "Dompet berhasil diubah");
                Navigator.pop(context, true);
              });
            });
          }
          if (state.isDeleted) {
            Future.delayed(Duration(seconds: 1)).then((value) {
              MyWidgets.dialog.hide().whenComplete(() {
                Fluttertoast.showToast(msg: "Dompet berhasil dihapus");
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
              txtdompet.text = state.dompetdata['namadompet'];
              txtcatatan.text = state.dompetdata['catatan'];
              mIcon = IconData(state.dompetdata['codepoint'],
                  fontFamily: state.dompetdata['fontfamily'],
                  fontPackage: state.dompetdata['fontpackage']);
              mColor = MyConst.fromHex(state.dompetdata['color']);
              firstinit = false;
            }
          }
        },
        child: BlocBuilder<UbahDompetBloc, UbahDompetState>(
            cubit: BlocProvider.of<UbahDompetBloc>(context),
            builder: (context, state) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: Text('Ubah Dompet'),
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
                                      'Transaksi yang berhubungan dengan dompet ini akan dihapus juga. Apakah anda yakin akan menghapus dompet ini?'),
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
                                        _ubahDompetBloc.add(DeletedompetEvent(
                                            kddompet: widget.kddompet));
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
                                                    _txtcatatanfocus);
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
                                            TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: txtcatatan,
                                              maxLength: 50,
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
                                    BlocProvider.of<UbahDompetBloc>(context)
                                        .add(EditdompetEvent(
                                            kddompet: widget.kddompet,
                                            namadompet: txtdompet.text.trim(),
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
