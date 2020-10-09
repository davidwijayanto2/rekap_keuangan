import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:rekap_keuangan/blocs/tambahtransaksi_bloc.dart';
import 'package:rekap_keuangan/blocs/ubahtransaksi_bloc.dart';
import 'package:rekap_keuangan/ui/main_screen.dart';
import 'package:rekap_keuangan/ui/listdompet_screen.dart';
import 'package:rekap_keuangan/ui/listkategori_screen.dart';
import 'package:rekap_keuangan/blocs/transaksi_bloc.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UbahTransaksiScreen extends StatelessWidget {
  final kdtransaksi, idtransaksi;
  UbahTransaksiScreen({this.idtransaksi, this.kdtransaksi});
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
            create: (BuildContext context) => UbahTransaksiBloc(),
            child: UbahTransaksiScreenBody(
                idtransaksi: this.idtransaksi, kdtransaksi: this.kdtransaksi)));
  }
}

class Iconcolor {
  var kddompet, kdkategori;
  FaIcon icondompet, iconkategori;
  Color colordompet, colorkategori;
  Iconcolor(
      {this.kddompet,
      this.kdkategori,
      this.colordompet,
      this.icondompet,
      this.colorkategori,
      this.iconkategori});
}

class UbahTransaksiScreenBody extends StatefulWidget {
  final kdtransaksi, idtransaksi;
  UbahTransaksiScreenBody({this.idtransaksi, this.kdtransaksi});
  @override
  _UbahTransaksiScreenState createState() => _UbahTransaksiScreenState();
}

class _UbahTransaksiScreenState extends State<UbahTransaksiScreenBody> {
  Color colorasaltransfer, colortujuantransfer;
  final txtkategori = TextEditingController();
  final txtdompet = TextEditingController();
  final txtjumlah = MoneyMaskedTextController(
      thousandSeparator: '.', precision: 0, decimalSeparator: '');
  final txtcatatan = TextEditingController();
  final txttanggal = TextEditingController();
  final FocusNode txtkategorifocus = FocusNode();
  final FocusNode txtdompetfocus = FocusNode();
  final FocusNode txtjumlahfocus = FocusNode();
  final FocusNode txtcatatanfocus = FocusNode();
  final FocusNode txttanggalfocus = FocusNode();
  final formkey = GlobalKey<FormState>();
  UbahTransaksiBloc _ubahtransaksiBloc;
  SharedPreferences prefs;
  bool firstinit = true, adsShown = false;
  final _nativeAdController = NativeAdmobController();
  double _height = 0;
  StreamSubscription _subscription;
  AppBar appbar;
  var jenis;
  bool transfer;
  var imageFile;
  var image64;
  Iconcolor mIconcolor = new Iconcolor();
  List<Map<String, dynamic>> listtransaksitransfer;
  final picker = ImagePicker();

  @override
  void initState() {
    _ubahtransaksiBloc = BlocProvider.of<UbahTransaksiBloc>(context);
    _ubahtransaksiBloc
        .add(GetdatatransaksiEvent(idtransaksi: widget.idtransaksi));
    super.initState();
    //_subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
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

    return BlocListener<UbahTransaksiBloc, UbahTransaksiState>(
        cubit: BlocProvider.of<UbahTransaksiBloc>(context),
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
                Fluttertoast.showToast(msg: "Transaksi berhasil diubah");
                Navigator.pop(context, true);
              });
            });
          }
          if (state.isCheckedtransfer) {
            Future.delayed(Duration(milliseconds: 500)).then((value) {
              MyWidgets.dialog.hide().whenComplete(() {
                listtransaksitransfer = state.listtransaksiedit;
              });
            });
          }
          if (state.isDeleted) {
            Future.delayed(Duration(seconds: 1)).then((value) {
              MyWidgets.dialog.hide().whenComplete(() {
                Fluttertoast.showToast(msg: "Transaksi berhasil dihapus");
                Navigator.pop(context, true);
              });
            });
          }
          if (state.isLoaded) {
            //print('loaded: '+)
            Future.delayed(Duration(seconds: 1)).then((value) {
              MyWidgets.dialog.hide().whenComplete(() {
                print('transaksi: ' + state.listtransaksiedit.toString());
                if (firstinit) {
                  transfer =
                      state.listtransaksiedit[0]['jenis'] == 't' ? true : false;
                  jenis = state.listtransaksiedit[0]['keluar'].round() == 0
                      ? 'm'
                      : 'k';
                  txtdompet.text = state.listtransaksiedit[0]['namadompet'];
                  txtkategori.text = state.listtransaksiedit[0]['namakategori'];
                  txtjumlah.text =
                      state.listtransaksiedit[0]['keluar'].round() == 0
                          ? MyConst.thousandseparator(
                              state.listtransaksiedit[0]['masuk'].round())
                          : MyConst.thousandseparator(
                              state.listtransaksiedit[0]['keluar'].round());
                  txttanggal.text = MyConst.datetoShowFormat(
                      state.listtransaksiedit[0]['tanggaltransaksi']);
                  if (state.listtransaksiedit[0]['catatan'] != null) {
                    txtcatatan.text = state.listtransaksiedit[0]['catatan'];
                  }

                  setState(() {
                    mIconcolor.colordompet = MyConst.fromHex(
                        state.listtransaksiedit[0]['colordompet']);
                    mIconcolor.colorkategori = MyConst.fromHex(
                        state.listtransaksiedit[0]['colorkategori']);
                    mIconcolor.icondompet = FaIcon(
                        IconData(state.listtransaksiedit[0]['codepointdompet'],
                            fontFamily: state.listtransaksiedit[0]
                                ['fontfamilydompet'],
                            fontPackage: state.listtransaksiedit[0]
                                ['fontpackagedompet']),
                        color: Colors.white,
                        size: MyScreens.safeVertical * 2.5);
                    mIconcolor.iconkategori = FaIcon(
                        IconData(
                            state.listtransaksiedit[0]['codepointkategori'],
                            fontFamily: state.listtransaksiedit[0]
                                ['fontfamilykategori'],
                            fontPackage: state.listtransaksiedit[0]
                                ['fontpackagekategori']),
                        color: Colors.white,
                        size: MyScreens.safeVertical * 2.5);
                    mIconcolor.kddompet =
                        state.listtransaksiedit[0]['kddompet'];
                    mIconcolor.kdkategori =
                        state.listtransaksiedit[0]['kdkategori'];

                    if (state.listtransaksiedit[0]['foto'] != null) {
                      //imageFile =

                      imageFile = Image.memory(
                          base64Decode(state.listtransaksiedit[0]['foto']));
                      image64 = state.listtransaksiedit[0]['foto'];
                    }
                  });
                  firstinit = false;
                  BlocProvider.of<UbahTransaksiBloc>(context).add(
                      GetdatatransaksitransferEvent(
                          idtransaksi: widget.idtransaksi,
                          kdtransaksi: widget.kdtransaksi));
                }
              });
            });
          }
        },
        child: BlocBuilder<UbahTransaksiBloc, UbahTransaksiState>(
            cubit: BlocProvider.of<UbahTransaksiBloc>(context),
            builder: (context, state) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: Text('Ubah Transaksi'),
                    backgroundColor: MyColors.blue,
                    automaticallyImplyLeading: true,
                    leading: IconButton(
                      icon: Icon(FontAwesomeIcons.arrowLeft),
                      onPressed: () => Navigator.pop(context),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(FontAwesomeIcons.trash),
                        onPressed: () {
                          if (listtransaksitransfer.length > 0) {
                            Widget jumlahtransaksi;
                            if (listtransaksitransfer[0]['keluar'] > 0) {
                              jumlahtransaksi = Text(
                                'Rp. -' +
                                    MyConst.thousandseparator(
                                        listtransaksitransfer[0]['keluar']),
                                style: TextStyle(color: MyColors.red),
                              );
                            } else {
                              jumlahtransaksi = Text(
                                'Rp. ' +
                                    MyConst.thousandseparator(
                                        listtransaksitransfer[0]['masuk']),
                                style: TextStyle(color: MyColors.green),
                              );
                            }
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Peringatan'),
                                    content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                              'Jika Anda menghapus transaksi ini, maka transaksi dibawah ini juga akan ikut terhapus'),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: MyScreens.safeVertical * 2,
                                                bottom:
                                                    MyScreens.safeVertical * 2),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                              right: MyScreens
                                                                      .safeHorizontal *
                                                                  4),
                                                          width: MyScreens
                                                                  .safeVertical *
                                                              5,
                                                          height: MyScreens
                                                                  .safeVertical *
                                                              5,
                                                          decoration: new BoxDecoration(
                                                              color: MyConst.fromHex(
                                                                  listtransaksitransfer[
                                                                          0][
                                                                      'colorkategori']),
                                                              shape: BoxShape
                                                                  .circle),
                                                          child: new Center(
                                                            child: FaIcon(
                                                              IconData(
                                                                  listtransaksitransfer[
                                                                          0][
                                                                      'codepointkategori'],
                                                                  fontFamily:
                                                                      listtransaksitransfer[
                                                                              0]
                                                                          [
                                                                          'fontfamilykategori'],
                                                                  fontPackage:
                                                                      listtransaksitransfer[
                                                                              0]
                                                                          [
                                                                          'fontpackagekategori']),
                                                              color:
                                                                  Colors.white,
                                                              size: MyScreens
                                                                      .safeVertical *
                                                                  2.5,
                                                            ),
                                                          )),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            listtransaksitransfer[
                                                                    0][
                                                                'namakategori'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          if (listtransaksitransfer[
                                                                      0]
                                                                  ['catatan'] !=
                                                              "")
                                                            Text(
                                                                listtransaksitransfer[
                                                                        0]
                                                                    ['catatan'],
                                                                style: TextStyle(
                                                                    color: MyColors
                                                                        .gray)),
                                                          jumlahtransaksi
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ]),
                                          ),
                                          Text(
                                              'Apakah Anda yakin akan melanjutkan untuk menghapus data transaksi tersebut?'),
                                        ]),
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
                                          _ubahtransaksiBloc.add(
                                              DeletetransaksiEvent(
                                                  kdtransaksi:
                                                      widget.kdtransaksi));
                                        },
                                      )
                                    ],
                                  );
                                });
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Peringatan'),
                                    content: Text(
                                        'Transaksi yang dihapus tidak bisa dikembalikan lagi. Apakah anda yakin akan menghapus transaksi ini?'),
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
                                          _ubahtransaksiBloc.add(
                                              DeletetransaksiEvent(
                                                  kdtransaksi:
                                                      widget.kdtransaksi));
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
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
                                    top: MyScreens.safeVertical * 12,
                                    bottom: MyScreens.safeVertical * 1),
                                padding: EdgeInsets.only(
                                    top: MyScreens.safeVertical * 2),
                                color: Colors.white,
                                child: Column(
                                  children: <Widget>[
                                    Form(
                                        key: formkey,
                                        child: Column(children: <Widget>[
                                          Container(
                                              padding: EdgeInsets.only(
                                                right:
                                                    MyScreens.safeHorizontal *
                                                        5,
                                                left: MyScreens.safeHorizontal *
                                                    5,
                                                bottom:
                                                    MyScreens.safeVertical * 3,
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Material(
                                                      color: Colors.white,
                                                      child: InkWell(
                                                          child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                    margin: EdgeInsets.only(
                                                                        right: MyScreens.safeHorizontal *
                                                                            2),
                                                                    width: MyScreens
                                                                            .safeVertical *
                                                                        5,
                                                                    height:
                                                                        MyScreens.safeVertical *
                                                                            5,
                                                                    decoration: new BoxDecoration(
                                                                        color: mIconcolor
                                                                            .colordompet,
                                                                        shape: BoxShape
                                                                            .circle),
                                                                    child: new Center(
                                                                        child: mIconcolor
                                                                            .icondompet)),
                                                                SizedBox(
                                                                  width: MyScreens
                                                                          .safeHorizontal *
                                                                      2,
                                                                ),
                                                                Flexible(
                                                                  child: TextFormField(
                                                                      controller: txtdompet,
                                                                      focusNode: txtdompetfocus,
                                                                      validator: (value) {
                                                                        if (value ==
                                                                            'Pilih Dompet') {
                                                                          return 'Dompet harus diisi';
                                                                        }
                                                                        return null;
                                                                      },
                                                                      decoration: InputDecoration(errorStyle: TextStyle(color: Theme.of(context).errorColor)),
                                                                      enabled: false),
                                                                )
                                                              ]),
                                                          onTap: () {
                                                            FocusScopeNode
                                                                currentFocus =
                                                                FocusScope.of(
                                                                    context);
                                                            if (!currentFocus
                                                                .hasPrimaryFocus) {
                                                              currentFocus
                                                                  .unfocus();
                                                            }
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                                return ListDompetScreen(
                                                                    kddompetpicked: listtransaksitransfer.length >
                                                                            0
                                                                        ? listtransaksitransfer[0]
                                                                            [
                                                                            'kddompet']
                                                                        : null);
                                                              }),
                                                            ).then((val) {
                                                              print(
                                                                  val['color']);
                                                              setState(() {
                                                                txtdompet.text =
                                                                    val['namadompet'];
                                                                mIconcolor
                                                                        .kddompet =
                                                                    val['kddompet'];
                                                                mIconcolor
                                                                        .colordompet =
                                                                    val['color'];
                                                                mIconcolor
                                                                        .icondompet =
                                                                    val['icon'];
                                                              });
                                                            });
                                                          })),
                                                  Material(
                                                    color: Colors.white,
                                                    child: InkWell(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                              margin: EdgeInsets.only(
                                                                  right: MyScreens
                                                                          .safeHorizontal *
                                                                      2),
                                                              width: MyScreens
                                                                      .safeVertical *
                                                                  5,
                                                              height: MyScreens
                                                                      .safeVertical *
                                                                  5,
                                                              decoration: new BoxDecoration(
                                                                  color: mIconcolor
                                                                      .colorkategori,
                                                                  shape: BoxShape
                                                                      .circle),
                                                              child: new Center(
                                                                  child: mIconcolor
                                                                      .iconkategori)),
                                                          SizedBox(
                                                            width: MyScreens
                                                                    .safeHorizontal *
                                                                2,
                                                          ),
                                                          Flexible(
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  txtkategori,
                                                              focusNode:
                                                                  txtkategorifocus,
                                                              decoration: InputDecoration(
                                                                  errorStyle: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .errorColor)),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                    'Pilih Kategori') {
                                                                  return 'Kategori harus diisi';
                                                                }
                                                                return null;
                                                              },
                                                              enabled: false,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      onTap: () {
                                                        if (!transfer) {
                                                          FocusScopeNode
                                                              currentFocus =
                                                              FocusScope.of(
                                                                  context);
                                                          if (!currentFocus
                                                              .hasPrimaryFocus) {
                                                            currentFocus
                                                                .unfocus();
                                                          }
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                              return ListKategoriScreen(
                                                                  jenis: jenis);
                                                            }),
                                                          ).then((val) {
                                                            setState(() {
                                                              txtkategori.text =
                                                                  val['namakategori'];
                                                              mIconcolor
                                                                      .kdkategori =
                                                                  val['kdkategori'];
                                                              mIconcolor
                                                                      .iconkategori =
                                                                  val['icon'];
                                                              mIconcolor
                                                                      .colorkategori =
                                                                  val['color'];
                                                            });
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                              right: MyScreens
                                                                      .safeHorizontal *
                                                                  2),
                                                          width: MyScreens
                                                                  .safeVertical *
                                                              5,
                                                          height: MyScreens
                                                                  .safeVertical *
                                                              5,
                                                          decoration:
                                                              new BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: new Center(
                                                            child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .moneyBill,
                                                                size: MyScreens
                                                                        .safeVertical *
                                                                    2.5),
                                                          )),
                                                      SizedBox(
                                                        width: MyScreens
                                                                .safeHorizontal *
                                                            2,
                                                      ),
                                                      Flexible(
                                                        child: Focus(
                                                          child: TextFormField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            inputFormatters: <
                                                                TextInputFormatter>[
                                                              WhitelistingTextInputFormatter
                                                                  .digitsOnly
                                                            ],
                                                            controller:
                                                                txtjumlah,
                                                            focusNode:
                                                                txtjumlahfocus,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Jumlah',
                                                            ),
                                                            validator: (value) {
                                                              if (int.parse(MyConst
                                                                      .removeseparator(
                                                                          value
                                                                              .trim())) ==
                                                                  0) {
                                                                return 'Jumlah transaksi harus diisi';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                          onFocusChange:
                                                              (hasfocus) {
                                                            if (!hasfocus) {
                                                              setState(() {
                                                                if (txtjumlah
                                                                    .text
                                                                    .trim()
                                                                    .isEmpty) {
                                                                  txtjumlah
                                                                          .text =
                                                                      '0';
                                                                }
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                              right: MyScreens
                                                                      .safeHorizontal *
                                                                  2),
                                                          width: MyScreens
                                                                  .safeVertical *
                                                              5,
                                                          height: MyScreens
                                                                  .safeVertical *
                                                              5,
                                                          decoration:
                                                              new BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: new Center(
                                                            child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .alignJustify,
                                                                size: MyScreens
                                                                        .safeVertical *
                                                                    2.5),
                                                          )),
                                                      SizedBox(
                                                        width: MyScreens
                                                                .safeHorizontal *
                                                            2,
                                                      ),
                                                      Flexible(
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          controller:
                                                              txtcatatan,
                                                          focusNode:
                                                              txtcatatanfocus,
                                                          maxLength: 70,
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      'Catatan (optional)'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                              right: MyScreens
                                                                      .safeHorizontal *
                                                                  2),
                                                          width: MyScreens
                                                                  .safeVertical *
                                                              5,
                                                          height: MyScreens
                                                                  .safeVertical *
                                                              5,
                                                          decoration:
                                                              new BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: new Center(
                                                            child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .calendarDay,
                                                                size: MyScreens
                                                                        .safeVertical *
                                                                    2.5),
                                                          )),
                                                      SizedBox(
                                                        width: MyScreens
                                                                .safeHorizontal *
                                                            2,
                                                      ),
                                                      Flexible(
                                                        child: Material(
                                                            color: Colors.white,
                                                            child: InkWell(
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                controller:
                                                                    txttanggal,
                                                                focusNode:
                                                                    txttanggalfocus,
                                                                decoration: InputDecoration(
                                                                    errorStyle:
                                                                        TextStyle(
                                                                            color:
                                                                                Theme.of(context).errorColor)),
                                                                validator:
                                                                    (value) {
                                                                  if (value ==
                                                                      'Tanggal') {
                                                                    return 'Tanggal transaksi harus diisi';
                                                                  }

                                                                  return null;
                                                                },
                                                                enabled: false,
                                                              ),
                                                              onTap: () {
                                                                FocusScopeNode
                                                                    currentFocus =
                                                                    FocusScope.of(
                                                                        context);
                                                                if (!currentFocus
                                                                    .hasPrimaryFocus) {
                                                                  currentFocus
                                                                      .unfocus();
                                                                }
                                                                _selectDate(
                                                                    txttanggal);
                                                              },
                                                            )),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )),
                                        ]))
                                  ],
                                )),
                            Container(
                              margin: EdgeInsets.only(
                                  left: MyScreens.safeHorizontal * 5),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Bukti Foto (Optional)',
                                style: TextStyle(color: MyColors.gray),
                              ),
                            ),
                            GestureDetector(
                                child: _setImageView(jenis),
                                onTap: () {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  _showSelectionDialog(context, jenis);
                                }),
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
                                  if (formkey.currentState.validate()) {
                                    print('masukvalidate');
                                    processedit();
                                  }
                                }
                              },
                            )),
                      ),
                      //transaksiKeluarmasuk(state,_formkeytransfer)
                    ],
                  )));
            }));
  }

  void processedit() {
    if (listtransaksitransfer.length > 0) {
      Widget jumlahtransaksi;
      if (listtransaksitransfer[0]['keluar'] > 0) {
        jumlahtransaksi = Text(
          'Rp. -' +
              MyConst.thousandseparator(listtransaksitransfer[0]['keluar']),
          style: TextStyle(color: MyColors.red),
        );
      } else {
        jumlahtransaksi = Text(
          'Rp. ' + MyConst.thousandseparator(listtransaksitransfer[0]['masuk']),
          style: TextStyle(color: MyColors.green),
        );
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Peringatan'),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(
                    'Jika Anda mengubah transaksi ini, maka transaksi dibawah ini juga akan ikut berubah'),
                Container(
                  margin: EdgeInsets.only(
                      top: MyScreens.safeVertical * 2,
                      bottom: MyScreens.safeVertical * 2),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(
                                    right: MyScreens.safeHorizontal * 4),
                                width: MyScreens.safeVertical * 5,
                                height: MyScreens.safeVertical * 5,
                                decoration: new BoxDecoration(
                                    color: MyConst.fromHex(
                                        listtransaksitransfer[0]
                                            ['colorkategori']),
                                    shape: BoxShape.circle),
                                child: new Center(
                                  child: FaIcon(
                                    IconData(
                                        listtransaksitransfer[0]
                                            ['codepointkategori'],
                                        fontFamily: listtransaksitransfer[0]
                                            ['fontfamilykategori'],
                                        fontPackage: listtransaksitransfer[0]
                                            ['fontpackagekategori']),
                                    color: Colors.white,
                                    size: MyScreens.safeVertical * 2.5,
                                  ),
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  listtransaksitransfer[0]['namakategori'],
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                if (listtransaksitransfer[0]['catatan'] != "")
                                  Text(listtransaksitransfer[0]['catatan'],
                                      style: TextStyle(color: MyColors.gray)),
                                jumlahtransaksi
                              ],
                            )
                          ],
                        ),
                      ]),
                ),
                Text(
                    'Apakah Anda yakin akan melanjutkan untuk mengubah data transaksi tersebut?'),
              ]),
              actions: <Widget>[
                FlatButton(
                  child: Text('Batal'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Ubah'),
                  onPressed: () {
                    Navigator.pop(context);
                    _ubahtransaksiBloc.add(EdittransaksitransferEvent(
                        idtransaksi: widget.idtransaksi,
                        idtransaksi2: listtransaksitransfer[0]['idtransaksi'],
                        kddompet: mIconcolor.kddompet,
                        keluar: (jenis == 'k')
                            ? MyConst.removeseparator(txtjumlah.text)
                            : 0,
                        masuk: (jenis == 'm')
                            ? MyConst.removeseparator(txtjumlah.text)
                            : 0,
                        keluar2: (listtransaksitransfer[0]['keluar'] > 0)
                            ? MyConst.removeseparator(txtjumlah.text)
                            : 0,
                        masuk2: (listtransaksitransfer[0]['masuk'] > 0)
                            ? MyConst.removeseparator(txtjumlah.text)
                            : 0,
                        catatan: txtcatatan.text.trim(),
                        tanggaltransaksi:
                            MyConst.datetoStoreFormat(txttanggal.text)));
                  },
                )
              ],
            );
          });
    } else {
      BlocProvider.of<UbahTransaksiBloc>(context).add(EdittransaksiEvent(
          kdtransaksi: widget.kdtransaksi,
          kddompet: mIconcolor.kddompet,
          kdkategori: mIconcolor.kdkategori,
          keluar: (jenis == 'k') ? MyConst.removeseparator(txtjumlah.text) : 0,
          masuk: (jenis == 'm') ? MyConst.removeseparator(txtjumlah.text) : 0,
          catatan: txtcatatan.text.trim(),
          foto: image64,
          tanggaltransaksi: MyConst.datetoStoreFormat(txttanggal.text)));
    }
  }

  Future _selectDate(txttanggal) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2021));

    if (picked != null)
      setState(() => txttanggal.text = DateFormat('dd-MM-yyyy').format(picked));
  }

  Widget _setImageView(_jenis) {
    if (imageFile != null) {
      return Container(
          height: MyScreens.safeVertical * 35,
          width: MyScreens.safeHorizontal * 70,
          margin: EdgeInsets.only(
              top: MyScreens.safeVertical * 2,
              bottom: MyScreens.safeVertical * 2,
              left: MyScreens.safeHorizontal * 5,
              right: MyScreens.safeHorizontal * 5),
          child: Center(child: imageFile));
    } else {
      return Container(
          height: MyScreens.safeVertical * 35,
          margin: EdgeInsets.only(
              top: MyScreens.safeVertical * 2,
              bottom: MyScreens.safeVertical * 2,
              left: MyScreens.safeHorizontal * 5,
              right: MyScreens.safeHorizontal * 5),
          color: MyColors.graylight,
          child: Center(
              child: Icon(
            FontAwesomeIcons.plus,
            size: MyScreens.safeVertical * 5,
          )));
    }
  }

  Future<void> _showSelectionDialog(BuildContext context, _jenis) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context, _jenis);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _openCamera(context, _jenis);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _openGallery(BuildContext context, _jenis) async {
    var picture = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (picture != null) {
      imageFile = File(picture.path);
      List<int> imagebytes = await imageFile.readAsBytesSync();
      image64 = base64Encode(imagebytes);
      this.setState(() {
        imageFile = Image.file(File(picture.path), height: 500, width: 500);
      });
    }

    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context, _jenis) async {
    var picture = await picker.getImage(
        source: ImageSource.camera, maxHeight: 500, maxWidth: 500);

    if (picture != null) {
      imageFile = File(picture.path);
      List<int> imagebytes = await imageFile.readAsBytesSync();
      image64 = base64Encode(imagebytes);
      this.setState(() {
        imageFile = Image.file(File(picture.path), height: 500, width: 500);
      });
    }

    Navigator.of(context).pop();
  }
}
