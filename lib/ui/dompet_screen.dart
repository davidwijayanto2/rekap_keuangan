import 'dart:async';

import 'package:rekap_keuangan/blocs/dompet_bloc.dart';
import 'package:rekap_keuangan/ui/tambahdompet_screen.dart';
import 'package:rekap_keuangan/ui/ubahdompet_screen.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DompetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.bluesharp, //or set color with: Color(0xFF0000FF)
    ));
    return BlocProvider(
        create: (BuildContext context) => DompetBloc(),
        child: DompetScreenBody());
  }
}

class DompetScreenBody extends StatefulWidget {
  DompetScreenBody({Key key}) : super(key: key);
  @override
  _DompetState createState() => new _DompetState();
}

class _DompetState extends State<DompetScreenBody> {
  List<Widget> listdompetwidget = <Widget>[];
  DompetBloc _dompetBloc;
  // final _nativeAdController = NativeAdmobController();
  // StreamSubscription _subscription;
  bool adShown = false;
  @override
  void initState() {
    _dompetBloc = BlocProvider.of<DompetBloc>(context);
    _dompetBloc.add(GetalldompetEvent());
    super.initState();
    //_subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
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
                                            fontSize: 13, color: MyColors.gray),
                                      )
                                    ],
                                  )),
                            ],
                          )),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return UbahDompetScreen(
                                kddompet: dompetlist[i]['kddompet']);
                          }),
                        ).then((val) =>
                            val ? _dompetBloc.add(GetalldompetEvent()) : null);
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
              floatingActionButton: FloatingActionButton(
                  backgroundColor: MyColors.blue,
                  child: Icon(FontAwesomeIcons.plus),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TambahDompetScreen();
                    })).then((val) => val != null
                        ? _dompetBloc.add(GetalldompetEvent())
                        : null);
                  }),
            );
          } else if (state is DompetLoadFailureState) {
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
                  child: Column(children: <Widget>[
                Container(
                  height: MyScreens.safeVertical * 50,
                  color: MyColors.light,
                  child: Center(
                    child: Text('Gagal Memuat'),
                  ),
                )
              ])),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: MyColors.blue,
                  child: Icon(FontAwesomeIcons.plus),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TambahDompetScreen();
                    })).then((val) =>
                        val ? _dompetBloc.add(GetalldompetEvent()) : null);
                  }),
            );
          } else if (state is DompetEmptyState) {
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
                  child: Column(children: <Widget>[
                Container(
                  height: MyScreens.safeVertical * 50,
                  color: MyColors.light,
                  child: Center(
                    child: Text('Belum ada dompet'),
                  ),
                )
              ])),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: MyColors.blue,
                  child: Icon(FontAwesomeIcons.plus),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TambahDompetScreen();
                    })).then((val) =>
                        val ? _dompetBloc.add(GetalldompetEvent()) : null);
                  }),
            );
          } else {
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
                  child: Column(children: <Widget>[
                Container(
                  height: MyScreens.safeVertical * 50,
                  color: MyColors.light,
                  child: Center(
                    child: Text('Belum ada dompet'),
                  ),
                )
              ])),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: MyColors.blue,
                  child: Icon(FontAwesomeIcons.plus),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TambahDompetScreen();
                    })).then((val) =>
                        val ? _dompetBloc.add(GetalldompetEvent()) : null);
                  }),
            );
          }
        });

    // return Scaffold(
    //   body: SafeArea(
    //     child: Center(
    //       child: ListView(
    //         shrinkWrap: true,
    //         padding: EdgeInsets.only(left:24.0, right: 24.0),
    //         children: <Widget>[
    //           TextFormField(keyboardType: TextInputType.emailAddress,
    //             controller: txtemail,
    //             autofocus: false,
    //             onFieldSubmitted: (value){
    //               _fieldFocusChange(context, _emailfocus, _passwordfocus);
    //             },
    //             decoration: InputDecoration(
    //               hintText: 'Email',
    //               contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    //               border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    //             )
    //           ),
    //           SizedBox(height: 8.0),
    //           TextFormField(
    //             controller: txtpassword,
    //             textInputAction: TextInputAction.done,
    //             obscureText: true,
    //             onFieldSubmitted: (value){
    //               proccesslogin(txtemail.text,txtpassword.text);
    //             },
    //             decoration: InputDecoration(
    //               hintText: 'Password',
    //               contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    //               border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    //             ),
    //           ),
    //           SizedBox(height: 24.0),
    //           Padding(
    //             padding: EdgeInsets.symmetric(vertical: 16.0),
    //             child: Material(
    //               shadowColor: Colors.lightBlueAccent.shade100,
    //               child: MaterialButton(
    //                 minWidth: 200.0,
    //                 height: 42.0,
    //                 onPressed: () {
    //                   proccesslogin(txtemail.text,txtpassword.text);
    //                 },
    //                 color: Colors.lightBlueAccent,
    //                 child: Text('Log In', style: TextStyle(color: Colors.white)),
    //               ),
    //             ),
    //           )
    //         ],
    //       )
    //     ),
    //   ),
    // );
  }
}
