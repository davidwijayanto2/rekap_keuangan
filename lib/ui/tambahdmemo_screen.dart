import 'package:rekap_keuangan/blocs/memo_bloc.dart';
import 'package:rekap_keuangan/blocs/tambahdmemo_bloc.dart';
import 'package:rekap_keuangan/ui/catattransaksi_screen.dart';
import 'package:rekap_keuangan/ui/tambahmemo_screen.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

class TambahDMemoScreen extends StatelessWidget {
  final kdmemo;
  final judul;
  TambahDMemoScreen({Key key, @required this.kdmemo, @required this.judul})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.bluesharp, //or set color with: Color(0xFF0000FF)
    ));
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: BlocProvider(
            create: (BuildContext context) => TambahDetailMemoBloc(),
            child:
                TambahDMemoScreenBody(kdmemo: this.kdmemo, judul: this.judul)));
  }
}

class TambahDMemoScreenBody extends StatefulWidget {
  final kdmemo;
  final judul;
  @override
  _TambahDMemoScreenState createState() => _TambahDMemoScreenState();
  TambahDMemoScreenBody({this.kdmemo, this.judul});
}

class MyPopupItem {
  String title;
  IconData icon;
  MyPopupItem({this.title, this.icon});
}

class _TambahDMemoScreenState extends State<TambahDMemoScreenBody> {
  List<Widget> listcheckedwidget = <Widget>[];
  List<Widget> listuncheckedwidget = <Widget>[];
  List<Map<String, dynamic>> dmemolist;
  TambahDetailMemoBloc _dmemoBloc;
  var first = true, lEdit = false, fbvisible = true, lEditjudul = false;
  String judul;
  Widget judulwidget;
  List<Widget> checkedwidget;
  List<bool> arrbool = [];
  List<bool> tVisible = [];
  int total = 0, countchecked = 0;
  TextEditingController txtbarangedit = TextEditingController();
  TextEditingController txttotaledit = MoneyMaskedTextController(
      thousandSeparator: '.', precision: 0, decimalSeparator: '');
  var formkeyedit = GlobalKey<FormState>();
  static List<MyPopupItem> choices = <MyPopupItem>[
    MyPopupItem(title: 'Ubah Judul', icon: FontAwesomeIcons.edit),
    MyPopupItem(title: 'Hapus Memo', icon: FontAwesomeIcons.trash),
    MyPopupItem(title: 'Bagikan', icon: FontAwesomeIcons.share)
  ];
  MyPopupItem selected_item = choices[0];
  void _select(int index) async {
    if (index == 0) {
      print('index 0');
      TextEditingController txttitle = TextEditingController();
      void ubahjudul(BuildContext cont) {
        setState(() {
          judul = txttitle.text.trim();
          judulwidget = Text(txttitle.text.trim());
        });
        _dmemoBloc.add(UpdatejudulmemoEvent(
            kdmemo: widget.kdmemo, judul: txttitle.text.trim()));
        lEditjudul = false;
        Navigator.pop(cont);
      }

      if (!lEditjudul) {
        txttitle.text = judul;
        lEditjudul = true;
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text('Memo'),
                content: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: txttitle,
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Judul Memo'),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Batal'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                      child: Text('Simpan'),
                      onPressed: () => txttitle.text.trim().isNotEmpty
                          ? ubahjudul(context)
                          : null)
                ],
              );
            });
          });

      // Dialog(
      //   child: Container(
      //     height: MyScreens.safeVertical*25,
      //     padding: EdgeInsets.only(
      //       top:MyScreens.safeVertical*2,
      //       left: MyScreens.safeHorizontal*5,
      //       right: MyScreens.safeHorizontal*5
      //     ),
      //     child: Column(
      //       children: <Widget>[
      //         Text('Memo',
      //           style: TextStyle(
      //             fontSize: 18,
      //             color: Colors.black,
      //             fontWeight: FontWeight.bold
      //           ),
      //         ),
      //         TextFormField(
      //           controller: txttitle..text=widget.judul,
      //           autofocus: true,
      //           decoration: InputDecoration(
      //             labelText: 'Judul Memo'
      //           ),
      //         ),
      //         SizedBox(height: MyScreens.safeVertical*2,),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.end,
      //           children: <Widget>[
      //             FlatButton(
      //               color: Colors.white,
      //               textColor: MyColors.bluesharp,
      //               child: Text('Batal',
      //                 style: TextStyle(
      //                   fontSize: 16
      //                 ),
      //               ),
      //               onPressed: (){
      //                 Navigator.pop(context);
      //               },
      //             ),
      //             FlatButton(
      //               color: Colors.white,
      //               textColor: MyColors.bluesharp,
      //               child: Text('Simpan',
      //                 style: TextStyle(
      //                   fontSize: 16
      //                 ),
      //               ),
      //               onPressed: ()=>txttitle.text.trim().isEmpty?null:ubahjudul
      //             ),
      //           ],
      //         )

      //       ],
      //     )
      //   )
      // );
    } else if (index == 1) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Peringatan'),
              content: Text('Apakah anda yakin akan menghapus memo ini?'),
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
                    _dmemoBloc.add(DeletememoEvent(kdmemo: widget.kdmemo));
                  },
                )
              ],
            );
          });
    } else if (index == 2) {
      var textshare = 'Daftar memo ' + judul + '\n\nDaftar Barang\n';
      var checked = '';
      for (int i = 0; i < dmemolist.length; i++) {
        if (dmemolist[i]['status'] == 0) {
          textshare += dmemolist[i]['namadmemo'] + '\n';
        } else {
          checked += dmemolist[i]['namadmemo'] + '\n';
        }
      }
      if (checked.length > 0) {
        textshare += '\nBarang yang sudah selesai\n' + checked;
      }
      textshare += '\nDibagikan dari Rekap Keuangan-PandaCode';
      Share.share(textshare);
    }
  }

  //bool arrbool=false;
  @override
  void initState() {
    _dmemoBloc = BlocProvider.of<TambahDetailMemoBloc>(context);
    _dmemoBloc.add(GetdetailmemoEvent(kdmemo: widget.kdmemo));
    judul = widget.judul;
    judulwidget = Text(judul);
    super.initState();
  }

  showinputdialog() {
    var txtbarang = TextEditingController();
    var txtharga = MoneyMaskedTextController(
        thousandSeparator: '.', precision: 0, decimalSeparator: '');
    FocusNode _txtbarangfocus = FocusNode();
    FocusNode _txthargafocus = FocusNode();
    var _formkey = GlobalKey<FormState>();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: MyColors.light,
        builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Form(
                key: _formkey,
                child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Padding(
                        padding:
                            EdgeInsets.only(bottom: MyScreens.safeVertical * 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Flexible(
                              child: Focus(
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: txtbarang,
                                  focusNode: _txtbarangfocus,
                                  autofocus: true,
                                  decoration:
                                      InputDecoration(labelText: 'Nama Barang'),
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return 'Nama barang harus diisi';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (value) {
                                    if (txtharga.text.trim().isEmpty) {
                                      FocusScope.of(context)
                                          .requestFocus(_txthargafocus);
                                    } else {
                                      if (_formkey.currentState.validate()) {
                                        _dmemoBloc.add(SetdetailmemoEvent(
                                            kdmemo: widget.kdmemo,
                                            namadmemo: txtbarang.text.trim(),
                                            total: MyConst.removeseparator(
                                                txtharga.text.trim())));
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MyScreens.safeHorizontal * 5,
                            ),
                            Flexible(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                controller: txtharga,
                                focusNode: _txthargafocus,
                                decoration: InputDecoration(
                                    labelText: 'Estimasi Harga'),
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Harga harus diisi';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  if (_formkey.currentState.validate()) {
                                    if (txtbarang.text.trim().isEmpty) {
                                      FocusScope.of(context)
                                          .requestFocus(_txtbarangfocus);
                                    } else {
                                      _dmemoBloc.add(SetdetailmemoEvent(
                                          kdmemo: widget.kdmemo,
                                          namadmemo: txtbarang.text.trim(),
                                          total: MyConst.removeseparator(
                                              txtharga.text.trim())));
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                              ),
                            )
                          ],
                        ))))));
  }

  @override
  Widget build(BuildContext context) {
    MyWidgets().buildLoadingDialog(context);
    MyScreens().initScreen(context);
    Future<bool> _onBackPressed(i) {
      if (lEdit) {
        setState(() {
          tVisible[i] = true;
          lEdit = false;
        });
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    }

    Widget _buildDetailMemoWidget(dmemolist) {
      listuncheckedwidget = <Widget>[];
      listcheckedwidget = <Widget>[];
      bool ischecked = false;
      total = 0;
      countchecked = 0;
      for (int i = 0; i < dmemolist.length; i++) {
        //arrbool[i]=false;
        print(dmemolist[i]['status']);
        if (dmemolist[i]['status'] == 0) {
          arrbool[i] = false;
          listuncheckedwidget.add(Container(
              padding: EdgeInsets.only(
                  right: MyScreens.safeHorizontal * 5,
                  left: MyScreens.safeHorizontal * 3,
                  top: MyScreens.safeVertical * 1,
                  bottom: MyScreens.safeVertical * 1),
              color: Colors.white,
              child: Visibility(
                  visible: tVisible[i],
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!lEdit) {
                          tVisible[i] = false;
                          lEdit = true;
                          txtbarangedit.text = dmemolist[i]['namadmemo'];
                          txttotaledit.text = MyConst.thousandseparator(
                              dmemolist[i]['total'].round());
                        }
                      });
                      print(tVisible[i]);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: arrbool[i],
                                  onChanged: (bool value) {
                                    print('masuk check ' + i.toString());
                                    print(arrbool[i]);
                                    setState(() {
                                      var cbstatus;
                                      if (value) {
                                        cbstatus = 1;
                                      } else {
                                        cbstatus = 0;
                                      }
                                      _dmemoBloc.add(SetstatusdetailmemoEvent(
                                          kdmemo: widget.kdmemo,
                                          kddetailmemo: dmemolist[i]
                                                  ['kddetailmemo']
                                              .toString(),
                                          status: cbstatus));
                                    });
                                  },
                                ),
                                Text(
                                  dmemolist[i]['namadmemo'],
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            // Flexible(
                            //   child: CheckboxListTile(
                            //     title: Text(dmemolist[i]['namadmemo']),
                            //     value: false,
                            //     onChanged: (bool value) {
                            //     },
                            //     controlAffinity: ListTileControlAffinity.leading,
                            //   ),
                            // )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                                'Rp. ' +
                                    MyConst.thousandseparator(
                                        dmemolist[i]['total']),
                                style: TextStyle(fontSize: 16))
                          ],
                        )
                      ],
                    ),
                  ),
                  replacement: WillPopScope(
                      onWillPop: () => _onBackPressed(i),
                      child: Form(
                          key: formkeyedit,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: txtbarangedit,
                                    autofocus: true,
                                    validator: (value) {
                                      if (value.trim().isEmpty) {
                                        return 'Nama barang harus diisi';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (value) {
                                      if (formkeyedit.currentState.validate()) {
                                        lEdit = false;
                                        _dmemoBloc.add(UpdatedetailmemoEvent(
                                            kdmemo: widget.kdmemo,
                                            kddetailmemo: dmemolist[i]
                                                ['kddetailmemo'],
                                            namadmemo:
                                                txtbarangedit.text.trim(),
                                            total: MyConst.removeseparator(
                                                txttotaledit.text.trim())));
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: MyScreens.safeHorizontal * 2,
                                ),
                                Flexible(
                                    child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: txttotaledit,
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return 'Harga harus diisi';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (value) {
                                    if (formkeyedit.currentState.validate()) {
                                      lEdit = false;
                                      _dmemoBloc.add(UpdatedetailmemoEvent(
                                          kdmemo: widget.kdmemo,
                                          kddetailmemo: dmemolist[i]
                                              ['kddetailmemo'],
                                          namadmemo: txtbarangedit.text.trim(),
                                          total: MyConst.removeseparator(
                                              txttotaledit.text.trim())));
                                    }
                                  },
                                ))
                              ]))))));

          listuncheckedwidget.add(Divider(
            height: 1,
            color: MyColors.graylight,
            thickness: 1,
          ));
        } else {
          print('masuk false');
          arrbool[i] = true;
          if (!ischecked) {
            ischecked = true;
            listcheckedwidget.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(MyScreens.safeVertical * 2),
                  color: MyColors.light,
                  child: Text('Barang Selesai'),
                ),
                Container(
                    margin: EdgeInsets.all(MyScreens.safeVertical * 2),
                    height: MyScreens.safeVertical * 5,
                    child: ButtonTheme(
                        minWidth: MyScreens.safeHorizontal * 30,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return CatatTransaksiScreen(
                                    judul: judul, total: total);
                              }),
                            );
                          },
                          color: MyColors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: MyColors.bluelight, width: 2.0),
                          ),
                          child: Text(
                            'Catat Belanja',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        )))
              ],
            ));
          }
          total += dmemolist[i]['total'].round();
          countchecked++;
          listcheckedwidget.add(
            Container(
                padding: EdgeInsets.only(
                    right: MyScreens.safeHorizontal * 5,
                    left: MyScreens.safeHorizontal * 3,
                    top: MyScreens.safeVertical * 1,
                    bottom: MyScreens.safeVertical * 1),
                color: Colors.white,
                child: Visibility(
                    visible: tVisible[i],
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!lEdit) {
                            tVisible[i] = false;
                            lEdit = true;
                            txtbarangedit.text = dmemolist[i]['namadmemo'];
                            txttotaledit.text = MyConst.thousandseparator(
                                dmemolist[i]['total'].round());
                          }
                        });
                        print(tVisible[i]);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: arrbool[i],
                                    onChanged: (bool value) {
                                      print('masuk check ' + i.toString());
                                      print(arrbool[i]);
                                      setState(() {
                                        var cbstatus;
                                        if (value) {
                                          cbstatus = 1;
                                        } else {
                                          cbstatus = 0;
                                        }
                                        _dmemoBloc.add(SetstatusdetailmemoEvent(
                                            kdmemo: widget.kdmemo,
                                            kddetailmemo: dmemolist[i]
                                                    ['kddetailmemo']
                                                .toString(),
                                            status: cbstatus));
                                      });
                                    },
                                  ),
                                  Text(
                                    dmemolist[i]['namadmemo'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        decoration: TextDecoration.lineThrough),
                                  )
                                ],
                              )
                              // Flexible(
                              //   child: CheckboxListTile(
                              //     title: Text(dmemolist[i]['namadmemo']),
                              //     value: false,
                              //     onChanged: (bool value) {
                              //     },
                              //     controlAffinity: ListTileControlAffinity.leading,
                              //   ),
                              // )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                  'Rp. ' +
                                      MyConst.thousandseparator(
                                          dmemolist[i]['total']),
                                  style: TextStyle(fontSize: 16))
                            ],
                          )
                        ],
                      ),
                    ),
                    replacement: WillPopScope(
                        onWillPop: () => _onBackPressed(i),
                        child: Form(
                            key: formkeyedit,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: txtbarangedit,
                                      autofocus: true,
                                      validator: (value) {
                                        if (value.trim().isEmpty) {
                                          return 'Nama barang harus diisi';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (value) {
                                        if (formkeyedit.currentState
                                            .validate()) {
                                          lEdit = false;
                                          _dmemoBloc.add(UpdatedetailmemoEvent(
                                              kdmemo: widget.kdmemo,
                                              kddetailmemo: dmemolist[i]
                                                  ['kddetailmemo'],
                                              namadmemo:
                                                  txtbarangedit.text.trim(),
                                              total: MyConst.removeseparator(
                                                  txttotaledit.text.trim())));
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: MyScreens.safeHorizontal * 2,
                                  ),
                                  Flexible(
                                      child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: txttotaledit,
                                    validator: (value) {
                                      if (value.trim().isEmpty) {
                                        return 'Harga harus diisi';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (value) {
                                      if (formkeyedit.currentState.validate()) {
                                        lEdit = false;
                                        _dmemoBloc.add(UpdatedetailmemoEvent(
                                            kdmemo: widget.kdmemo,
                                            kddetailmemo: dmemolist[i]
                                                ['kddetailmemo'],
                                            namadmemo:
                                                txtbarangedit.text.trim(),
                                            total: MyConst.removeseparator(
                                                txttotaledit.text.trim())));
                                      }
                                    },
                                  ))
                                ]))))),
          );
          listcheckedwidget.add(Divider(
            height: 1,
            color: MyColors.graylight,
            thickness: 1,
          ));
        }
        //arrbool[i]=bol;
        checkedwidget = [];
        checkedwidget.add(
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: listuncheckedwidget,
            ),
          ),
        );
        if (countchecked > 0) {
          checkedwidget.add(Flexible(
            child: ListView(shrinkWrap: true, children: listcheckedwidget),
          ));
        }
        checkedwidget.add(Container(
          height: MyScreens.safeVertical * 12.5,
        ));
      }
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: judulwidget,
            backgroundColor: MyColors.blue,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () => Navigator.pop(context),
            ),
            actions: <Widget>[
              PopupMenuButton<int>(
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  return choices.map((MyPopupItem choice) {
                    return PopupMenuItem<int>(
                        value: choices.indexOf(choice),
                        child: Row(
                          children: <Widget>[
                            FaIcon(
                              choice.icon,
                              color: Colors.black,
                              size: 18,
                            ),
                            Text('  '),
                            Text(choice.title)
                          ],
                        ));
                  }).toList();
                },
              )
            ],
          ),
          body: SafeArea(
              child: Container(
                  color: MyColors.light,
                  child: Column(children: checkedwidget))),
          floatingActionButton: Visibility(
            visible: !lEdit,
            child: FloatingActionButton(
                backgroundColor: MyColors.blue,
                child: Icon(FontAwesomeIcons.plus),
                onPressed: () {
                  showinputdialog();
                }),
          ));
    }

    return BlocListener<TambahDetailMemoBloc, TambahDetailMemoState>(
        cubit: BlocProvider.of<TambahDetailMemoBloc>(context),
        listener: (context, state) async {
          if (state is TambahDetailMemoDeletedState) {
            MyWidgets.dialog.show();
            Future.delayed(Duration(seconds: 1)).then((value) {
              MyWidgets.dialog.hide().whenComplete(() {
                Fluttertoast.showToast(msg: "Memo berhasil dihapus");
                Navigator.pop(context, true);
              });
            });
          }
        },
        child: BlocBuilder(
            cubit: _dmemoBloc,
            builder: (context, state) {
              if (state is TambahDetailMemoLoadingState) {
                return MyWidgets.buildLoadingWidget(context);
              } else if (state is TambahDetailMemoLoadedState) {
                dmemolist = state.detailmemolist;
                arrbool = new List(dmemolist.length);
                if (!lEdit) {
                  tVisible = new List(dmemolist.length);
                  for (int i = 0; i < dmemolist.length; i++) {
                    tVisible[i] = true;
                  }
                  lEdit = false;
                }
                return _buildDetailMemoWidget(dmemolist);
              } else if (state is TambahDetailMemoLoadFailureState) {
                Fluttertoast.showToast(msg: "Gagal memuat. Silahkan coba lagi");
                return Scaffold(body: SafeArea(child: Container()));
              } else if (state is TambahDetailMemoEmptyState) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (first) {
                    first = false;
                    showinputdialog();
                  }
                });

                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: judulwidget,
                    backgroundColor: MyColors.blue,
                    automaticallyImplyLeading: true,
                    leading: IconButton(
                      icon: Icon(FontAwesomeIcons.arrowLeft),
                      onPressed: () => Navigator.pop(context),
                    ),
                    actions: <Widget>[
                      PopupMenuButton<int>(
                        onSelected: _select,
                        itemBuilder: (BuildContext context) {
                          return choices.map((MyPopupItem choice) {
                            return PopupMenuItem<int>(
                                value: choices.indexOf(choice),
                                child: Row(
                                  children: <Widget>[
                                    FaIcon(
                                      choice.icon,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                    Text('  '),
                                    Text(choice.title)
                                  ],
                                ));
                          }).toList();
                        },
                      )
                    ],
                  ),
                  body: SafeArea(
                      child: Column(children: <Widget>[
                    Container(
                      color: MyColors.light,
                    ),
                  ])),
                  floatingActionButton: Visibility(
                      visible: !lEdit,
                      child: FloatingActionButton(
                          backgroundColor: MyColors.blue,
                          child: Icon(FontAwesomeIcons.plus),
                          onPressed: () {
                            showinputdialog();
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: <Widget>[
                            //       Padding(
                            //         padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            //         child: Text('Enter your address'),
                            //       ),
                            //       SizedBox(
                            //         height: 8.0,
                            //       ),
                            //       Padding(
                            //         padding: EdgeInsets.only(
                            //             bottom: MediaQuery.of(context).viewInsets.bottom),
                            //         child: TextField(
                            //           decoration: InputDecoration(
                            //             hintText: 'adddrss'
                            //           ),
                            //           autofocus: true,
                            //         ),
                            //       ),

                            //       SizedBox(height: 10),
                            //     ],
                            //   ),
                            // )

                            // context: context,
                            // isScrollControlled: true,
                            // builder: (context) {
                            //   return ListView(
                            //     shrinkWrap: true,
                            //     children: <Widget>[
                            //       Form(
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //           children: <Widget>[
                            //             Flexible(
                            //               child: TextFormField(
                            //                 keyboardType: TextInputType.text,
                            //                 decoration: InputDecoration(
                            //                   labelText: 'Nama Barang'
                            //                 ),
                            //               ),
                            //             ),
                            //             Flexible(
                            //               child: TextFormField(
                            //                 keyboardType: TextInputType.text,
                            //                 decoration: InputDecoration(
                            //                   labelText: 'Nama Barang'
                            //                 ),
                            //               ),
                            //             )
                            //           ],
                            //         )
                            //       )
                            //     ],
                            //   );
                            // }
                          })),
                );
              } else {
                return Container();
              }
            }));
  }
}
