import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TentangRekapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TentangRekapScreenBody();
  }
}

class TentangRekapScreenBody extends StatefulWidget {
  @override
  _TentangRekapState createState() => _TentangRekapState();
}

class _TentangRekapState extends State<TentangRekapScreenBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyScreens().initScreen(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Tentang Rekap Keuangan'),
          backgroundColor: MyColors.blue,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
            child: Container(
          color: Colors.white,
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  EntryItem(data[index]),
              itemCount: data.length),
        )));
  }
}

class Entry {
  Entry(this.title, [this.children = const <Widget>[]]);

  final String title;
  final List<Widget> children;
}

final List<Entry> data = <Entry>[
  Entry(
    'Apa itu Rekap Keuangan?',
    <Widget>[
      Container(
          margin: EdgeInsets.only(
              left: MyScreens.safeHorizontal * 2.5,
              right: MyScreens.safeHorizontal * 2.5),
          child: Text(
            'Rekap Keuangan merupakan sebuah aplikasi yang hebat untuk memonitor kebiasaan belanja dan mempersiapkan tabungan untuk masa depan.  Berikut hal yang dapat kamu lakukan dengan Rekap Keuangan :',
            textAlign: TextAlign.justify,
          )),
      Container(
          margin: EdgeInsets.only(
              left: MyScreens.safeHorizontal * 5,
              right: MyScreens.safeHorizontal * 2.5),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '\t\ti. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Kamu dapat secara aktif memonitor pemasukan dan pengeluaran kamu dalam periode tertentu.',
                  textAlign: TextAlign.justify,
                )),
              ])),
      Container(
          margin: EdgeInsets.only(
            left: MyScreens.safeHorizontal * 5,
            right: MyScreens.safeHorizontal * 2.5,
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '\tii. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Kamu dapat melihat arus keluar masuk dari saldo yang kamu miliki di setiap dompet.',
                  textAlign: TextAlign.justify,
                )),
              ])),
      Container(
          margin: EdgeInsets.only(
              left: MyScreens.safeHorizontal * 5,
              right: MyScreens.safeHorizontal * 2.5,
              bottom: MyScreens.safeHorizontal * 2.5),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'iii. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Kamu dapat melakukan perencanaan finansial dengan melihat hasil Rekap pengeluaran pemasukanmu.',
                  textAlign: TextAlign.justify,
                )),
              ]))
    ],
  ),
  Entry(
    'Apa itu Dompet?',
    <Widget>[
      Container(
          margin: EdgeInsets.only(
              left: MyScreens.safeHorizontal * 2.5,
              right: MyScreens.safeHorizontal * 2.5,
              bottom: MyScreens.safeHorizontal * 2.5),
          child: Text(
            'Di Rekap Keuangan, kamu dapat membuat dompet sesuai kebutuhanmu untuk memisahkan saldo yang seperti dompet tunai, rekening bank dan tabungan yang kamu miliki',
            textAlign: TextAlign.justify,
          ))
    ],
  ),
  Entry(
    'Apa itu Kategori?',
    <Widget>[
      Container(
          margin: EdgeInsets.only(
              left: MyScreens.safeHorizontal * 2.5,
              right: MyScreens.safeHorizontal * 2.5,
              bottom: MyScreens.safeHorizontal * 2.5),
          child: Text(
            'Untuk mencatat pengeluaran dan pemasukan kamu, Rekap Keuangan akan membedakan kategori untuk pemasukan dan pengeluaran. Kamu juga dapat menambah kategori sesuai kebutuhanmu lho!',
            textAlign: TextAlign.justify,
          ))
    ],
  ),
  Entry(
    'Apa itu Memo Belanja?',
    <Widget>[
      Container(
          margin: EdgeInsets.only(
              left: MyScreens.safeHorizontal * 2.5,
              right: MyScreens.safeHorizontal * 2.5,
              bottom: MyScreens.safeHorizontal * 2.5),
          child: Text(
            'Duh sering lupa nih sama apa yang perlu dibeli ketika sudah sampai di tempat belanja. Dengan bantuan fitur memo, kamu dapat membuat catatan barang yang perlu kamu beli. Jadi kamu gak perlu susah – susah mengingat daftar belanjaanmu lagi.',
            textAlign: TextAlign.justify,
          ))
    ],
  ),
  Entry(
    'Apa itu Rekap?',
    <Widget>[
      Container(
          margin: EdgeInsets.only(
              left: MyScreens.safeHorizontal * 2.5,
              right: MyScreens.safeHorizontal * 2.5,
              bottom: MyScreens.safeHorizontal * 2.5),
          child: Text(
            'Dengan menu rekap, kamu dapat memonitor kondisi keuanganmu dalam periode tertentu, kamu dapat membuat rencana untuk menabung atau menghemat jika pengeluaranmu sudah terlihat banyak. Jadi kalau sudah pakai Rekap Keuangan jangan lupa untuk mencatatat pemasukan dan pengeluaranmu sehari –hari ya!',
            textAlign: TextAlign.justify,
          ))
    ],
  ),
  Entry(
    'Apa itu Reminder?',
    <Widget>[
      Container(
          margin: EdgeInsets.only(
              left: MyScreens.safeHorizontal * 2.5,
              right: MyScreens.safeHorizontal * 2.5,
              bottom: MyScreens.safeHorizontal * 2.5),
          child: Text(
            'Nah ini nih jawaban buat kamu yang sering lupa buat nginput pemasukan dan pengeluaran yang kamu lakukan sehari hari. Kamu bisa mengatur pengingatnya di jam ketika kamu sudah senggang.',
            textAlign: TextAlign.justify,
          ))
    ],
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
