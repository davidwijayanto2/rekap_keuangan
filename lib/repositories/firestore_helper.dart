import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rekap_keuangan/utilities/myconst.dart';

class FirestoreHelper {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot> getVersion() {
    return fireStore
        .collection('version')
        .doc(MyConst.versionDocId)
        .snapshots();
  }
}
