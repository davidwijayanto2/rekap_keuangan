import 'package:rekap_keuangan/utilities/mycolors.dart';
import 'package:rekap_keuangan/utilities/myscreens.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PanduanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PanduanScreenBody();
  }
}

class PanduanScreenBody extends StatefulWidget {
  @override
  _PanduanState createState() => _PanduanState();
}

class _PanduanState extends State<PanduanScreenBody> {
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
    'Bagaimana Cara Menambah Dompet?',
    <Widget>[
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
                  'Pilih Menu Pengaturan yang ada di navigasi bagian bawah.',
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
                  'Pilih Menu Dompet Saya',
                  textAlign: TextAlign.justify,
                )),
              ])),
      Container(
          margin: EdgeInsets.only(
              left: MyScreens.safeHorizontal * 5,
              right: MyScreens.safeHorizontal * 2.5),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'iii. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Tekan Tombol + di pojok kanan bawah',
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
                  'iv. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Pilih icon dan warnanya, kemudian masukkan nama, saldo awal dan keterangan untuk dompet baru anda lalu tekan Simpan',
                  textAlign: TextAlign.justify,
                )),
              ]))
    ],
  ),
  Entry(
    'Bagaimana Cara Menambah Kategori?',
    <Widget>[
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
                  'Pilih Menu Pengaturan yang ada di navigasi bagian bawah.',
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
                  'Pilih Menu Kategori.',
                  textAlign: TextAlign.justify,
                )),
              ])),
      Container(
          margin: EdgeInsets.only(
              left: MyScreens.safeHorizontal * 5,
              right: MyScreens.safeHorizontal * 2.5),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'iii. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Pilih Tab Pengeluaran atau Pemasukan.',
                  textAlign: TextAlign.justify,
                )),
              ])),
      Container(
          margin: EdgeInsets.only(
              left: MyScreens.safeHorizontal * 5,
              right: MyScreens.safeHorizontal * 2.5),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'iv. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Tekan Tombol + di pojok kanan bawah untuk menambah kategori sesuai tab yang dipilih.',
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
                  '\tv. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Pilih icon dan warnanya, kemudian masukkan nama untuk kategori baru anda lalu tekan Simpan.',
                  textAlign: TextAlign.justify,
                )),
              ]))
    ],
  ),
  Entry(
    'Bagaimana Cara Menambah Transaksi?',
    <Widget>[
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
                  'Pilih menu transaksi yang ada di navigasi bagian bawah.',
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
                  'Tekan tombol +.',
                  textAlign: TextAlign.justify,
                )),
              ])),
      Container(
          margin: EdgeInsets.only(
              left: MyScreens.safeHorizontal * 5,
              right: MyScreens.safeHorizontal * 2.5),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'iii. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Pada tambah transaksi, terdapat 3 jenis transaksi yang dapat ditambahkan yaitu transaksi untuk pengeluaran, pemasukan dan transfer dompet. Pilih pengeuaran atau pemasukan.',
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
                  'iv. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Pilih dompet, pilih kategorinya  lalu isikan nominal kemudian tekan simpan.',
                  textAlign: TextAlign.justify,
                )),
              ]))
    ],
  ),
  Entry(
    'Bagaimana Cara Men-Transfer Saldo ke Dompet Lain?',
    <Widget>[
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
                  'Pilih menu transaksi yang ada di navigasi bagian bawah.',
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
                  'Tekan tombol +.',
                  textAlign: TextAlign.justify,
                )),
              ])),
      Container(
          margin: EdgeInsets.only(
              left: MyScreens.safeHorizontal * 5,
              right: MyScreens.safeHorizontal * 2.5),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'iii. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Pada tambah transaksi, pilih jenis transaksi “Transfer”.',
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
                  'iv. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Pilih dompet asal dan dompet tujuan serta nominal yang akan ditransfer lalu tekan simpan.',
                  textAlign: TextAlign.justify,
                )),
              ])),
    ],
  ),
  Entry(
    'Bagaimana Cara Membuat Memo?',
    <Widget>[
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
                  'Pilih menu memo yang ada di navigasi bagian bawah.',
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
                  'Tekan tombol +.',
                  textAlign: TextAlign.justify,
                )),
              ])),
      Container(
          margin: EdgeInsets.only(
              left: MyScreens.safeHorizontal * 5,
              right: MyScreens.safeHorizontal * 2.5),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'iii. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Masukkan judul dari memo yang akan dibuat.',
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
                  'iv. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Tambahkan barang yang ingin anda beli beserta estimasi harganya.',
                  textAlign: TextAlign.justify,
                )),
              ])),
    ],
  ),
  Entry(
    'Bagaimana Cara Memonitor Pengeluaran dan Pemasukan?',
    <Widget>[
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
                  'Pilih menu rekap yang ada di navigasi bagian bawah.',
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
                  '\tii. ',
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                    child: Text(
                  'Pilih dompet dan periode yang ingin dilihat, lalu Anda dapat memonitor pengeluaran dan pemasukan Anda.',
                  textAlign: TextAlign.justify,
                )),
              ])),
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
