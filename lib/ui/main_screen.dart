import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:package_info/package_info.dart';
import 'package:rekap_keuangan/blocs/main_bloc.dart';
import 'package:rekap_keuangan/models/dompet.dart';
import 'package:rekap_keuangan/ui/intro_screen.dart';
import 'package:rekap_keuangan/ui/memo_screen.dart';
import 'package:rekap_keuangan/ui/pengaturan_screen.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
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
  }

  @override
  void dispose() {
    myInterstitial.dispose();
    super.dispose();
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
              icon: FaIcon(FontAwesomeIcons.chartPie), title: Text('Rekap')),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.wallet), title: Text('Transaksi')),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.clipboardList),
              title: Text('Memo')),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.cog), title: Text('Pengaturan')),
        ],
      );

  DateTime backButtonPressTime;

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
