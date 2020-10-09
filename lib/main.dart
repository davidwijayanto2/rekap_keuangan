import 'package:path/path.dart';
import 'package:rekap_keuangan/ui/initdompet_screen.dart';
import 'package:rekap_keuangan/ui/intro_screen.dart';
import 'package:rekap_keuangan/ui/main_screen.dart';
import 'package:rekap_keuangan/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Cubit cubit, Object event) {
    print(event);
    super.onEvent(cubit, event);
  }

  @override
  void onTransition(Cubit cubit, Transition transition) {
    print(transition);
    super.onTransition(cubit, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool fIntro = prefs.getBool("fintro") ?? false;
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  if (fIntro) {
    runApp(MainScreen());
  } else {
    runApp(IntroScreen());
  }
}
