import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:rekap_keuangan/blocs/main_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';
import 'package:rekap_keuangan/repositories/firestore_helper.dart';
import 'package:rekap_keuangan/ui/memo_screen.dart';
import 'package:rekap_keuangan/ui/pengaturan_screen.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'rekap_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'transaksi_screen.dart';
//import 'package:firebase_remote_config/firebase_remote_config.dart';

class MainScreen extends StatelessWidget {
  static Dompet mDompet;
  static MainBloc mainBloc;
  static var mTanggalmulai, mTanggalakhir, range, indexfilter;
  static var filtertext;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => MainBloc(),
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('id'),
          ],
          theme: ThemeData(fontFamily: 'Roboto'),
          home: MainScreenBody(),
        ));
  }
}

class MainScreenBody extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreenBody> {
  InterstitialAd myInterstitial;
  bool backflag = false;
  var firstinit = true;
  FirestoreHelper fireStore = new FirestoreHelper();
  // void checklocaldata() async {
  //   prefs = await SharedPreferences.getInstance();
  //   bool fIntro = prefs.getBool("fintro") ?? false;
  //   if (fIntro) {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
  //       return IntroScreen();
  //     }));
  //   }
  // }

  @override
  void initState() {
    //checklocaldata();
    super.initState();
    myInterstitial = buildInterstitialAd()..load();
    MainScreen.mainBloc = BlocProvider.of<MainBloc>(context);
    MainScreen.mainBloc.add(GetdompetEvent(kddompet: 0));
    initializeDateFormatting();
    MainScreen.indexfilter = 3;
    MainScreen.mTanggalmulai = DateFormat('yyyy-MM-dd').format(DateTime.now());
    MainScreen.mTanggalakhir = DateFormat('yyyy-MM-dd').format(DateTime.now());
    MyConst.setFilterText();
    MainScreen.range = 1;
    checkVersion();
  }

  @override
  void dispose() {
    myInterstitial.dispose();
    super.dispose();
  }

  checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int currentVersion = int.parse(packageInfo.buildNumber);
    fireStore.getVersion().listen((event) {
      int lastVersion = event.data()['last_version'];
      int forceUpdate = event.data()['force_update'];
      if (lastVersion > currentVersion) {
        if (forceUpdate > currentVersion) {
          _showForceUpdateDialog();
        } else {
          _showUpdateDialog();
        }
      }
    });
  }

  _showUpdateDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('VERSI TERBARU DITEMUKAN'),
            content: Text('Harap update aplikasi Anda ke versi terbaru'),
            actions: <Widget>[
              FlatButton(
                child: Text('TIDAK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('UPDATE'),
                onPressed: () async {
                  Navigator.pop(context);
                  const url =
                      'https://play.google.com/store/apps/details?id=com.pandacode.rekap_keuangan';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              )
            ],
          );
        });
  }

  _showForceUpdateDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: _onAlertBackPressed,
              child: AlertDialog(
                  title: Center(
                      child: Text(
                    'VERSI TERBARU DITEMUKAN',
                    textAlign: TextAlign.center,
                  )),
                  content: Container(
                      height: MyScreens.safeVertical * 20,
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  'Demi kenyamanan saat menggunakan aplikasi Rekap Keuangan, mohon untuk melakukan update',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ]),
                        SizedBox(
                          height: MyScreens.safeVertical * 2.5,
                        ),
                        DialogButton(
                          width: double.infinity,
                          child: Text(
                            "UPDATE",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () async {
                            const url =
                                'https://play.google.com/store/apps/details?id=com.pandacode.rekap_keuangan';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        )
                      ]))));
        }).then((value) {
      showRandomInterstitialAd();
      SystemNavigator.pop();
    });
    // return Alert(
    //   context: context,
    //   type: AlertType.info,
    //   style: AlertStyle(
    //       isCloseButton: false,
    //       isOverlayTapDismiss: false,
    //       descStyle: TextStyle(fontSize: 14)),
    //   title: "VERSI TERBARU DITEMUKAN",
    //   desc:
    //       "Demi kenyamanan saat menggunakan aplikasi Rekap Keuangan, mohon untuk melakukan update.",
    //   buttons: [
    //     DialogButton(
    //       child: Text(
    //         "UPDATE",
    //         style: TextStyle(color: Colors.white, fontSize: 20),
    //       ),
    //       onPressed: () async {
    //         const url =
    //             'https://play.google.com/store/apps/details?id=com.pandacode.rekap_keuangan';
    //         if (await canLaunch(url)) {
    //           await launch(url);
    //         } else {
    //           throw 'Could not launch $url';
    //         }
    //       },
    //       width: 120,
    //     )
    //   ],
    // ).show();
  }

  InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      adUnitId: MyConst.interAdsUnitID,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          myInterstitial..load();
        } else if (event == MobileAdEvent.closed) {
          myInterstitial = buildInterstitialAd()..load();
        }
        print(event);
      },
    );
  }

  void showRandomInterstitialAd() {
    print('GOALLLLLLL');
    Random r = new Random();
    bool value = r.nextBool();

    if (value == true) {
      myInterstitial..show();
    }
  }

  final List<Widget> pages = [
    RekapScreen(
      key: PageStorageKey('Page1'),
    ),
    TransaksiScreen(
      key: PageStorageKey('Page2'),
    ),
    MemoScreen(
      key: PageStorageKey('Page3'),
    ),
    PengaturanScreen(
      key: PageStorageKey('Page4'),
    ),
  ];
  //ca-app-pub-5073070501377591/9873858817

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        onTap: (int index) {
          setState(() => _selectedIndex = index);
        },
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.chartPie), label: 'Rekap'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.wallet), label: 'Transaksi'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.clipboardList), label: 'Memo'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.cog), label: 'Pengaturan'),
        ],
      );

  DateTime backButtonPressTime;

  Future<bool> _onAlertBackPressed() {
    DateTime currentTime = DateTime.now();

    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            currentTime.difference(backButtonPressTime) > Duration(seconds: 2);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = currentTime;
      Fluttertoast.showToast(msg: "Tekan sekali lagi untuk keluar");
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<bool> _onBackPressed() {
    DateTime currentTime = DateTime.now();

    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            currentTime.difference(backButtonPressTime) > Duration(seconds: 2);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = currentTime;
      Fluttertoast.showToast(msg: "Tekan sekali lagi untuk keluar");
      return Future.value(false);
    }
    showRandomInterstitialAd();
    return Future.value(true);

    // if(backflag){
    //   showRandomInterstitialAd();
    //   Navigator.pop(context);
    //   return Future.value(true);
    // } else {
    //   backflag= true;
    //   print('masuk else');

    //   Timer(Duration(seconds: 0), () {
    //     backflag = false;
    //     print('masuk delay');
    //   });
    //   return Future.value(false);
    // }
  }

  // Future<bool> checkUpdates() async {
  //   var remoteConfig = RemoteConfig();
  //   await remoteConfig.fetch();
  //   await remoteConfig.activateFetched();

  //   final requiredBuildNumber = remoteConfig.getInt(Platform.isAndroid
  //       ? 'requiredBuildNumberAndroid'
  //       : 'requiredBuildNumberIOS');

  //   final currentBuildNumber = int.parse(PackageInfo().buildNumber);

  //   return currentBuildNumber < requiredBuildNumber;
  // }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   //print(((widget.screenwidth*5)/(widget.screenheight*15)));
    //   if (firstinit) {
    //     var check = await checkUpdates();
    //     if (check) {
    //       print('masuk update');
    //     }
    //     firstinit = false;
    //   }
    // });
    MyScreens().initScreen(context);
    return BlocBuilder(
      cubit: BlocProvider.of<MainBloc>(context),
      builder: (context, state) {
        if (state is MainLoadedState) {
          if (state.dompetlist.kddompet == 0) {
            MainScreen.mDompet = Dompet(
                kddompet: state.dompetlist.kddompet,
                namadompet: 'Semua Dompet',
                saldo: state.dompetlist.saldo,
                codepoint: 61612,
                fontfamily: 'FontAwesomeSolid',
                fontpackage: 'font_awesome_flutter',
                color: '#459CE9');
          } else {
            MainScreen.mDompet = state.dompetlist;
          }
          return new WillPopScope(
              onWillPop: _onBackPressed,
              child: Scaffold(
                bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
                body: PageStorage(
                  child: pages[_selectedIndex],
                  bucket: bucket,
                ),
              ));
        } else if (state is MainLoadingState) {
          return new WillPopScope(
              onWillPop: _onBackPressed,
              child: Scaffold(body: MyWidgets.buildLoadingWidget(context)));
        } else {
          return new WillPopScope(
              onWillPop: _onBackPressed, child: Scaffold(body: Container()));
        }
      },
    );
  }
  // BottomAppBar(
  //       child: new Row(
  //         mainAxisSize: MainAxisSize.max,
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           IconButton(
  //             icon: FaIcon(FontAwesomeIcons.chartBar),
  //             onPressed: () {},
  //           ),
  //           IconButton(
  //             icon: FaIcon(FontAwesomeIcons.wallet),
  //             onPressed: () {
  //               setState(() {
  //                 pages
  //               });
  //             },
  //           ),
  //           FloatingActionButton(
  //             onPressed:(){},
  //             tooltip: 'Insert',
  //             child: new Icon(Icons.add),
  //             mini: true,
  //           ),
  //           IconButton(
  //             icon: FaIcon(FontAwesomeIcons.clipboardList),
  //             onPressed: () {},
  //           ),
  //           IconButton(
  //             icon: FaIcon(FontAwesomeIcons.cog),
  //             onPressed: () {},
  //           )
  //         ],
  //       ),
  //     ),

}
