import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rekap_keuangan/ui/initdompet_screen.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('id'),
        ],
        theme: ThemeData(fontFamily: 'Roboto'),
        home: Scaffold(
          body: IntroScreenBody(),
        ));
  }
}

class IntroScreenBody extends StatefulWidget {
  IntroScreenBody({Key key}) : super(key: key);
  @override
  _IntroState createState() => new _IntroState();
}

class _IntroState extends State<IntroScreenBody> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        widgetTitle: imagewidget1(),
        centerWidget: Text(
          "MONITOR PENGELUARAN",
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontFamily: 'Roboto'),
        ),
        description:
            "Catat setiap pemasukan & pengeluaran harian untuk mengatur keuangan Anda ",
        styleDescription: TextStyle(
            color: Colors.white, fontSize: 14.0, fontFamily: 'Roboto'),
        backgroundColor: MyColors.red,
      ),
    );
    slides.add(
      new Slide(
        widgetTitle: imagewidget2(),
        centerWidget: Text(
          "MEMO BELANJA",
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontFamily: 'Roboto'),
        ),
        description:
            "Anda tidak perlu repot - repot mengingat kebutuhan belanja bulanan, cukup catat di memo belanja kami!",
        styleDescription: TextStyle(
            color: Colors.white, fontSize: 14.0, fontFamily: 'Roboto'),
        backgroundColor: MyColors.blue,
      ),
    );
    slides.add(
      new Slide(
        widgetTitle: imagewidget3(),
        centerWidget: Text(
          "LAPORAN KEUANGAN",
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontFamily: 'Roboto'),
        ),
        description:
            "Analisis pengeluaran dan pemasukan dalam periode tertentu",
        styleDescription: TextStyle(
            color: Colors.white, fontSize: 14.0, fontFamily: 'Roboto'),
        backgroundColor: MyColors.yellow,
      ),
    );
  }

  void onDonePress() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return InitDompetScreen();
      }),
    );
  }

  Widget renderNextBtn() {
    return Text(
      "LANJUT",
      style: TextStyle(color: Colors.white),
    );
  }

  Widget renderDoneBtn() {
    return Text(
      "SELESAI",
      style: TextStyle(color: Colors.white),
    );
  }

  Widget renderSkipBtn() {
    return Text(
      "LEWATI",
      style: TextStyle(color: Colors.white),
    );
  }

  Widget imagewidget1() {
    return new Container(
        width: 250.0,
        height: 250.0,
        decoration:
            new BoxDecoration(color: MyColors.redlight, shape: BoxShape.circle),
        child: new Center(
            child: new Container(
                width: 225.0,
                height: 225.0,
                decoration: new BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: new Center(
                  child: FaIcon(
                    FontAwesomeIcons.moneyBillWave,
                    color: MyColors.red,
                    size: 100.0,
                  ),
                ))));
  }

  Widget imagewidget2() {
    return new Container(
        width: 250.0,
        height: 250.0,
        decoration: new BoxDecoration(
            color: MyColors.bluelight, shape: BoxShape.circle),
        child: new Center(
            child: new Container(
                width: 225.0,
                height: 225.0,
                decoration: new BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: new Center(
                  child: FaIcon(
                    FontAwesomeIcons.shoppingBag,
                    color: MyColors.blue,
                    size: 100.0,
                  ),
                ))));
  }

  Widget imagewidget3() {
    return new Container(
        width: 250.0,
        height: 250.0,
        decoration: new BoxDecoration(
            color: MyColors.yellowlight, shape: BoxShape.circle),
        child: new Center(
            child: new Container(
                width: 225.0,
                height: 225.0,
                decoration: new BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: new Center(
                  child: FaIcon(
                    FontAwesomeIcons.chartLine,
                    color: MyColors.yellow,
                    size: 100.0,
                  ),
                ))));
  }

  @override
  Widget build(BuildContext context) {
    MyScreens().initScreen(context);
    return new IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Color(0x33000000),
      highlightColorSkipBtn: Color(0xff000000),

      // Next, Done button
      onDonePress: this.onDonePress,
      renderNextBtn: this.renderNextBtn(),
      renderDoneBtn: this.renderDoneBtn(),
      colorDoneBtn: Color(0x33000000),
      highlightColorDoneBtn: Color(0xff000000),

      // Dot indicator
      colorDot: Color(0x33ffffff),
      colorActiveDot: Color(0xffffffff),
      sizeDot: 13.0,
    );
  }
}
