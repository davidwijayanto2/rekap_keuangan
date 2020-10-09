import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:rekap_keuangan/blocs/tambahtransaksi_bloc.dart';
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

class TambahTransaksiScreen extends StatelessWidget {
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
            create: (BuildContext context) => TambahTransaksiBloc(),
            child: TambahTransaksiScreenBody()));
  }
}

class TambahTransaksiScreenBody extends StatefulWidget {
  TambahTransaksiScreenBody({Key key}) : super(key: key);
  @override
  _TambahTransaksiScreenState createState() => _TambahTransaksiScreenState();
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

class _TambahTransaksiScreenState extends State<TambahTransaksiScreenBody>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Pengeluaran'),
    Tab(text: 'Pemasukan'),
    Tab(text: 'Transfer')
  ];
  FaIcon iconasaltransfer, icontujuantransfer;
  Color colorasaltransfer, colortujuantransfer;
  final txtkategorikeluar = TextEditingController();
  final txtdompetkeluar = TextEditingController();
  final txtjumlahkeluar = MoneyMaskedTextController(
      thousandSeparator: '.', precision: 0, decimalSeparator: '');
  final txtcatatankeluar = TextEditingController();
  final txttanggalkeluar = TextEditingController();
  final txtkategorimasuk = TextEditingController();
  final txtdompetmasuk = TextEditingController();
  final txtjumlahmasuk = MoneyMaskedTextController(
      thousandSeparator: '.', precision: 0, decimalSeparator: '');
  final txtcatatanmasuk = TextEditingController();
  final txttanggalmasuk = TextEditingController();
  final txtdompetasaltransfer = TextEditingController();
  final txtcatatanasaltransfer = TextEditingController();
  final txtdompettujuantransfer = TextEditingController();
  final txtcatatantujuantransfer = TextEditingController();
  final txtjumlahtransfer = MoneyMaskedTextController(
      thousandSeparator: '.', precision: 0, decimalSeparator: '');
  final txttanggaltransfer = TextEditingController();
  final FocusNode txtkategorikeluarfocus = FocusNode();
  final FocusNode txtdompetkeluarfocus = FocusNode();
  final FocusNode txtjumlahkeluarfocus = FocusNode();
  final FocusNode txtcatatankeluarfocus = FocusNode();
  final FocusNode txttanggalkeluarfocus = FocusNode();
  final FocusNode txtkategorimasukfocus = FocusNode();
  final FocusNode txtdompetmasukfocus = FocusNode();
  final FocusNode txtjumlahmasukfocus = FocusNode();
  final FocusNode txtcatatanmasukfocus = FocusNode();
  final FocusNode txttanggalmasukfocus = FocusNode();
  final FocusNode txtdompetasaltransferfocus = FocusNode();
  final FocusNode txtdompettujuantransferfocus = FocusNode();
  final FocusNode txtjumlahtransferfocus = FocusNode();
  final FocusNode txtcatatanasaltransferfocus = FocusNode();
  final FocusNode txtcatatantujuantransferfocus = FocusNode();
  final FocusNode txttanggaltransferfocus = FocusNode();
  final formkeykeluar = GlobalKey<FormState>();
  final formkeymasuk = GlobalKey<FormState>();
  final formkeytransfer = GlobalKey<FormState>();
  SharedPreferences prefs;
  bool firstinit = true, adsShown = false;
  final _nativeAdController = NativeAdmobController();
  double _height = 0;
  StreamSubscription _subscription;
  AppBar appbar;
  TabController _tabController;
  var imageFilemasuk, imageFilekeluar;
  var kddompetasaltransfer, kddompettujuantransfer;
  var image64keluar, image64masuk;
  final pickerkeluar = ImagePicker();
  final pickermasuk = ImagePicker();
  Iconcolor mIconcolorkeluar = new Iconcolor();
  Iconcolor mIconcolormasuk = new Iconcolor();
  _handletabchange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_handletabchange);
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
        txtdompetkeluar.text = 'Pilih Dompet';
        txtkategorikeluar.text = 'Pilih Kategori';
        txtjumlahkeluar.text = '0';
        txttanggalkeluar.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
        txtdompetmasuk.text = 'Pilih Dompet';
        txtkategorimasuk.text = 'Pilih Kategori';
        txtjumlahmasuk.text = '0';
        txttanggalmasuk.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
        txtdompetasaltransfer.text = 'Pilih Dompet Asal';
        txtdompettujuantransfer.text = 'Pilih Dompet Tujuan';
        txtjumlahtransfer.text = '0';
        txttanggaltransfer.text =
            DateFormat('dd-MM-yyyy').format(DateTime.now());
        setState(() {
          print('jangan');
          mIconcolorkeluar.colordompet = MyColors.graylight;
          mIconcolorkeluar.colorkategori = MyColors.graylight;
          mIconcolorkeluar.icondompet = FaIcon(FontAwesomeIcons.question,
              color: MyColors.gray, size: MyScreens.safeVertical * 2.5);
          mIconcolorkeluar.iconkategori = FaIcon(FontAwesomeIcons.question,
              color: MyColors.gray, size: MyScreens.safeVertical * 2.5);
          mIconcolormasuk.colordompet = MyColors.graylight;
          mIconcolormasuk.colorkategori = MyColors.graylight;
          mIconcolormasuk.icondompet = FaIcon(FontAwesomeIcons.question,
              color: MyColors.gray, size: MyScreens.safeVertical * 2.5);
          mIconcolormasuk.iconkategori = FaIcon(FontAwesomeIcons.question,
              color: MyColors.gray, size: MyScreens.safeVertical * 2.5);
          colorasaltransfer = MyColors.graylight;
          colortujuantransfer = MyColors.graylight;
          iconasaltransfer = FaIcon(FontAwesomeIcons.question,
              color: MyColors.gray, size: MyScreens.safeVertical * 2.5);
          icontujuantransfer = FaIcon(FontAwesomeIcons.question,
              color: MyColors.gray, size: MyScreens.safeVertical * 2.5);
        });
        firstinit = false;
      }
    });

    return BlocListener<TambahTransaksiBloc, TambahTransaksiState>(
        cubit: BlocProvider.of<TambahTransaksiBloc>(context),
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
                Fluttertoast.showToast(msg: "Transaksi berhasil ditambahkan");
                Navigator.pop(context, true);
              });
            });
          }
        },
        child: BlocBuilder<TambahTransaksiBloc, TambahTransaksiState>(
            cubit: BlocProvider.of<TambahTransaksiBloc>(context),
            builder: (context, state) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: Text('Tambah Transaksi'),
                    backgroundColor: MyColors.blue,
                    automaticallyImplyLeading: true,
                    leading: IconButton(
                      icon: Icon(FontAwesomeIcons.arrowLeft),
                      onPressed: () => Navigator.pop(context),
                    ),
                    bottom: TabBar(
                        labelStyle: TextStyle(fontSize: 16),
                        indicatorColor: Colors.white,
                        controller: _tabController,
                        tabs: myTabs),
                  ),
                  body: SafeArea(
                      child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      transaksiKeluarmasuk(
                          state,
                          formkeykeluar,
                          'k',
                          txtdompetkeluar,
                          txtkategorikeluar,
                          txtjumlahkeluar,
                          txtcatatankeluar,
                          txttanggalkeluar,
                          txtdompetkeluarfocus,
                          txtkategorikeluarfocus,
                          txtjumlahkeluarfocus,
                          txtcatatankeluarfocus,
                          txttanggalkeluarfocus,
                          mIconcolorkeluar),
                      transaksiKeluarmasuk(
                          state,
                          formkeymasuk,
                          'm',
                          txtdompetmasuk,
                          txtkategorimasuk,
                          txtjumlahmasuk,
                          txtcatatanmasuk,
                          txttanggalmasuk,
                          txtdompetmasukfocus,
                          txtkategorimasukfocus,
                          txtjumlahmasukfocus,
                          txtcatatanmasukfocus,
                          txttanggalmasukfocus,
                          mIconcolormasuk),
                      transaksitransfer(state, formkeytransfer)
                      //transaksiKeluarmasuk(state,_formkeytransfer)
                    ],
                  )));
            }));
  }

  Widget transaksiKeluarmasuk(
      state,
      formkey,
      _jenis,
      txtdompet,
      txtkategori,
      txtjumlah,
      txtcatatan,
      txttanggal,
      txtdompetfocus,
      txtkategorifocus,
      txtjumlahfocus,
      txtcatatanfocus,
      txttanggalfocus,
      mIconcolor) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                height: _height,
                padding: EdgeInsets.all(MyScreens.safeVertical * 1),
                margin: EdgeInsets.only(bottom: MyScreens.safeVertical * 1),
                child: NativeAdmob(
                  adUnitID: MyConst.nativeAdsUnitID,
                  controller: _nativeAdController,
                  type: NativeAdmobType.banner,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(
                      top: MyScreens.safeVertical * 12 - _height,
                      bottom: MyScreens.safeVertical * 1),
                  padding: EdgeInsets.only(top: MyScreens.safeVertical * 2),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Form(
                          key: formkey,
                          child: Column(children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(
                                  right: MyScreens.safeHorizontal * 5,
                                  left: MyScreens.safeHorizontal * 5,
                                  bottom: MyScreens.safeVertical * 5,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Material(
                                        color: Colors.white,
                                        child: InkWell(
                                            child: Row(children: <Widget>[
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      right: MyScreens
                                                              .safeHorizontal *
                                                          2),
                                                  width:
                                                      MyScreens.safeVertical *
                                                          5,
                                                  height:
                                                      MyScreens.safeVertical *
                                                          5,
                                                  decoration: new BoxDecoration(
                                                      color: mIconcolor
                                                          .colordompet,
                                                      shape: BoxShape.circle),
                                                  child: new Center(
                                                      child: mIconcolor
                                                          .icondompet)),
                                              SizedBox(
                                                width:
                                                    MyScreens.safeHorizontal *
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
                                                    decoration: InputDecoration(
                                                        errorStyle: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .errorColor)),
                                                    enabled: false),
                                              )
                                            ]),
                                            onTap: () {
                                              FocusScopeNode currentFocus =
                                                  FocusScope.of(context);
                                              if (!currentFocus
                                                  .hasPrimaryFocus) {
                                                currentFocus.unfocus();
                                              }
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return ListDompetScreen();
                                                }),
                                              ).then((val) {
                                                print(val['color']);
                                                setState(() {
                                                  txtdompet.text =
                                                      val['namadompet'];
                                                  mIconcolor.kddompet =
                                                      val['kddompet'];
                                                  mIconcolor.colordompet =
                                                      val['color'];
                                                  mIconcolor.icondompet =
                                                      val['icon'];
                                                });
                                              });
                                            })),
                                    SizedBox(
                                      height: MyScreens.safeVertical * 2,
                                    ),
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
                                                width:
                                                    MyScreens.safeVertical * 5,
                                                height:
                                                    MyScreens.safeVertical * 5,
                                                decoration: new BoxDecoration(
                                                    color: mIconcolor
                                                        .colorkategori,
                                                    shape: BoxShape.circle),
                                                child: new Center(
                                                    child: mIconcolor
                                                        .iconkategori)),
                                            SizedBox(
                                              width:
                                                  MyScreens.safeHorizontal * 2,
                                            ),
                                            Flexible(
                                              child: TextFormField(
                                                controller: txtkategori,
                                                focusNode: txtkategorifocus,
                                                decoration: InputDecoration(
                                                    errorStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .errorColor)),
                                                validator: (value) {
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
                                          FocusScopeNode currentFocus =
                                              FocusScope.of(context);
                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return ListKategoriScreen(
                                                  jenis: _jenis);
                                            }),
                                          ).then((val) {
                                            setState(() {
                                              txtkategori.text =
                                                  val['namakategori'];
                                              mIconcolor.kdkategori =
                                                  val['kdkategori'];
                                              mIconcolor.iconkategori =
                                                  val['icon'];
                                              mIconcolor.colorkategori =
                                                  val['color'];
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: MyScreens.safeVertical * 2,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(
                                                right:
                                                    MyScreens.safeHorizontal *
                                                        2),
                                            width: MyScreens.safeVertical * 5,
                                            height: MyScreens.safeVertical * 5,
                                            decoration: new BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: new Center(
                                              child: FaIcon(
                                                  FontAwesomeIcons.moneyBill,
                                                  size: MyScreens.safeVertical *
                                                      2.5),
                                            )),
                                        SizedBox(
                                          width: MyScreens.safeHorizontal * 2,
                                        ),
                                        Flexible(
                                          child: Focus(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              controller: txtjumlah,
                                              focusNode: txtjumlahfocus,
                                              decoration: InputDecoration(
                                                labelText: 'Jumlah',
                                              ),
                                              validator: (value) {
                                                if (int.parse(
                                                        MyConst.removeseparator(
                                                            value.trim())) ==
                                                    0) {
                                                  return 'Jumlah transaksi harus diisi';
                                                }
                                                return null;
                                              },
                                            ),
                                            onFocusChange: (hasfocus) {
                                              if (!hasfocus) {
                                                setState(() {
                                                  if (txtjumlah.text
                                                      .trim()
                                                      .isEmpty) {
                                                    txtjumlah.text = '0';
                                                  }
                                                });
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: MyScreens.safeVertical * 2,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(
                                                right:
                                                    MyScreens.safeHorizontal *
                                                        2),
                                            width: MyScreens.safeVertical * 5,
                                            height: MyScreens.safeVertical * 5,
                                            decoration: new BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: new Center(
                                              child: FaIcon(
                                                  FontAwesomeIcons.alignJustify,
                                                  size: MyScreens.safeVertical *
                                                      2.5),
                                            )),
                                        SizedBox(
                                          width: MyScreens.safeHorizontal * 2,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller: txtcatatan,
                                            focusNode: txtcatatanfocus,
                                            maxLength: 70,
                                            decoration: InputDecoration(
                                                labelText:
                                                    'Catatan (optional)'),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: MyScreens.safeVertical * 2,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(
                                                right:
                                                    MyScreens.safeHorizontal *
                                                        2),
                                            width: MyScreens.safeVertical * 5,
                                            height: MyScreens.safeVertical * 5,
                                            decoration: new BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: new Center(
                                              child: FaIcon(
                                                  FontAwesomeIcons.calendarDay,
                                                  size: MyScreens.safeVertical *
                                                      2.5),
                                            )),
                                        SizedBox(
                                          width: MyScreens.safeHorizontal * 2,
                                        ),
                                        Flexible(
                                          child: Material(
                                              color: Colors.white,
                                              child: InkWell(
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.text,
                                                  controller: txttanggal,
                                                  focusNode: txttanggalfocus,
                                                  decoration: InputDecoration(
                                                      errorStyle: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .errorColor)),
                                                  validator: (value) {
                                                    if (value == 'Tanggal') {
                                                      return 'Tanggal transaksi harus diisi';
                                                    }

                                                    return null;
                                                  },
                                                  enabled: false,
                                                ),
                                                onTap: () {
                                                  FocusScopeNode currentFocus =
                                                      FocusScope.of(context);
                                                  if (!currentFocus
                                                      .hasPrimaryFocus) {
                                                    currentFocus.unfocus();
                                                  }
                                                  _selectDate(txttanggal);
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
                margin: EdgeInsets.only(left: MyScreens.safeHorizontal * 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bukti Foto (Optional)',
                  style: TextStyle(color: MyColors.gray),
                ),
              ),
              GestureDetector(
                  child: _setImageView(_jenis),
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    _showSelectionDialog(context, _jenis);
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
                      BlocProvider.of<TambahTransaksiBloc>(context).add(
                          SettransaksiEvent(
                              kddompet: mIconcolor.kddompet,
                              kdkategori: mIconcolor.kdkategori,
                              keluar: (_jenis == 'k')
                                  ? MyConst.removeseparator(txtjumlah.text)
                                  : 0,
                              masuk: (_jenis == 'm')
                                  ? MyConst.removeseparator(txtjumlah.text)
                                  : 0,
                              catatan: txtcatatan.text.trim(),
                              foto: (_jenis == 'k')
                                  ? image64keluar
                                  : image64masuk,
                              tanggaltransaksi:
                                  MyConst.datetoStoreFormat(txttanggal.text)));
                    }
                  }
                },
              )),
        ),
      ],
    );
  }

  Widget transaksitransfer(state, formkey) {
    return Form(
        key: formkey,
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
                    padding: EdgeInsets.all(MyScreens.safeVertical * 1),
                    margin: EdgeInsets.only(bottom: MyScreens.safeVertical * 1),
                    child: NativeAdmob(
                      adUnitID: MyConst.nativeAdsUnitID,
                      controller: _nativeAdController,
                      type: NativeAdmobType.banner,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          top: MyScreens.safeVertical * 12 - _height,
                          bottom: MyScreens.safeVertical * 1),
                      padding:
                          EdgeInsets.only(left: MyScreens.safeHorizontal * 5),
                      child: Text(
                        'Dompet Asal',
                        style: TextStyle(
                            fontSize: 16,
                            color: MyColors.gray,
                            fontWeight: FontWeight.bold),
                      )),
                  Container(
                      margin: EdgeInsets.only(
                          top: MyScreens.safeVertical * 1,
                          bottom: MyScreens.safeVertical * 1),
                      padding: EdgeInsets.only(top: MyScreens.safeVertical * 2),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Column(children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                right: MyScreens.safeHorizontal * 5,
                                left: MyScreens.safeHorizontal * 5,
                                bottom: MyScreens.safeVertical * 3,
                              ),
                              child: Column(children: <Widget>[
                                Material(
                                    color: Colors.white,
                                    child: InkWell(
                                        child: Row(children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.only(
                                                  right:
                                                      MyScreens.safeHorizontal *
                                                          2),
                                              width:
                                                  MyScreens.safeVertical * 5.5,
                                              height:
                                                  MyScreens.safeVertical * 5.5,
                                              decoration: new BoxDecoration(
                                                  color: colorasaltransfer,
                                                  shape: BoxShape.circle),
                                              child: new Center(
                                                  child: iconasaltransfer)),
                                          SizedBox(
                                            width: MyScreens.safeHorizontal * 2,
                                          ),
                                          Flexible(
                                            child: TextFormField(
                                                controller:
                                                    txtdompetasaltransfer,
                                                focusNode:
                                                    txtdompetasaltransferfocus,
                                                validator: (value) {
                                                  if (value ==
                                                      'Pilih Dompet Asal') {
                                                    return 'Dompet harus diisi';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                    errorStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .errorColor)),
                                                enabled: false),
                                          )
                                        ]),
                                        onTap: () {
                                          FocusScopeNode currentFocus =
                                              FocusScope.of(context);
                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return ListDompetScreen(
                                                kddompetpicked:
                                                    kddompettujuantransfer,
                                              );
                                            }),
                                          ).then((val) {
                                            print(val['color']);
                                            setState(() {
                                              if (txtcatatantujuantransfer
                                                      .text ==
                                                  "") {
                                                txtcatatantujuantransfer.text =
                                                    'Terima Transfer dari ' +
                                                        val['namadompet'];
                                              }
                                              txtdompetasaltransfer.text =
                                                  val['namadompet'];
                                              kddompetasaltransfer =
                                                  val['kddompet'];
                                              colorasaltransfer = val['color'];
                                              iconasaltransfer = val['icon'];
                                            });
                                          });
                                        })),
                                Row(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(
                                            right:
                                                MyScreens.safeHorizontal * 2),
                                        width: MyScreens.safeVertical * 5.5,
                                        height: MyScreens.safeVertical * 5.5,
                                        decoration: new BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: new Center(
                                          child: FaIcon(
                                              FontAwesomeIcons.alignJustify,
                                              size:
                                                  MyScreens.safeVertical * 2.5),
                                        )),
                                    SizedBox(
                                      width: MyScreens.safeHorizontal * 2,
                                    ),
                                    Flexible(
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: txtcatatanasaltransfer,
                                        focusNode: txtcatatanasaltransferfocus,
                                        maxLength: 70,
                                        decoration: InputDecoration(
                                            labelText: 'Catatan (optional)'),
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                            )
                          ])
                        ],
                      )),
                  Container(
                      padding:
                          EdgeInsets.only(left: MyScreens.safeHorizontal * 5),
                      child: Text(
                        'Dompet Tujuan',
                        style: TextStyle(
                            fontSize: 16,
                            color: MyColors.gray,
                            fontWeight: FontWeight.bold),
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                        margin: EdgeInsets.only(
                            top: MyScreens.safeVertical * 1,
                            bottom: MyScreens.safeVertical * 5),
                        padding:
                            EdgeInsets.only(top: MyScreens.safeVertical * 2),
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Column(children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(
                                    right: MyScreens.safeHorizontal * 5,
                                    left: MyScreens.safeHorizontal * 5,
                                    bottom: MyScreens.safeVertical * 3,
                                  ),
                                  child: Column(children: <Widget>[
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
                                                width:
                                                    MyScreens.safeVertical * 5,
                                                height:
                                                    MyScreens.safeVertical * 5,
                                                decoration: new BoxDecoration(
                                                    color: colortujuantransfer,
                                                    shape: BoxShape.circle),
                                                child: new Center(
                                                    child: icontujuantransfer)),
                                            SizedBox(
                                              width:
                                                  MyScreens.safeHorizontal * 2,
                                            ),
                                            Flexible(
                                              child: TextFormField(
                                                controller:
                                                    txtdompettujuantransfer,
                                                focusNode:
                                                    txtdompettujuantransferfocus,
                                                decoration: InputDecoration(
                                                    errorStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .errorColor)),
                                                validator: (value) {
                                                  if (value ==
                                                      'Pilih Dompet Tujuan') {
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
                                          FocusScopeNode currentFocus =
                                              FocusScope.of(context);
                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return ListDompetScreen(
                                                kddompetpicked:
                                                    kddompetasaltransfer,
                                              );
                                            }),
                                          ).then((val) {
                                            setState(() {
                                              if (txtcatatanasaltransfer.text ==
                                                  "") {
                                                txtcatatanasaltransfer.text =
                                                    'Kirim Transfer ke ' +
                                                        val['namadompet'];
                                              }
                                              txtdompettujuantransfer.text =
                                                  val['namadompet'];
                                              kddompettujuantransfer =
                                                  val['kddompet'];
                                              icontujuantransfer = val['icon'];
                                              colortujuantransfer =
                                                  val['color'];
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: MyScreens.safeVertical * 2,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(
                                                right:
                                                    MyScreens.safeHorizontal *
                                                        2),
                                            width: MyScreens.safeVertical * 5,
                                            height: MyScreens.safeVertical * 5,
                                            decoration: new BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: new Center(
                                              child: FaIcon(
                                                  FontAwesomeIcons.alignJustify,
                                                  size: MyScreens.safeVertical *
                                                      2.5),
                                            )),
                                        SizedBox(
                                          width: MyScreens.safeHorizontal * 2,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller:
                                                txtcatatantujuantransfer,
                                            focusNode:
                                                txtcatatantujuantransferfocus,
                                            maxLength: 70,
                                            decoration: InputDecoration(
                                                labelText:
                                                    'Catatan (optional)'),
                                            onFieldSubmitted: (value) {
                                              MyConst.fieldFocusChange(
                                                  context,
                                                  txtcatatantujuantransferfocus,
                                                  txtjumlahtransferfocus);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: MyScreens.safeVertical * 2,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(
                                                right:
                                                    MyScreens.safeHorizontal *
                                                        2),
                                            width: MyScreens.safeVertical * 5,
                                            height: MyScreens.safeVertical * 5,
                                            decoration: new BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: new Center(
                                              child: FaIcon(
                                                  FontAwesomeIcons.moneyBill,
                                                  size: MyScreens.safeVertical *
                                                      2.5),
                                            )),
                                        SizedBox(
                                          width: MyScreens.safeHorizontal * 2,
                                        ),
                                        Flexible(
                                          child: Focus(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              controller: txtjumlahtransfer,
                                              focusNode: txtjumlahtransferfocus,
                                              decoration: InputDecoration(
                                                labelText: 'Jumlah',
                                              ),
                                              validator: (value) {
                                                if (int.parse(
                                                        MyConst.removeseparator(
                                                            value.trim())) ==
                                                    0) {
                                                  return 'Jumlah transaksi harus diisi';
                                                }
                                                return null;
                                              },
                                              onFieldSubmitted: (value) {
                                                setState(() {
                                                  if (txtjumlahtransfer.text
                                                      .trim()
                                                      .isEmpty) {
                                                    txtjumlahtransfer.text =
                                                        '0';
                                                  }
                                                });
                                              },
                                            ),
                                            onFocusChange: (hasfocus) {
                                              if (!hasfocus) {
                                                setState(() {
                                                  if (txtjumlahtransfer.text
                                                      .trim()
                                                      .isEmpty) {
                                                    txtjumlahtransfer.text =
                                                        '0';
                                                  }
                                                });
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: MyScreens.safeVertical * 2,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(
                                                right:
                                                    MyScreens.safeHorizontal *
                                                        2),
                                            width: MyScreens.safeVertical * 5,
                                            height: MyScreens.safeVertical * 5,
                                            decoration: new BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: new Center(
                                              child: FaIcon(
                                                  FontAwesomeIcons.calendarDay,
                                                  size: MyScreens.safeVertical *
                                                      2.5),
                                            )),
                                        SizedBox(
                                          width: MyScreens.safeHorizontal * 2,
                                        ),
                                        Flexible(
                                          child: Material(
                                              color: Colors.white,
                                              child: InkWell(
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.text,
                                                  controller:
                                                      txttanggaltransfer,
                                                  focusNode:
                                                      txttanggaltransferfocus,
                                                  decoration: InputDecoration(
                                                      errorStyle: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .errorColor)),
                                                  validator: (value) {
                                                    if (value == 'Tanggal') {
                                                      return 'Tanggal transaksi harus diisi';
                                                    }

                                                    return null;
                                                  },
                                                  enabled: false,
                                                ),
                                                onTap: () {
                                                  FocusScopeNode currentFocus =
                                                      FocusScope.of(context);
                                                  if (!currentFocus
                                                      .hasPrimaryFocus) {
                                                    currentFocus.unfocus();
                                                  }
                                                  _selectDate(
                                                      txttanggaltransfer);
                                                },
                                              )),
                                        )
                                      ],
                                    )
                                  ]))
                            ])
                          ],
                        )),
                  )
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
                          BlocProvider.of<TambahTransaksiBloc>(context).add(
                              SettransaksitransferEvent(
                                  kddompetasal: kddompetasaltransfer,
                                  kddompettujuan: kddompettujuantransfer,
                                  transfer: MyConst.removeseparator(
                                      txtjumlahtransfer.text),
                                  catatanasal:
                                      txtcatatanasaltransfer.text.trim(),
                                  catatantujuan:
                                      txtcatatantujuantransfer.text.trim(),
                                  tanggaltransaksi: MyConst.datetoStoreFormat(
                                      txttanggaltransfer.text)));
                        }
                      }
                    },
                  )),
            ),
          ],
        ));
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
    if (_jenis == 'k') {
      if (imageFilekeluar != null) {
        return Container(
            height: MyScreens.safeVertical * 35,
            width: MyScreens.safeHorizontal * 70,
            margin: EdgeInsets.only(
                top: MyScreens.safeVertical * 2,
                bottom: MyScreens.safeVertical * 2,
                left: MyScreens.safeHorizontal * 5,
                right: MyScreens.safeHorizontal * 5),
            child: Center(
                child: Image.file(imageFilekeluar, width: 500, height: 500)));
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
    } else {
      if (imageFilemasuk != null) {
        return Container(
            height: MyScreens.safeVertical * 35,
            width: MyScreens.safeHorizontal * 70,
            margin: EdgeInsets.only(
                top: MyScreens.safeVertical * 2,
                bottom: MyScreens.safeVertical * 2,
                left: MyScreens.safeHorizontal * 5,
                right: MyScreens.safeHorizontal * 5),
            child: Center(
                child: Image.file(imageFilemasuk, width: 500, height: 500)));
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
    if (_jenis == 'k') {
      var picture = await pickerkeluar.getImage(
          source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
      if (picture != null) {
        this.setState(() {
          imageFilekeluar = File(picture.path);
        });
        List<int> imagebytes = await imageFilekeluar.readAsBytesSync();
        image64keluar = base64Encode(imagebytes);
      }
    } else {
      var picture = await pickermasuk.getImage(
          source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
      if (picture != null) {
        this.setState(() {
          imageFilemasuk = File(picture.path);
        });
        List<int> imagebytes = await imageFilemasuk.readAsBytesSync();
        image64masuk = base64Encode(imagebytes);
        //print('64 masuk'+image64masuk);
      }
    }

    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context, _jenis) async {
    if (_jenis == 'k') {
      var picture = await pickerkeluar.getImage(
          source: ImageSource.camera, maxHeight: 500, maxWidth: 500);

      if (picture != null) {
        this.setState(() {
          imageFilekeluar = File(picture.path);
        });
        List<int> imagebytes = await imageFilekeluar.readAsBytesSync();
        image64keluar = base64Encode(imagebytes);
      }

      //print('64 keluar'+image64keluar);
    } else {
      var picture = await pickermasuk.getImage(
          source: ImageSource.camera, maxHeight: 500, maxWidth: 500);
      if (picture != null) {
        this.setState(() {
          imageFilemasuk = File(picture.path);
        });
        List<int> imagebytes = await imageFilemasuk.readAsBytesSync();
        image64masuk = base64Encode(imagebytes);
        //print('64 masuk'+image64masuk);
      }
    }

    Navigator.of(context).pop();
  }
}
