import 'package:rekap_keuangan/ui/main_screen.dart';
import 'package:rekap_keuangan/blocs/dompet_bloc.dart';
import 'package:rekap_keuangan/blocs/initdompet_bloc.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/IconPicker/iconPicker.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class InitDompetScreen extends StatelessWidget {
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
            create: (BuildContext context) => InitDompetBloc(),
            child: Scaffold(body: SafeArea(child: InitDompetScreenBody()))));
  }
}

class InitDompetScreenBody extends StatefulWidget {
  @override
  _InitDompetScreenState createState() => _InitDompetScreenState();
}

class _InitDompetScreenState extends State<InitDompetScreenBody> {
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
  SharedPreferences prefs;
  bool firstinit = true;
  @override
  void initState() {
    // TODO: implement initState
    print('init: ' + mIcon.codePoint.toString());
    mIcon = IconData(62805,
        fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter');
    mColor = MyColors.blue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _icon=const IconDataSolid(0xf555);
    // _color = MyColor.blue;

    // final buffer = StringBuffer();
    // buffer.write(62805.toRadixString(16));
    // print(int.parse(buffer.toString(),radix: 16));
    // print(IconData(62805,fontFamily: 'FontAwesomeSolid',fontPackage: 'font_awesome_flutter'));
    // print(mColor);
    _setlocaldata(_context) async {
      prefs = await SharedPreferences.getInstance();
      prefs.setBool("fintro", true);

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return MainScreen();
      }), ModalRoute.withName('/'));
    }

    MyWidgets().buildLoadingDialog(context);
    MyScreens().initScreen(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //print(((widget.screenwidth*5)/(widget.screenheight*15)));
      if (firstinit) {
        txtdompet.text = 'Kas Tunai';
        txtsaldoawal.text = '0';
        firstinit = false;
      }
    });
    return BlocListener<InitDompetBloc, InitDompetState>(
        cubit: BlocProvider.of<InitDompetBloc>(context),
        listener: (context, state) async {
          print('masuklistener');
          if (state is InitDompetLoadingState) {
            print('masuk loading');
            await MyWidgets.dialog.show();
          } else if (state is InitDompetSuccessState) {
            print('masuk success');
            Future.delayed(Duration(seconds: 1)).then((value) {
              MyWidgets.dialog.hide().whenComplete(() {
                Fluttertoast.showToast(msg: "Dompet berhasil ditambahkan");
                _setlocaldata(context);
              });
            });
          } else {
            Future.delayed(Duration(seconds: 1)).then((value) {
              MyWidgets.dialog.hide().whenComplete(() {
                Fluttertoast.showToast(
                    msg: "Dompet gagal ditambahkan. Silahkan coba lagi.");
              });
            });
          }
        },
        child: BlocBuilder<InitDompetBloc, InitDompetState>(
            cubit: BlocProvider.of<InitDompetBloc>(context),
            builder: (context, state) {
              return ListView(
                padding: EdgeInsets.all(20.0),
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 30.0),
                    child: Text('Buat Dompet Pertama Anda',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24.0)),
                  ),
                  Container(
                    child: Text(
                      'Rekap keuangan membantu memonitor pengeluaran dari setiap dompet.\nSetiap dompet mewakili sumber dana Anda, contohnya seperti Kas Tunai atau Rekening Bank.',
                      style: TextStyle(color: MyColors.gray),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30.0, bottom: 5.0),
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
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: txtdompet,
                          focusNode: _txtdompetfocus,
                          maxLength: 40,
                          onFieldSubmitted: (value) {
                            MyConst.fieldFocusChange(
                                context, _txtdompetfocus, _txtsaldoawalfocus);
                          },
                          decoration: InputDecoration(
                            labelText: 'Dompet',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Nama dompet harus diisi';
                            }
                            return null;
                          },
                        ),
                        Focus(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            controller: txtsaldoawal,
                            focusNode: _txtsaldoawalfocus,
                            decoration: InputDecoration(
                              labelText: 'Saldo Awal',
                            ),
                            onFieldSubmitted: (value) {
                              setState(() {
                                if (txtsaldoawal.text.trim().isEmpty) {
                                  txtsaldoawal.text = '0';
                                  print('masuk kelaur1');
                                }
                              });
                              FocusScope.of(context)
                                  .requestFocus(_txtcatatanfocus);
                            },
                          ),
                          onFocusChange: (hasfocus) {
                            if (!hasfocus) {
                              setState(() {
                                if (txtsaldoawal.text.trim().isEmpty) {
                                  txtsaldoawal.text = '0';
                                  print('masuk kelaur');
                                }
                              });
                            }
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: txtcatatan,
                          focusNode: _txtcatatanfocus,
                          maxLength: 70,
                          decoration:
                              InputDecoration(labelText: 'Catatan (optional)'),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                top: MyScreens.safeVertical * 20),
                            padding: EdgeInsets.only(
                                left: MyScreens.safeHorizontal * 25,
                                right: MyScreens.safeHorizontal * 25),
                            height: MyScreens.safeVertical * 6.7,
                            child: RaisedButton(
                              onPressed: () {
                                if (state is! InitDompetLoadingState) {
                                  if (_formkey.currentState.validate()) {
                                    BlocProvider.of<InitDompetBloc>(context)
                                        .add(SetinitdompetEvent(
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
                              color: MyColors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                    color: MyColors.bluelight, width: 2.0),
                              ),
                              child: Text(
                                'BUAT DOMPET',
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              );
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
