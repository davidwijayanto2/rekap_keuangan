import 'package:rekap_keuangan/blocs/dompet_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';
import 'package:rekap_keuangan/ui/tambahdompet_screen.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListDompetScreen extends StatelessWidget {
  final kddompetpicked;
  final semua;
  ListDompetScreen({this.kddompetpicked, this.semua});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.bluesharp, //or set color with: Color(0xFF0000FF)
    ));
    return BlocProvider(
        create: (BuildContext context) => DompetBloc(),
        child: ListDompetScreenBody(
            kddompetpicked: this.kddompetpicked, semua: this.semua));
  }
}

class ListDompetScreenBody extends StatefulWidget {
  final kddompetpicked;
  final semua;
  @override
  _ListDompetState createState() => new _ListDompetState();
  ListDompetScreenBody({this.kddompetpicked, this.semua});
}

class _ListDompetState extends State<ListDompetScreenBody> {
  List<Widget> listdompetglobalwidget = <Widget>[];
  List<Widget> listdompetwidget = <Widget>[];
  DompetBloc _dompetBloc;
  // final _nativeAdController = NativeAdmobController();
  // StreamSubscription _subscription;
  bool adShown = false;
  Map<String, dynamic> mapback;
  var kddompetpicked, semua;
  @override
  void initState() {
    _dompetBloc = BlocProvider.of<DompetBloc>(context);
    if (widget.semua != null) {
      _dompetBloc.add(GetalldompetglobalEvent());
    } else {
      _dompetBloc.add(GetalldompetEvent());
    }

    super.initState();
    //_subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    kddompetpicked =
        (widget.kddompetpicked == null) ? -1 : widget.kddompetpicked;
  }

  @override
  void dispose() {
    super.dispose();
    //_subscription.cancel();
    //_nativeAdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyScreens().initScreen(context);
    return BlocBuilder(
        cubit: _dompetBloc,
        builder: (context, state) {
          if (state is DompetLoadingState) {
            return MyWidgets.buildLoadingWidget(context);
          } else if (state is DompetLoadedState) {
            List<Map<String, dynamic>> dompetlist = state.dompetlist;
            listdompetwidget = <Widget>[];

            for (int i = 0; i < dompetlist.length; i++) {
              if (kddompetpicked != dompetlist[i]['kddompet']) {
                listdompetwidget.add(Column(
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
                                        color: MyConst.fromHex(
                                            dompetlist[i]['color']),
                                        shape: BoxShape.circle),
                                    child: new Center(
                                      child: FaIcon(
                                        IconData(dompetlist[i]['codepoint'],
                                            fontFamily: dompetlist[i]
                                                ['fontfamily'],
                                            fontPackage: dompetlist[i]
                                                ['fontpackage']),
                                        color: Colors.white,
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(
                                        right: MyScreens.safeHorizontal * 1),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          dompetlist[i]['namadompet'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Rp. ' +
                                              MyConst.thousandseparator(
                                                  dompetlist[i]['saldo']),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: MyColors.gray),
                                        )
                                      ],
                                    )),
                              ],
                            )),
                        onTap: () {
                          mapback = {
                            'kddompet': dompetlist[i]['kddompet'],
                            'icon': FaIcon(
                                IconData(dompetlist[i]['codepoint'],
                                    fontFamily: dompetlist[i]['fontfamily'],
                                    fontPackage: dompetlist[i]['fontpackage']),
                                color: Colors.white,
                                size: MyScreens.safeVertical * 2.5),
                            'color': MyConst.fromHex(dompetlist[i]['color']),
                            'namadompet': dompetlist[i]['namadompet']
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
            }
            listdompetwidget.add(Container(
              height: MyScreens.safeVertical * 10,
            ));
            return Scaffold(
                appBar: AppBar(
                  title: Text('Dompet Saya'),
                  backgroundColor: MyColors.blue,
                  automaticallyImplyLeading: true,
                  leading: IconButton(
                    icon: Icon(FontAwesomeIcons.arrowLeft),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: SafeArea(
                    child: ListView(
                  shrinkWrap: true,
                  children: listdompetwidget,
                )),
                floatingActionButton: Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: FloatingActionButton(
                      backgroundColor: MyColors.blue,
                      child: Icon(FontAwesomeIcons.plus),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TambahDompetScreen();
                        })).then((val) {
                          if (val) {
                            if (widget.semua != null) {
                              _dompetBloc.add(GetalldompetglobalEvent());
                            } else {
                              _dompetBloc.add(GetalldompetEvent());
                            }
                          }
                        });
                      }),
                ));
          } else if (state is DompetLoadedGlobalState) {
            List<Map<String, dynamic>> dompetlist = state.dompetlist;
            Dompet globaldompet = Dompet(
                kddompet: state.globaldompet.kddompet,
                namadompet: 'Semua Dompet',
                saldo: state.globaldompet.saldo,
                codepoint: 61612,
                fontfamily: 'FontAwesomeSolid',
                fontpackage: 'font_awesome_flutter',
                color: '#459CE9');
            listdompetglobalwidget = <Widget>[];
            listdompetwidget = <Widget>[];

            Widget circle;
            if (kddompetpicked == 0) {
              circle = Icon(
                FontAwesomeIcons.solidCircle,
                color: MyColors.greenlight,
                size: MyScreens.safeVertical * 1.5,
              );
            } else {
              circle = Container();
            }
            listdompetglobalwidget.add(Column(
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
                                    color: MyConst.fromHex(globaldompet.color),
                                    shape: BoxShape.circle),
                                child: new Center(
                                  child: FaIcon(
                                    IconData(
                                      globaldompet.codepoint,
                                      fontFamily: globaldompet.fontfamily,
                                      fontPackage: globaldompet.fontpackage,
                                    ),
                                    color: Colors.white,
                                  ),
                                )),
                            Container(
                                margin: EdgeInsets.only(
                                    right: MyScreens.safeHorizontal * 1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          globaldompet.namadompet,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MyScreens.safeHorizontal * 1,
                                        ),
                                        circle
                                      ],
                                    ),
                                    Text(
                                      'Rp. ' +
                                          MyConst.thousandseparator(
                                              globaldompet.saldo),
                                      style: TextStyle(
                                          fontSize: 13, color: MyColors.gray),
                                    )
                                  ],
                                )),
                          ],
                        )),
                    onTap: () {
                      mapback = {
                        'kddompet': 0,
                        'icon': FaIcon(
                          FontAwesomeIcons.globe,
                          color: Colors.white,
                        ),
                        'color': MyColors.blue,
                        'namadompet': 'Semua Dompet'
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
            for (int i = 0; i < dompetlist.length; i++) {
              if (kddompetpicked == dompetlist[i]['kddompet']) {
                circle = Icon(
                  FontAwesomeIcons.solidCircle,
                  color: MyColors.greenlight,
                  size: MyScreens.safeVertical * 1.5,
                );
              } else {
                circle = Container();
              }
              listdompetwidget.add(Column(
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
                                      color: MyConst.fromHex(
                                          dompetlist[i]['color']),
                                      shape: BoxShape.circle),
                                  child: new Center(
                                    child: FaIcon(
                                      IconData(dompetlist[i]['codepoint'],
                                          fontFamily: dompetlist[i]
                                              ['fontfamily'],
                                          fontPackage: dompetlist[i]
                                              ['fontpackage']),
                                      color: Colors.white,
                                    ),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                      right: MyScreens.safeHorizontal * 1),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            dompetlist[i]['namadompet'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MyScreens.safeHorizontal * 1,
                                          ),
                                          circle
                                        ],
                                      ),
                                      Text(
                                        'Rp. ' +
                                            MyConst.thousandseparator(
                                                dompetlist[i]['saldo']),
                                        style: TextStyle(
                                            fontSize: 13, color: MyColors.gray),
                                      )
                                    ],
                                  )),
                            ],
                          )),
                      onTap: () {
                        mapback = {
                          'kddompet': dompetlist[i]['kddompet'],
                          'icon': FaIcon(
                            IconData(dompetlist[i]['codepoint'],
                                fontFamily: dompetlist[i]['fontfamily'],
                                fontPackage: dompetlist[i]['fontpackage']),
                            color: Colors.white,
                          ),
                          'color': MyConst.fromHex(dompetlist[i]['color']),
                          'namadompet': dompetlist[i]['namadompet']
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

            return Scaffold(
                appBar: AppBar(
                  title: Text('Dompet Saya'),
                  backgroundColor: MyColors.blue,
                  automaticallyImplyLeading: true,
                  leading: IconButton(
                    icon: Icon(FontAwesomeIcons.arrowLeft),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: SafeArea(
                    child: Column(
                  children: <Widget>[
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: listdompetglobalwidget,
                      ),
                    ),
                    SizedBox(
                      height: MyScreens.safeVertical * 2,
                    ),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: listdompetwidget,
                      ),
                    ),
                  ],
                )),
                floatingActionButton: Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: FloatingActionButton(
                      backgroundColor: MyColors.blue,
                      child: Icon(FontAwesomeIcons.plus),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TambahDompetScreen();
                        })).then((val) {
                          if (val) {
                            if (widget.semua != null) {
                              _dompetBloc.add(GetalldompetglobalEvent());
                            } else {
                              _dompetBloc.add(GetalldompetEvent());
                            }
                          }
                        });
                      }),
                ));
          } else if (state is DompetLoadFailureState) {
            return Column(children: <Widget>[
              Container(
                height: MyScreens.safeVertical * 50,
                color: MyColors.light,
                child: Center(
                  child: Text('Gagal Memuat'),
                ),
              )
            ]);
          } else if (state is DompetEmptyState) {
            return Column(children: <Widget>[
              Container(
                height: MyScreens.safeVertical * 50,
                color: MyColors.light,
                child: Center(
                  child: Text('Belum ada dompet'),
                ),
              )
            ]);
          } else {
            return Column(children: <Widget>[
              Container(
                height: MyScreens.safeVertical * 50,
                color: MyColors.light,
                child: Center(
                  child: Text('Belum ada dompet'),
                ),
              )
            ]);
          }
        });
  }
}
