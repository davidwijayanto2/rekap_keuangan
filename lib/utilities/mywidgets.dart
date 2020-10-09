import 'dart:io';

import 'package:rekap_keuangan/blocs/icon_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/IconPicker/iconPicker.dart';
import 'package:flutter_iconpicker/IconPicker/searchBar.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'myscreens.dart';

class MyWidgets {
  static ProgressDialog dialog;
  static Widget buildLoadingWidget(context) {
    return Center(
      child: Platform.isIOS
          ? CupertinoActivityIndicator()
          : CircularProgressIndicator(),
    );
  }

  void buildLoadingDialog(BuildContext context) {
    dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: 'Menunggu ...');
  }

  static Future<Map<String, dynamic>> showiconpickerdialog(BuildContext context,
      {double iconSize = 30,
      ShapeBorder iconPickerShape,
      Widget title = const Text('Pick an icon'),
      Widget closeChild = const Text(
        'Close',
        textScaleFactor: 1.25,
      ),
      double screenheight,
      double screenwidth,
      Color pickedcolor,
      IconData pickedicon,
      IconPack iconPackMode = IconPack.fontAwesomeIcons}) async {
    Map<String, dynamic> mapback = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                child: Container(
                  height: screenheight * 70,
                  padding: EdgeInsets.only(
                      top: screenheight * 3,
                      left: screenwidth * 3,
                      right: screenwidth * 3),
                  child: new Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: MyScreens.safeVertical * 7,
                          height: MyScreens.safeVertical * 7,
                          decoration: BoxDecoration(
                              color: pickedcolor, shape: BoxShape.circle),
                          child: Icon(
                            pickedicon,
                            color: Colors.white,
                          ),
                        ),
                        // Container(
                        //     alignment: Alignment.center,
                        //     decoration: ShapeDecoration(
                        //         color: pickedcolor, shape: CircleBorder()),
                        //     child: Icon(
                        //       pickedicon,
                        //       color: Colors.white,
                        //     )),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            'Pilih Ikon',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: screenheight * 5,
                            child: TabBar(
                              labelColor: MyColors.gray,
                              unselectedLabelColor: MyColors.graylight,
                              tabs: <Widget>[
                                Container(
                                    height: screenheight * 4,
                                    child: new Tab(text: 'Icon')),
                                Container(
                                  height: screenheight * 4,
                                  child: new Tab(text: 'Color'),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: screenheight * 47,
                            child: TabBarView(
                              children: <Widget>[
                                Container(
                                  height: screenheight * 38,
                                  constraints: BoxConstraints(
                                      minHeight: screenheight * 38,
                                      minWidth: screenwidth * 80),
                                  child: Column(children: <Widget>[
                                    Flexible(
                                        child: MyIconPicker(
                                      onIconChange: (icondata) {
                                        setState(() {
                                          pickedicon = icondata;
                                        });
                                      },
                                      iconPack: iconPackMode,
                                      iconSize: iconSize,
                                      selectedicon: pickedicon,
                                      screenheight: screenheight,
                                      screenwidth: screenwidth,
                                    )),
                                  ]),
                                ),
                                Container(
                                    height: screenheight * 38,
                                    child: MaterialColorPicker(
                                        onlyShadeSelection: true,
                                        onColorChange: (color) {
                                          setState(() {
                                            pickedcolor = color;
                                          });
                                        },
                                        selectedColor: pickedcolor))
                              ],
                            ),
                          ),
                          Container(
                              height: screenheight * 6,
                              alignment: Alignment.bottomRight,
                              child: Container(
                                  width: 40.0,
                                  padding: EdgeInsets.all(0.0),
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0.0),
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(color: MyColors.blue),
                                    ),
                                    onPressed: () {
                                      Map<String, dynamic> mapvalue = {
                                        'icon': pickedicon,
                                        'color': pickedcolor
                                      };
                                      Navigator.pop(context, mapvalue);
                                    },
                                  )))

                          // Expanded(
                          //   child: Column(
                          //     children: <Widget>[
                          //       Container(
                          //         height: screenheight*5,
                          //         padding: EdgeInsets.all(0.0),
                          //         alignment: Alignment.bottomRight,
                          //         child: FlatButton(
                          //           padding: const EdgeInsets.only(right: 20),
                          //           onPressed: () => Navigator.of(context).pop(),
                          //           child: Text('Ok'),
                          //         ),
                          //       ),
                          //       Container(
                          //         height: screenheight*5,
                          //         padding: EdgeInsets.all(0.0),
                          //         alignment: Alignment.bottomLeft,
                          //         child: FlatButton(
                          //           padding: const EdgeInsets.only(right: 20),
                          //           onPressed: () => Navigator.of(context).pop(),
                          //           child: closeChild,
                          //         ),
                          //       )
                          //     ],
                          //   )
                          // ),
                        ],
                      ),
                    )
                  ]),
                ),
              );
            },
          );
        });
    return mapback;
  }
}

class MyIconPicker extends StatelessWidget {
  final ValueChanged<IconData> onIconChange;
  final IconPack iconPack;
  final double iconSize;
  final double screenheight;
  final double screenwidth;
  final IconData selectedicon;

  MyIconPicker({
    this.onIconChange,
    this.iconPack,
    this.iconSize,
    this.selectedicon,
    this.screenheight,
    this.screenwidth,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => IconBloc(),
        child: IconListWidget(
            onIconChange: onIconChange,
            iconPack: iconPack,
            iconSize: iconSize,
            screenheight: screenheight,
            screenwidth: screenwidth,
            selectedicon: selectedicon));
  }
}

class IconListWidget extends StatefulWidget {
  final ValueChanged<IconData> onIconChange;
  final IconPack iconPack;
  final double iconSize;
  final double screenheight;
  final double screenwidth;
  final IconData selectedicon;
  static List<Map<String, dynamic>> iconMap;
  @override
  IconListState createState() => IconListState();

  IconListWidget({
    this.onIconChange,
    this.iconPack,
    this.iconSize,
    this.selectedicon,
    this.screenheight,
    this.screenwidth,
    Key key,
  }) : super(key: key);
}

class IconListState extends State<IconListWidget> {
  IconBloc _iconBloc;
  List<Widget> iconLists = [];
  List<Color> coloricon = [];
  int previndex = 0;
  double itemposition = 0;
  ScrollController scrollController;
  bool firstinit = true;
  @override
  void initState() {
    super.initState();
    _iconBloc = BlocProvider.of<IconBloc>(context);
    _iconBloc.add(GetalliconEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _iconBloc,
      builder: (context, state) {
        if (state is IconLoadingState) {
          return MyWidgets.buildLoadingWidget(context);
        } else if (state is IconLoadedState) {
          final stateIconLoadedState = state;
          IconListWidget.iconMap = stateIconLoadedState.iconlist;
          this.iconLists = <Widget>[];
          //var mapvalues = MyIconPicker.iconMap.values.toList();
          // for(int i=0;i<listIcons.length;i++){
          //   IconListWidget.iconMap.addAll({listIcons[i].iconname : IconData(listIcons[i].codepoint,fontFamily:listIcons[i].fontfamily,fontPackage: listIcons[i].fontpackage)});
          // }
          scrollController = ScrollController();
          for (int i = 0; i < IconListWidget.iconMap.length; i++) {
            var mapvalues = IconListWidget.iconMap[i];
            var val = IconData(mapvalues['codepoint'],
                fontFamily: mapvalues['fontfamily'],
                fontPackage: mapvalues['fontpackage']);
            var col;
            if (widget.selectedicon == val) {
              previndex = i;
              col = MyColors.graylight;
              itemposition =
                  ((widget.screenheight * 11.6) * (i / 4).floor()).toDouble();
              print(itemposition);
            } else {
              col = Colors.white;
            }
            coloricon.add(col);
            iconLists.add(GestureDetector(
              onTap: () => setState(() {
                coloricon[previndex] = Colors.white;
                coloricon[i] = MyColors.graylight;
                previndex = i;
                widget.onIconChange(val);
              }),
              child: Container(
                height: 20,
                width: 20,
                decoration: new BoxDecoration(
                  color: coloricon[i],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  val,
                  size: widget.iconSize,
                ),
              ),
            ));
          }
          GridView gridview = new GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              controller: scrollController,
              children: iconLists);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            //print(((widget.screenwidth*5)/(widget.screenheight*15)));
            if (firstinit) {
              scrollController.jumpTo(itemposition);
              firstinit = false;
            }
          });
          return gridview;
        } else if (state is IconFailureState) {
          return Container();
        } else if (state is IconEmptyState) {
          return Container();
        } else if (state is IconInitialState) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }
}

// class MyIconPicker extends StatefulWidget {
//   final ValueChanged<IconData> onIconChange;
//   final IconPack iconPack;
//   final double iconSize;
//   final String noResultsText;
//   static Function reload;
//   static Map<String, IconData> iconMap;

//   MyIconPicker({this.onIconChange,this.iconPack, this.iconSize, this.noResultsText, Key key})
//       : super(key: key);

//   @override
//   _IconPickerState createState() => _IconPickerState();
// }

// class _IconPickerState extends State<MyIconPicker> {
//   List<Widget> iconList = [];
//   List<Color> coloricon = [];
//   Color col = Colors.green;
//   @override
//   void initState() {
//     super.initState();
//     MyIconPicker.iconMap = IconManager.getSelectedPack(widget.iconPack);
//     _buildIcons(context);
//     MyIconPicker.reload = reload;
//   }

//   reload() {
//     if (MyIconPicker.iconMap.isNotEmpty)
//       _buildIcons(context);
//     else
//       setState(() {
//         iconList = [];
//       });
//   }
//   _iconselected(IconData val,int _i){
//     setState(() {
//       print('masuk');
//       print(_i);
//       print(coloricon[_i]);
//       coloricon[_i]=Colors.black;
//       print(coloricon[_i]);
//     });
//     widget.onIconChange(val);
//   }
//   _buildIcons(context) async {
//     iconList = [];
//     var mapvalues = MyIconPicker.iconMap.values.toList();
//     for(int i=0;i<MyIconPicker.iconMap.length;i++){
//       var val = mapvalues[i];
//       RandomColor _randomColor = RandomColor();
//       Color _color = _randomColor.randomColor();
//       coloricon.add(_color);
//       iconList.add(GestureDetector(
//         onTap: () => setState(() {
//             //coloricon[i]=Colors.black;
//             col = Colors.black;
//             widget.onIconChange(val);
//           }),
//         child: Container(
//           height: 50,
//           width: 50,
//           decoration: new BoxDecoration(
//             color: col,
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             val,
//             size: widget.iconSize,
//           ),
//         ),
//       ));
//       //setState(() {});
//     }
//     // int i = 0;
//     // MyIconPicker.iconMap.forEach((String key, IconData val) {
//     //   coloricon.add(Colors.white);
//     //   iconList.add(GestureDetector(
//     //     onTap: () {
//     //       _iconselected(val,i);
//     //     },
//     //     child: Container(
//     //       height: 50,
//     //       width: 50,
//     //       decoration: new BoxDecoration(
//     //         color: coloricon[i],
//     //         shape: BoxShape.circle,
//     //       ),
//     //       child: Icon(
//     //         val,
//     //         size: widget.iconSize,
//     //       ),
//     //     ),
//     //   ));
//     //   i++;
//     //   setState(() {});
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: <Widget>[
//       SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.only(top: 10, bottom: 10),
//           child: Wrap(
//               spacing: 25,
//               runSpacing: 25,
//               children: MyIconPicker.iconMap.length != 0
//                   ? iconList
//                   : [
//                       Center(
//                         child: Text(widget.noResultsText +
//                             ' ' +
//                             SearchBar.searchTextController.text),
//                       )
//                     ]),
//         ),
//       ),

//     ]);
//   }
// }
