import 'package:rekap_keuangan/blocs/main_bloc.dart';
import 'package:rekap_keuangan/blocs/memo_bloc.dart';
import 'package:rekap_keuangan/blocs/tambahdmemo_bloc.dart';
import 'package:rekap_keuangan/models/detailmemo.dart';
import 'package:rekap_keuangan/ui/tambahdmemo_screen.dart';
import 'package:rekap_keuangan/ui/tambahmemo_screen.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:rekap_keuangan/utilities/mywidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

import 'main_screen.dart';

class MemoScreen extends StatelessWidget {
  MemoScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.bluesharp, //or set color with: Color(0xFF0000FF)
    ));
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MultiBlocProvider(providers: [
          BlocProvider<MemoBloc>(create: (context) => MemoBloc()),
          BlocProvider<TambahDetailMemoBloc>(
              create: (context) => TambahDetailMemoBloc()),
        ], child: MemoScreenBody()));
  }
}

class MemoScreenBody extends StatefulWidget {
  @override
  _MemoScreenState createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreenBody> {
  _MemoScreenState({Key key});
  List<Widget> listmemowidget = <Widget>[];
  MemoBloc _memoBloc;
  var judulshare;
  @override
  void initState() {
    _memoBloc = BlocProvider.of<MemoBloc>(context);
    _memoBloc.add(GetallmemoEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyScreens().initScreen(context);
    return BlocListener(
        cubit: BlocProvider.of<TambahDetailMemoBloc>(context),
        listener: (context, state) {
          if (state is TambahDetailMemoLoadedState) {
            var textshare = 'Daftar memo ' + judulshare + '\n\nDaftar Barang\n';
            var checked = '';
            for (int i = 0; i < state.detailmemolist.length; i++) {
              if (state.detailmemolist[i]['status'] == 0) {
                textshare += state.detailmemolist[i]['namadmemo'] + '\n';
              } else {
                checked += state.detailmemolist[i]['namadmemo'] + '\n';
              }
            }
            if (checked.length > 0) {
              textshare += '\nBarang yang sudah selesai\n' + checked;
            }
            textshare += '\nDibagikan dari Rekap Keuangan-PandaCode';
            Share.share(textshare);
          } else if (state is TambahDetailMemoEmptyState) {
            Fluttertoast.showToast(msg: "Memo belum memiliki daftar barang");
          }
        },
        child: BlocBuilder(
            cubit: _memoBloc,
            builder: (context, state) {
              if (state is MemoLoadingState) {
                return MyWidgets.buildLoadingWidget(context);
              } else if (state is MemoLoadedState) {
                List<Map<String, dynamic>> memolist = state.memolist;
                listmemowidget = <Widget>[];
                for (int i = 0; i < memolist.length; i++) {
                  listmemowidget.add(Container(
                    margin: EdgeInsets.only(
                        top: MyScreens.safeVertical * 2,
                        right: MyScreens.safeHorizontal * 2,
                        left: MyScreens.safeHorizontal * 2,
                        bottom: i == memolist.length - 1
                            ? MyScreens.safeVertical * 2
                            : 0),
                    padding: EdgeInsets.only(
                        right: MyScreens.safeHorizontal * 3,
                        left: MyScreens.safeHorizontal * 3,
                        bottom: MyScreens.safeVertical * 2,
                        top: MyScreens.safeVertical * 1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.all(
                            Radius.circular(MyScreens.safeVertical * 1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ]),
                    child: Column(
                      children: <Widget>[
                        Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return TambahDMemoScreen(
                                      kdmemo: memolist[i]['kdmemo'],
                                      judul: memolist[i]['judul']);
                                }),
                              ).then((val) {
                                MainScreen.mainBloc.add(GetdompetEvent(
                                    kddompet: MainScreen.mDompet.kddompet));
                                _memoBloc.add(GetallmemoEvent());
                              });
                            },
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        memolist[i]['judul'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Rp. ' +
                                            MyConst.thousandseparator(
                                                memolist[i]['total']
                                                    .toDouble()),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MyScreens.safeVertical * 0.5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        memolist[i]['checked'].toString() +
                                            ' / ' +
                                            memolist[i]['jumlah'].toString() +
                                            ' Barang',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: MyColors.gray,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '(Estimasi)',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: MyColors.gray,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MyScreens.safeVertical * 1.5,
                        ),
                        Divider(
                          color: MyColors.graylight,
                          height: 1,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: MyScreens.safeVertical * 1.5,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                                onTap: () {
                                  judulshare = memolist[i]['judul'];
                                  BlocProvider.of<TambahDetailMemoBloc>(context)
                                      .add(GetdetailmemoEvent(
                                          kdmemo: memolist[i]['kdmemo']));
                                },
                                child: Text(
                                  'BAGIKAN MEMO',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.blue,
                                  ),
                                ))),
                      ],
                    ),
                  ));
                }
                return Scaffold(
                    body: SafeArea(
                        child: Container(
                            color: MyColors.light,
                            child: Column(children: <Widget>[
                              Flexible(
                                  child: ListView(
                                shrinkWrap: true,
                                children: listmemowidget,
                              ))
                            ]))),
                    floatingActionButton: FloatingActionButton(
                        backgroundColor: MyColors.blue,
                        child: Icon(FontAwesomeIcons.plus),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return TambahMemoScreen();
                          })).then((val) {
                            MainScreen.mainBloc.add(GetdompetEvent(
                                kddompet: MainScreen.mDompet.kddompet));
                            _memoBloc.add(GetallmemoEvent());
                          });
                        }));
              } else if (state is MemoLoadFailureState) {
                return Container();
              } else if (state is MemoEmptyState) {
                return Scaffold(
                  body: SafeArea(
                      child: Container(
                    color: MyColors.light,
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Belum ada memo belanja'),
                          Text('Klik tombol + untuk menambahkan'),
                        ]),
                  )),
                  floatingActionButton: FloatingActionButton(
                      backgroundColor: MyColors.blue,
                      child: Icon(FontAwesomeIcons.plus),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TambahMemoScreen();
                        })).then((val) {
                          MainScreen.mainBloc.add(GetdompetEvent(
                              kddompet: MainScreen.mDompet.kddompet));
                          _memoBloc.add(GetallmemoEvent());
                        });
                      }),
                );
              } else {
                return Container();
              }
            }));
  }
}
