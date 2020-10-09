import 'dart:async';

import 'package:rekap_keuangan/blocs/kategori_bloc.dart';
import 'package:rekap_keuangan/ui/tambahkategori_screen.dart';
import 'package:rekap_keuangan/ui/ubakategori_screen.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListKategoriScreen extends StatelessWidget {
  final jenis;
  ListKategoriScreen({Key key, @required this.jenis}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.bluesharp, //or set color with: Color(0xFF0000FF)
    ));
    return BlocProvider(
        create: (BuildContext context) => KategoriBloc(),
        child: ListKategoriScreenBody(jenis: this.jenis));
  }
}

class ListKategoriScreenBody extends StatefulWidget {
  final jenis;
  @override
  _ListKategoriState createState() => new _ListKategoriState();
  ListKategoriScreenBody({this.jenis});
}

class _ListKategoriState extends State<ListKategoriScreenBody> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Pengeluaran'),
    Tab(text: 'Pemasukan')
  ];
  KategoriBloc _kategoriBloc;
  final _nativeAdController = NativeAdmobController();  
  StreamSubscription _subscription;
  bool adShown = false;
  Map<String, dynamic> mapback;
  String titlejenis = '';
  @override
  void initState() {
    _kategoriBloc = BlocProvider.of<KategoriBloc>(context);
    if (widget.jenis == 'k') {
      titlejenis = 'Pengeluaran';
      _kategoriBloc.add(GetkategorikeluarEvent());
    } else if (widget.jenis == 'm') {
      titlejenis = 'Pemasukan';
      _kategoriBloc.add(GetkategorimasukEvent());
    }

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
    MyScreens().initScreen(context);
    //listkategorimasuk =
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori ' + titlejenis),
        backgroundColor: MyColors.blue,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
          child: BlocBuilder(
              cubit: _kategoriBloc,
              builder: (context, state) {
                if (state is KategoriLoadingState) {
                  return MyWidgets.buildLoadingWidget(context);
                } else if (state is KategoriKMLoadedState) {
                  List<Map<String, dynamic>> kategorilist = state.listkategori;
                  return getkategoriwidget(kategorilist);
                } else if (state is KategoriLoadFailureState) {
                  return Column(children: <Widget>[
                    
                    Container(
                      height: MyScreens.safeVertical * 50,
                      child: Center(
                        child: Text('Gagal memuat'),
                      ),
                    )
                  ]);
                } else if (state is KategoriEmptyState) {
                  return Column(children: <Widget>[
                    
                    Container(
                      height: MyScreens.safeVertical * 50,
                      child: Center(
                        child: Text('Belum ada kategori'),
                      ),
                    )
                  ]);
                } else {
                  return Column(children: <Widget>[
                    
                    Container(
                      height: MyScreens.safeVertical * 50,
                      child: Center(
                        child: Text('Belum ada kategori'),
                      ),
                    )
                  ]);
                }
              })),
      floatingActionButton: FloatingActionButton(
          backgroundColor: MyColors.blue,
          child: Icon(FontAwesomeIcons.plus),
          onPressed: () {
            print(widget.jenis);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TambahKategoriScreen(mJenis: widget.jenis);
            })).then((val) {
              if (val) {
                if (widget.jenis == 'k') {
                  _kategoriBloc.add(GetkategorikeluarEvent());
                } else if (widget.jenis == 'm') {
                  _kategoriBloc.add(GetkategorimasukEvent());
                }
              }
            });
          }),
    );
  }

  Widget getkategoriwidget(_kategorilist) {
    List<Widget> listkategoriwidget = <Widget>[];
    listkategoriwidget = <Widget>[];
    
    for (int i = 0; i < _kategorilist.length; i++) {
      listkategoriwidget.add(Column(
        children: <Widget>[
          Material(
            color: Colors.white,
            child: InkWell(
              child: Container(
                  padding: EdgeInsets.only(
                      top: MyScreens.safeVertical * 1,
                      bottom: MyScreens.safeVertical * 1,
                      left: MyScreens.safeHorizontal * 5),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(
                              right: MyScreens.safeHorizontal * 2),
                          width: MyScreens.safeVertical * 7,
                          height: MyScreens.safeVertical * 7,
                          decoration: new BoxDecoration(
                              color: MyConst.fromHex(_kategorilist[i]['color']),
                              shape: BoxShape.circle),
                          child: new Center(
                            child: FaIcon(
                              IconData(_kategorilist[i]['codepoint'],
                                  fontFamily: _kategorilist[i]['fontfamily'],
                                  fontPackage: _kategorilist[i]['fontpackage']),
                              color: Colors.white,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(
                              right: MyScreens.safeHorizontal * 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _kategorilist[i]['namakategori'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
                    ],
                  )),
              onTap: () {
                mapback = {
                  'kdkategori': _kategorilist[i]['kdkategori'],
                  'icon': FaIcon(
                      IconData(_kategorilist[i]['codepoint'],
                          fontFamily: _kategorilist[i]['fontfamily'],
                          fontPackage: _kategorilist[i]['fontpackage']),
                      color: Colors.white,
                      size: MyScreens.safeVertical * 2.5),
                  'color': MyConst.fromHex(_kategorilist[i]['color']),
                  'namakategori': _kategorilist[i]['namakategori']
                };
                Navigator.pop(context, mapback);
              },
            ),
          ),
          Divider(
            color: MyColors.light,
            thickness: 1,
            height: 1,
          )
        ],
      ));
    }
    listkategoriwidget.add(Container(
      height: MyScreens.safeVertical * 10,
    ));
    return ListView(
      shrinkWrap: true,
      children: listkategoriwidget,
    );
  }
}
