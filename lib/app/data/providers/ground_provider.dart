import 'package:cloud_firestore/cloud_firestore.dart';

import '../ground_model.dart';

class GroundProvider {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference<Ground> collection =
      FirebaseFirestore.instance.collection("grounds").withConverter<Ground>(
            fromFirestore: (snapshot, _) => Ground.fromSnapshot(snapshot),
            toFirestore: (ground, _) => ground.toMap(),
          );

  Stream<Ground?> groundSnapshotsForId(String id) =>
      collection.doc(id).snapshots().map((event) => event.data());

  Future<DocumentReference<Ground>> addDoc(Ground ground) async {
    return collection.add(ground);
  }

  Future<Ground?> getDoc(String id) async {
    DocumentSnapshot<Ground> snapshot = await collection.doc(id).get();

    return snapshot.exists ? (snapshot).data() : null;
  }

  Future<void> updateDoc(Ground ground) async {
    await collection.doc(ground.documentID).update(ground.toMap());
  }

  Future<void> updateDocWithId(String id, Ground ground) async {
    await collection.doc(id).update(ground.toMap());
  }
}
