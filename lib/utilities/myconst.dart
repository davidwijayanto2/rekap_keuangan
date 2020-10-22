import 'dart:async';
import 'dart:math';

import 'package:rekap_keuangan/ui/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class MyConst {
  static final nativeAdsUnitID = "ca-app-pub-5073070501377591/3406444733";
  static final interAdsUnitID = "ca-app-pub-5073070501377591/3282816491";
  static bool adsdelay = false;
  static int adstimer;
  static Timer timer;
  static fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String toHex(Color code) {
    var hex = '#${code.value.toRadixString(16)}';
    return hex;
  }

  static String thousandseparator(var number) {
    if (number > -1000 && number < 1000) return number.round().toString();

    final String digits = number.round().abs().toString();
    final StringBuffer result = StringBuffer(number < 0 ? '-' : '');
    final int maxDigitIndex = digits.length - 1;
    for (int i = 0; i <= maxDigitIndex; i += 1) {
      result.write(digits[i]);
      if (i < maxDigitIndex && (maxDigitIndex - i) % 3 == 0) result.write('.');
    }
    return result.toString();
  }

  static String removeseparator(var number) {
    return number.toString().replaceAll('.', '');
  }

  static String datetoStoreFormat(String dt) {
    var formatrep = dt.replaceAll('-', '/');
    var strtodate = DateFormat('dd/MM/yyyy').parse(formatrep);
    final f = new DateFormat('yyyy-MM-dd');
    return f.format(strtodate);
  }

  static String datetoShowFormat(String dt) {
    var strtodate = DateTime.parse(dt);
    final f = new DateFormat('dd-MM-yyyy');
    return f.format(strtodate);
  }

  static String addDateFormat(String dt, range) {
    DateTime todatetime = DateTime.parse(dt);
    var adddate = todatetime.add(Duration(days: range));
    return DateFormat('yyyy-MM-dd').format(adddate);
  }

  static String subDateFormat(String dt, range) {
    DateTime todatetime = DateTime.parse(dt);
    var subdate = todatetime.subtract(Duration(days: range));
    return DateFormat('yyyy-MM-dd').format(subdate);
  }

  static double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  static void setFilterText() {
    if (MainScreen.mTanggalmulai == '0000-00-00') {
      MainScreen.filtertext = 'Semua Waktu';
    } else {
      DateTime tanggalmulai = DateTime.parse(MainScreen.mTanggalmulai);
      DateTime tanggalakhir = DateTime.parse(MainScreen.mTanggalakhir);
      var getlastdayofmonth =
          DateTime(tanggalakhir.year, tanggalakhir.month + 1, 1)
              .subtract(Duration(days: 1));

      if (tanggalmulai.year == tanggalakhir.year) {
        if (tanggalmulai.month == tanggalakhir.month) {
          if (tanggalmulai.day == tanggalakhir.day) {
            MainScreen.filtertext = DateFormat.EEEE('id').format(tanggalmulai) +
                ', ' +
                DateFormat('dd ').format(tanggalmulai) +
                DateFormat.MMMM('id').format(tanggalmulai) +
                DateFormat(' yyyy').format(tanggalmulai);
          } else if (tanggalmulai.day == 1 &&
              tanggalakhir.day == getlastdayofmonth.day) {
            MainScreen.filtertext = DateFormat.MMMM('id').format(tanggalmulai) +
                DateFormat(' yyyy').format(tanggalmulai);
          } else {
            MainScreen.filtertext = DateFormat('dd ').format(tanggalmulai) +
                ' - ' +
                DateFormat('dd ').format(tanggalakhir) +
                DateFormat.MMMM('id').format(tanggalakhir) +
                DateFormat(' yyyy').format(tanggalakhir);
          }
        } else {
          if (tanggalmulai.day == 1 &&
              tanggalakhir.day == getlastdayofmonth.day &&
              tanggalmulai.month == 1 &&
              tanggalakhir.month == 12) {
            MainScreen.filtertext = DateFormat('yyyy').format(tanggalmulai);
          } else {
            MainScreen.filtertext = DateFormat('dd ').format(tanggalmulai) +
                DateFormat.MMMM('id').format(tanggalmulai) +
                ' - ' +
                DateFormat('dd ').format(tanggalakhir) +
                DateFormat.MMMM('id').format(tanggalakhir) +
                DateFormat(' yyyy').format(tanggalakhir);
          }
        }
      } else {
        MainScreen.filtertext = DateFormat('dd ').format(tanggalmulai) +
            DateFormat.MMMM('id').format(tanggalmulai) +
            DateFormat(' yyyy').format(tanggalmulai) +
            ' - ' +
            DateFormat('dd ').format(tanggalakhir) +
            DateFormat.MMMM('id').format(tanggalakhir) +
            DateFormat(' yyyy').format(tanggalakhir);
      }
    }
  }

  static void setAdsTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(oneSec, (Timer timer) {
      if (adstimer < 1) {
        timer.cancel();
        adsdelay = false;
      } else {
        adstimer = adstimer - 1;
        print(adstimer);
        print(adsdelay);
      }
    });
  }
}
