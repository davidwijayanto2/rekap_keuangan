import 'dart:io';
import 'package:rekap_keuangan/models/iconlist.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database _database;
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbpath = join(documentsDirectory.path, "dbrekapkeuangan");
    print('dbpath: ' + dbpath);
    return await openDatabase(dbpath, version: 1, onCreate: populateDb);
  }

  void populateDb(Database database, int version) async {
    await database.execute('''
          CREATE TABLE iconlist (
            iconid INTEGER PRIMARY KEY AUTOINCREMENT,
            iconname TEXT,
            codepoint INTEGER,
            fontfamily TEXT,
            fontpackage TEXT
            )''');
    await database.execute('''CREATE TABLE kategori (
            kdkategori INTEGER PRIMARY KEY AUTOINCREMENT,            
            namakategori TEXT,
            jenis TEXT,
            codepoint INTEGER,
            fontfamily TEXT,
            fontpackage TEXT,
            color TEXT          
            )''');
    await database.execute('''CREATE TABLE dompet (
            kddompet INTEGER PRIMARY KEY AUTOINCREMENT,          
            namadompet TEXT,
            saldo REAL,
            catatan TEXT DEFAULT '',
            codepoint INTEGER,
            fontfamily TEXT,
            fontpackage TEXT,
            color TEXT
            )''');
    await database.execute('''CREATE TABLE transaksi (
            idtransaksi INTEGER PRIMARY KEY AUTOINCREMENT,
            kdtransaksi INTEGER,
            kdkategori INTEGER,
            kddompet INTEGER,
            tanggaltransaksi TEXT,
            keluar REAL,
            masuk REAL,
            catatan TEXT,
            foto TEXT,
            FOREIGN KEY(kdkategori) REFERENCES kategori(kdkategori),
            FOREIGN KEY(kddompet) REFERENCES dompet(kddompet)
            )''');
    await database.execute('''CREATE TABLE memo (
            kdmemo INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT,
            tanggalbuat TEXT
            )''');
    await database.execute('''CREATE TABLE detailmemo(
            kddetailmemo INTEGER PRIMARY KEY AUTOINCREMENT,
            kdmemo INTEGER,
            namadmemo TEXT,
            total REAL,
            status INTEGER,
            FOREIGN KEY(kdmemo) REFERENCES memo(kdmemo)
            )''');
    await database.execute(
        '''INSERT INTO iconlist(iconname,codepoint,fontfamily,fontpackage) VALUES
            ('wallet',62805,'FontAwesomeSolid','font_awesome_flutter'),
            ('plane',61554,'FontAwesomeSolid','font_awesome_flutter'),
            ('suitcase',61682,'FontAwesomeSolid','font_awesome_flutter'),
            ('taxi',61882,'FontAwesomeSolid','font_awesome_flutter'),
            ('tv',62060,'FontAwesomeSolid','font_awesome_flutter'),
            ('dumbbell',62539,'FontAwesomeSolid','font_awesome_flutter'),
            ('spa',62907,'FontAwesomeSolid','font_awesome_flutter'),
            ('wineglass',62691,'FontAwesomeSolid','font_awesome_flutter'),
            ('book',61485,'FontAwesomeSolid','font_awesome_flutter'),
            ('briefcase',61617,'FontAwesomeSolid','font_awesome_flutter'),
            ('bus',61959,'FontAwesomeSolid','font_awesome_flutter'),
            ('camera',61488,'FontAwesomeSolid','font_awesome_flutter'),
            ('car',61881,'FontAwesomeSolid','font_awesome_flutter'),
            ('carrot',63367,'FontAwesomeSolid','font_awesome_flutter'),
            ('coins',62750,'FontAwesomeSolid','font_awesome_flutter'),
            ('home',61461,'FontAwesomeSolid','font_awesome_flutter'),
            ('landmark',63087,'FontAwesomeSolid','font_awesome_flutter'),
            ('laptop',61705,'FontAwesomeSolid','font_awesome_flutter'),
            ('moneybill',61654,'FontAwesomeSolid','font_awesome_flutter'),
            ('moneycheck',61780,'FontAwesomeSolid','font_awesome_flutter'),
            ('shoppingbag',62096,'FontAwesomeSolid','font_awesome_flutter'),   
            ('shoppingcart',61562,'FontAwesomeSolid','font_awesome_flutter'),
            ('shoppingbasket',62097,'FontAwesomeSolid','font_awesome_flutter'),
            ('shuttlevan',62902,'FontAwesomeSolid','font_awesome_flutter'),
            ('syringe',62606,'FontAwesomeSolid','font_awesome_flutter'),
            ('trophy',61585,'FontAwesomeSolid','font_awesome_flutter'),
            ('truck',61649,'FontAwesomeSolid','font_awesome_flutter'),
            ('utensils',62183,'FontAwesomeSolid','font_awesome_flutter'),
            ('wrench',61613,'FontAwesomeSolid','font_awesome_flutter'),
            ('gift',61547,'FontAwesomeSolid','font_awesome_flutter'),
            ('gifts',63388,'FontAwesomeSolid','font_awesome_flutter'),
            ('hamburger',63493,'FontAwesomeSolid','font_awesome_flutter'),
            ('pizzaslice',63512,'FontAwesomeSolid','font_awesome_flutter'),
            ('icecream',63504,'FontAwesomeSolid','font_awesome_flutter'),
            ('applealt',62929,'FontAwesomeSolid','font_awesome_flutter'),
            ('breadslice',63468,'FontAwesomeSolid','font_awesome_flutter'),
            ('creditcard',61597,'FontAwesomeSolid','font_awesome_flutter'),            
            ('creditcard',61597,'FontAwesomeRegular','font_awesome_flutter'),            
            ('ccmastercard',61937,'FontAwesomeBrands','font_awesome_flutter'),
            ('ccvisa',61936,'FontAwesomeBrands','font_awesome_flutter'),
            ('ccpaypal',61940,'FontAwesomeBrands','font_awesome_flutter'),
            ('ccapplepay',62027,'FontAwesomeBrands','font_awesome_flutter'),
            ('ccjcb',61934,'FontAwesomeBrands','font_awesome_flutter'),
            ('googlewallet',61936,'FontAwesomeBrands','font_awesome_flutter'),
            ('baby',63356,'FontAwesomeSolid','font_awesome_flutter'),
            ('babycarriage',63357,'FontAwesomeSolid','font_awesome_flutter'),
            ('mobilealt',62413,'FontAwesomeSolid','font_awesome_flutter'),
            ('tools',63449,'FontAwesomeSolid','font_awesome_flutter'),
            ('hammer',63203,'FontAwesomeSolid','font_awesome_flutter'),
            ('tooth',62921,'FontAwesomeSolid','font_awesome_flutter'),
            ('school',62793,'FontAwesomeSolid','font_awesome_flutter'),
            ('graduationcap',61853,'FontAwesomeSolid','font_awesome_flutter'),
            ('wifi',61931,'FontAwesomeSolid','font_awesome_flutter'),
            ('lightbulb',61675,'FontAwesomeRegular','font_awesome_flutter'),
            ('bolt',61671,'FontAwesomeSolid','font_awesome_flutter'),
            ('firstaid',62585,'FontAwesomeSolid','font_awesome_flutter'),
            ('heartbeat',61982,'FontAwesomeSolid','font_awesome_flutter'),
            ('ambulance',61689,'FontAwesomeSolid','font_awesome_flutter'),
            ('hospital',61688,'FontAwesomeSolid','font_awesome_flutter'),
            ('user',61447,'FontAwesomeSolid','font_awesome_flutter'),
            ('users',61632,'FontAwesomeSolid','font_awesome_flutter'),            
            ('handshake',62133,'FontAwesomeSolid','font_awesome_flutter'),
            ('piggybank',62675,'FontAwesomeSolid','font_awesome_flutter'),
            ('capsules',62571,'FontAwesomeSolid','font_awesome_flutter'),
            ('birthdaycake',61949,'FontAwesomeSolid','font_awesome_flutter'),
            ('globeasia',62846,'FontAwesomeSolid','font_awesome_flutter'),
            ('globeafrica',62844,'FontAwesomeSolid','font_awesome_flutter'),
            ('globeamericas',62845,'FontAwesomeSolid','font_awesome_flutter'),
            ('globeeurope',63394,'FontAwesomeSolid','font_awesome_flutter'),
            ('bicycle',61958,'FontAwesomeSolid','font_awesome_flutter'),
            ('tshirt',62803,'FontAwesomeSolid','font_awesome_flutter'),
            ('bars',61641,'FontAwesomeSolid','font_awesome_flutter'),
            ('tint',61507,'FontAwesomeSolid','font_awesome_flutter'),
            ('faucet',63749,'FontAwesomeSolid','font_awesome_flutter'),
            ('usershield',62725,'FontAwesomeSolid','font_awesome_flutter'),
            ('fileinvoice',62832,'FontAwesomeSolid','font_awesome_flutter')''');
    await database.execute(
        '''INSERT INTO kategori(namakategori,jenis,codepoint,fontfamily,fontpackage,color) VALUES
            ('Transfer','t',62263,'FontAwesomeSolid','font_awesome_flutter','#e9a339'),
            ('Gaji','m',61654,'FontAwesomeSolid','font_awesome_flutter','#12ac32'),
            ('Hadiah','m',61547,'FontAwesomeSolid','font_awesome_flutter','#ce3244'),
            ('Penjualan','m',62133,'FontAwesomeSolid','font_awesome_flutter','#42e9f5'),
            ('Lain-lain','m',61641,'FontAwesomeSolid','font_awesome_flutter','#414257'),
            ('Makan','k',62183,'FontAwesomeSolid','font_awesome_flutter','#78ceab'),
            ('Tagihan','k',62832,'FontAwesomeSolid','font_awesome_flutter','#f54245'),
            ('Belanja','k',62096,'FontAwesomeSolid','font_awesome_flutter','#632351'),
            ('Asuransi','k',62725,'FontAwesomeSolid','font_awesome_flutter','#425af5'),
            ('Transport','k',61959,'FontAwesomeSolid','font_awesome_flutter','#e3f542'),
            ('Fashion','k',62803,'FontAwesomeSolid','font_awesome_flutter','#b942f5'),
            ('Kartu Kredit','k',61597,'FontAwesomeSolid','font_awesome_flutter','#f59c42'),
            ('Pendidikan','k',61853,'FontAwesomeSolid','font_awesome_flutter','#f5ec42'),
            ('Kesehatan','k',61688,'FontAwesomeSolid','font_awesome_flutter','#42f5ce'),
            ('Hiburan','k',62060,'FontAwesomeSolid','font_awesome_flutter','#356c9c'),
            ('Olahraga','k',62539,'FontAwesomeSolid','font_awesome_flutter','#1f082e'),
            ('Traveling','k',61554,'FontAwesomeSolid','font_awesome_flutter','#f542b6'),            
            ('Lain-lain','k',61641,'FontAwesomeSolid','font_awesome_flutter','#414257')''');
  }
}
