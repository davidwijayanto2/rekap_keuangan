import 'dart:io';

import 'package:rekap_keuangan/blocs/main_bloc.dart';
import 'package:rekap_keuangan/ui/backupdatabase_screen.dart';
import 'package:rekap_keuangan/ui/kategori_screen.dart';
import 'package:rekap_keuangan/ui/dompet_screen.dart';
import 'package:rekap_keuangan/ui/panduan_screen.dart';
import 'package:rekap_keuangan/ui/tentangrekap_screen.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main_screen.dart';

class PengaturanScreen extends StatelessWidget {
  PengaturanScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.bluesharp, //or set color with: Color(0xFF0000FF)
    ));
    return Scaffold(
      body: SafeArea(child: PengaturanScreenBody()),
    );
  }
}

class PengaturanScreenBody extends StatefulWidget {
  @override
  _PengaturanScreenState createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreenBody> {
  _PengaturanScreenState({Key key});
  // @override
  // void initstate(){
  //   super.initState();
  // }
  // @override
  // void dispose(){

  // }
  @override
  Widget build(BuildContext context) {
    MyScreens().initScreen(context);
    return Container(
        color: MyColors.light,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(MyScreens.safeVertical * 2),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pengaturan',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                )),
            Divider(
              height: MyScreens.safeVertical * 0.1,
              color: MyColors.light,
              thickness: MyScreens.safeVertical * 0.1,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                child: Container(
                    padding: EdgeInsets.only(
                        top: MyScreens.safeVertical * 2.5,
                        bottom: MyScreens.safeVertical * 2.5,
                        left: MyScreens.safeHorizontal * 8),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.wallet),
                        Container(
                          margin: EdgeInsets.only(
                              left: MyScreens.safeHorizontal * 3),
                          child: Text(
                            'Dompet Saya',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: MyScreens.safeVertical * 2,
                            ),
                          ),
                        ),
                      ],
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return DompetScreen();
                    }),
                  ).then((value) {
                    MainScreen.mainBloc.add(
                        GetdompetEvent(kddompet: MainScreen.mDompet.kddompet));
                  });
                },
              ),
            ),
            Divider(
              color: MyColors.light,
              height: MyScreens.safeVertical * 0.4,
              thickness: MyScreens.safeVertical * 0.4,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                child: Container(
                    padding: EdgeInsets.only(
                        top: MyScreens.safeVertical * 2.5,
                        bottom: MyScreens.safeVertical * 2.5,
                        left: MyScreens.safeHorizontal * 8),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.utensils),
                        Container(
                          margin: EdgeInsets.only(
                              left: MyScreens.safeHorizontal * 4),
                          child: Text(
                            'Kategori',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: MyScreens.safeVertical * 2,
                            ),
                          ),
                        ),
                      ],
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return KategoriScreen();
                    }),
                  ).then((value) {
                    MainScreen.mainBloc.add(
                        GetdompetEvent(kddompet: MainScreen.mDompet.kddompet));
                  });
                },
              ),
            ),
            Divider(
              color: MyColors.light,
              height: MyScreens.safeVertical * 0.4,
              thickness: MyScreens.safeVertical * 0.4,
            ),
            // Material(
            //   color: Colors.white,
            //   child: InkWell(
            //     child: Container(
            //         padding: EdgeInsets.only(
            //             top: MyScreens.safeVertical * 2.5,
            //             bottom: MyScreens.safeVertical * 2.5,
            //             left: MyScreens.safeHorizontal * 8),
            //         alignment: Alignment.centerLeft,
            //         child: Row(
            //           children: <Widget>[
            //             FaIcon(FontAwesomeIcons.solidBell),
            //             Container(
            //               margin: EdgeInsets.only(
            //                   left: MyScreens.safeHorizontal * 4),
            //               child: Text(
            //                 'Pengingat',
            //                 style: TextStyle(
            //                   fontWeight: FontWeight.w600,
            //                   fontSize: MyScreens.safeVertical * 2,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         )),
            //     onTap: () {
            //       //pengingat
            //     },
            //   ),
            // ),
            // Divider(
            //   color: MyColors.light,
            //   height: MyScreens.safeVertical * 0.4,
            //   thickness: MyScreens.safeVertical * 0.4,
            // ),
            Material(
              color: Colors.white,
              child: InkWell(
                child: Container(
                    padding: EdgeInsets.only(
                        top: MyScreens.safeVertical * 2.5,
                        bottom: MyScreens.safeVertical * 2.5,
                        left: MyScreens.safeHorizontal * 8),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.database),
                        Container(
                          margin: EdgeInsets.only(
                              left: MyScreens.safeHorizontal * 4),
                          child: Text(
                            'Backup Database',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: MyScreens.safeVertical * 2,
                            ),
                          ),
                        ),
                      ],
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return BackupScreen();
                    }),
                  ).then((value) {
                    MainScreen.mainBloc.add(
                        GetdompetEvent(kddompet: MainScreen.mDompet.kddompet));
                  });
                },
              ),
            ),
            Divider(
              color: MyColors.light,
              height: MyScreens.safeVertical * 0.4,
              thickness: MyScreens.safeVertical * 0.4,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                child: Container(
                    padding: EdgeInsets.only(
                        top: MyScreens.safeVertical * 2.5,
                        bottom: MyScreens.safeVertical * 2.5,
                        left: MyScreens.safeHorizontal * 8),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.book),
                        Container(
                          margin: EdgeInsets.only(
                              left: MyScreens.safeHorizontal * 4),
                          child: Text(
                            'Tentang Rekap Keuangan',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: MyScreens.safeVertical * 2,
                            ),
                          ),
                        ),
                      ],
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return TentangRekapScreen();
                    }),
                  );
                },
              ),
            ),
            Divider(
              color: MyColors.light,
              height: MyScreens.safeVertical * 0.4,
              thickness: MyScreens.safeVertical * 0.4,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                child: Container(
                    padding: EdgeInsets.only(
                        top: MyScreens.safeVertical * 2.5,
                        bottom: MyScreens.safeVertical * 2.5,
                        left: MyScreens.safeHorizontal * 8),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.solidQuestionCircle),
                        Container(
                          margin: EdgeInsets.only(
                              left: MyScreens.safeHorizontal * 4),
                          child: Text(
                            'Panduan Pemakaian',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: MyScreens.safeVertical * 2,
                            ),
                          ),
                        ),
                      ],
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return PanduanScreen();
                    }),
                  );
                },
              ),
            ),
            Divider(
              color: MyColors.light,
              height: MyScreens.safeVertical * 0.4,
              thickness: MyScreens.safeVertical * 0.4,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                child: Container(
                    padding: EdgeInsets.only(
                        top: MyScreens.safeVertical * 2.5,
                        bottom: MyScreens.safeVertical * 2.5,
                        left: MyScreens.safeHorizontal * 8),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.solidStar),
                        Container(
                          margin: EdgeInsets.only(
                              left: MyScreens.safeHorizontal * 4),
                          child: Text(
                            'Beri Nilai',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: MyScreens.safeVertical * 2,
                            ),
                          ),
                        ),
                      ],
                    )),
                onTap: () async {
                  const url =
                      'https://play.google.com/store/apps/details?id=com.pandacode.rekap_keuangan';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
            Divider(
              color: MyColors.light,
              height: MyScreens.safeVertical * 0.4,
              thickness: MyScreens.safeVertical * 0.4,
            ),
            // Material(
            //   color: Colors.white,
            //   child: InkWell(
            //     child: Container(
            //       padding: EdgeInsets.only(
            //         top:MyScreens.safeVertical * 2.5,
            //         bottom: MyScreens.safeVertical * 2.5,
            //         left: MyScreens.safeHorizontal * 8
            //       ),
            //       alignment: Alignment.centerLeft,
            //       child: Row(
            //         children: <Widget>[
            //           FaIcon(FontAwesomeIcons.clock),
            //           Container(
            //             margin: EdgeInsets.only(left:MyScreens.safeHorizontal*3),
            //             child: Text('Aktifkan Pengingat',
            //               style: TextStyle(
            //                 fontWeight: FontWeight.w600,
            //                 fontSize: MyScreens.safeVertical*2,
            //               ),
            //             ),
            //           ),
            //         ],
            //       )
            //     ),
            //     onTap: (){

            //     },
            //   ),
            // ),
            // Container(
            //   padding: EdgeInsets.all(MyScreens.safeVertical * 2),
            //   alignment: Alignment.centerLeft,
            //   child:Text('Laporan',
            //     style: TextStyle(
            //       fontSize: 17,
            //       fontWeight: FontWeight.w600
            //     ),
            //   )
            // ),
            // Divider(
            //   height: MyScreens.safeVertical * 0.1,
            //   color: MyColors.light,
            //   thickness: MyScreens.safeVertical * 0.1,
            // ),
            // Material(
            //   color: Colors.white,
            //   child: InkWell(
            //     child: Container(
            //       padding: EdgeInsets.only(
            //         top:MyScreens.safeVertical * 2.5,
            //         bottom: MyScreens.safeVertical * 2.5,
            //         left: MyScreens.safeHorizontal * 8
            //       ),
            //       alignment: Alignment.centerLeft,
            //       child: Row(
            //         children: <Widget>[
            //           FaIcon(FontAwesomeIcons.chartLine),
            //           Container(
            //             margin: EdgeInsets.only(left:MyScreens.safeHorizontal*3),
            //             child: Text('Arus Kas',
            //               style: TextStyle(
            //                 fontWeight: FontWeight.w600,
            //                 fontSize: MyScreens.safeVertical*2,
            //               ),
            //             ),
            //           ),
            //         ],
            //       )
            //     ),
            //     onTap: (){

            //     },
            //   ),
            // ),
            // Divider(
            //   color: MyColors.light,
            //   height: MyScreens.safeVertical * 0.4,
            //   thickness: MyScreens.safeVertical * 0.4,
            // ),
            // Material(
            //   color: Colors.white,
            //   child: InkWell(
            //     child: Container(
            //       padding: EdgeInsets.only(
            //         top:MyScreens.safeVertical * 2.5,
            //         bottom: MyScreens.safeVertical * 2.5,
            //         left: MyScreens.safeHorizontal * 8
            //       ),
            //       alignment: Alignment.centerLeft,
            //       child: Row(
            //         children: <Widget>[
            //           FaIcon(FontAwesomeIcons.coins),
            //           Container(
            //             margin: EdgeInsets.only(left:MyScreens.safeHorizontal*3),
            //             child: Text('Pemasukan',
            //               style: TextStyle(
            //                 fontWeight: FontWeight.w600,
            //                 fontSize: MyScreens.safeVertical*2,
            //               ),
            //             ),
            //           ),
            //         ],
            //       )
            //     ),
            //     onTap: (){

            //     },
            //   ),
            // ),
          ],
        ));
  }
}
