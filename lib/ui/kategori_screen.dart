import 'dart:async';

import 'package:rekap_keuangan/blocs/kategori_bloc.dart';
import 'package:rekap_keuangan/ui/tambahkategori_screen.dart';
import 'package:rekap_keuangan/ui/ubakategori_screen.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KategoriScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.bluesharp, //or set color with: Color(0xFF0000FF)
    ));
    return BlocProvider(
        create: (BuildContext context) => KategoriBloc(),
        child: KategoriScreenBody());
  }
}

class KategoriScreenBody extends StatefulWidget {
  KategoriScreenBody({Key key}) : super(key: key);
  @override
  _KategoriState createState() => new _KategoriState();
}

class _KategoriState extends State<KategoriScreenBody>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Pengeluaran'),
    Tab(text: 'Pemasukan')
  ];
  KategoriBloc _kategoriBloc;
  //final _nativeAdController = NativeAdmobController();
  //double _height = MyScreens.safeVertical * 12;
  //StreamSubscription _subscription;
  bool adShown = false;
  TabController _tabController;
  var _jenis = 'k';
  _handletabchange() {
    setState(() {
      if (_tabController.index == 0) {
        _jenis = 'k';
      } else if (_tabController.index == 1) {
        _jenis = 'm';
      }
    });
  }

  @override
  void initState() {
    _kategoriBloc = BlocProvider.of<KategoriBloc>(context);
    _kategoriBloc.add(GetkategorikeluarmasukEvent());

    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_handletabchange);
    //_subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    //FirebaseAdMob.instance.initialize(appId: NativeAd.testAdUnitId);
    //myAds = buildNativeAd()..load();
  }

  @override
  void dispose() {
    super.dispose();
    // if (adShown) {
    //   adShown = false;
    //   //myAds.dispose();
    // }
    //_subscription.cancel();
    //_nativeAdController.dispose();
  }

  // NativeAd buildNativeAd() {
  //   return NativeAd(
  //       //ca-app-pub-5073070501377591/9135492217 banner
  //       //ca-app-pub-5073070501377591/3944435784 native
  //       adUnitId: BannerAd.testAdUnitId,
  //       listener: (MobileAdEvent event) {
  //         if (event == MobileAdEvent.loaded) {
  //           adShown = true;
  //           myBanner..show();
  //         } else if (event == MobileAdEvent.failedToLoad) {
  //           adShown = false;
  //         }
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    MyScreens().initScreen(context);
    //listkategorimasuk =
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori Saya'),
        backgroundColor: MyColors.blue,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
            labelStyle: TextStyle(fontSize: 18),
            indicatorColor: Colors.white,
            controller: _tabController,
            tabs: myTabs),
      ),
      body: SafeArea(
          child: TabBarView(controller: _tabController, children: <Widget>[
        BlocBuilder(
            cubit: _kategoriBloc,
            builder: (context, state) {
              if (state is KategoriLoadingState) {
                return MyWidgets.buildLoadingWidget(context);
              } else if (state is KategoriKMLoadedState) {
                List<Map<String, dynamic>> kategorilist =
                    state.kategorilist['keluar'];
                if (kategorilist.length > 0) {
                  return getkategoriwidget(kategorilist);
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
            }),
        BlocBuilder(
            cubit: _kategoriBloc,
            builder: (context, state) {
              if (state is KategoriLoadingState) {
                return MyWidgets.buildLoadingWidget(context);
              } else if (state is KategoriKMLoadedState) {
                List<Map<String, dynamic>> kategorilist =
                    state.kategorilist['masuk'];
                if (kategorilist.length > 0) {
                  return getkategoriwidget(kategorilist);
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
            })
      ])),
      floatingActionButton: FloatingActionButton(
          backgroundColor: MyColors.blue,
          child: Icon(FontAwesomeIcons.plus),
          onPressed: () {
            // if (adShown) {
            //   adShown = false;
            //   myBanner.dispose();
            // }
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TambahKategoriScreen(mJenis: _jenis);
            })).then((val) =>
                val ? _kategoriBloc.add(GetkategorikeluarmasukEvent()) : null);
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
                // if (adShown) {
                //   adShown = false;
                //   myBanner.dispose();
                // }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return UbahKategoriScreen(
                        kdkategori: _kategorilist[i]['kdkategori']);
                  }),
                ).then((val) => val
                    ? _kategoriBloc.add(GetkategorikeluarmasukEvent())
                    : null);
              },
            ),
          ),
          Divider(
            color: MyColors.light,
            thickness: 1,
            height: 1,
          ),
        ],
      ));
    }
    // listkategoriwidget.add(Container(
    //   height: MyScreens.safeVertical * 10,
    // ));

    return ListView(
      shrinkWrap: true,
      children: listkategoriwidget,
    );
  }
}
