import 'package:sqflite/sqflite.dart';
import 'package:rekap_keuangan/repositories/db_helper.dart';

class IconList {
  var iconid, iconname, codepoint, fontfamily, fontpackage;

  IconList(
      {this.iconid,
      this.iconname,
      this.codepoint,
      this.fontfamily,
      this.fontpackage});

  IconList.fromMap(Map<String, dynamic> map)
      : iconid = map['iconid'],
        iconname = map['iconname'],
        codepoint = map['codepoint'],
        fontfamily = map['fontfamily'],
        fontpackage = map['fontpackage'];

  Map<String, dynamic> toMap() => {
        "iconid": iconid,
        "iconname": iconname,
        "codepoint": codepoint,
        "fontfamily": fontfamily,
        "fontpackage": fontpackage
      };
  Future<void> inserticon(IconList iconlist) async {
    Database db = await DatabaseHelper.instance.database;
    await db.insert("iconlist", iconlist.toMap());
  }

  Future<List> geticonlist() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery("SELECT * FROM iconlist");
    return result;
  }
}
