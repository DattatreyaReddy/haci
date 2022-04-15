import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haci/app/data/enums/run_type.dart';
import 'package:haci/app/data/enums/team.dart';

import '../ball_model.dart';

class BallProvider {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<List<Ball>> ballsSnapshotsForTeam({
    required String groundId,
    required Team teamName,
  }) =>
      firestore
          .collection("grounds")
          .doc(groundId)
          .collection(teamName.name)
          .withConverter<Ball>(
            fromFirestore: (snapshot, _) => Ball.fromSnapshot(snapshot),
            toFirestore: (ball, _) => ball.toMap(),
          )
          .snapshots()
          .map((event) => event.docs
              .map(
                (e) => e.data(),
              )
              .toList());

  Future<void> addDoc({
    required String groundId,
    required Team nowBatting,
    required RunType runType,
    required int score,
  }) async {
    final collection = firestore
        .collection("grounds")
        .doc(groundId)
        .collection(nowBatting.name);

    firestore.runTransaction((transaction) async {
      DocumentSnapshot<Map<String, dynamic>> groundDoc =
          await transaction.get(firestore.collection("grounds").doc(groundId));

      final String lastBall = groundDoc.data()!["lastBall"].toString();

      DocumentSnapshot<Map<String, dynamic>> doc =
          await transaction.get(collection.doc(lastBall));

      if (doc.exists) {
        Ball ball = Ball.fromMap(doc.data()!);
        if ((ball.batsman != null && runType == RunType.batsman) ||
            (ball.bowler != null && runType == RunType.bowler)) {
          return;
        }
      }
      transaction.set(
        collection.doc(lastBall),
        {runType.name: score},
        SetOptions(merge: true),
      );
      if (doc.exists) {
        Ball ball = Ball.fromMap(doc.data()!);
        int oppositeScore =
            runType == RunType.batsman ? ball.bowler! : ball.batsman!;
        bool toggleBatting = (score == oppositeScore ||
            (groundDoc.data()!["balls"] == (int.parse(lastBall) + 1)));
        transaction.set(
          firestore.collection("grounds").doc(groundId),
          {
            "lastBall": toggleBatting ? 0 : FieldValue.increment(1),
            "nowBatting":
                (toggleBatting) ? toggleTeam(nowBatting).name : nowBatting.name,
          },
          SetOptions(merge: true),
        );
      }
    });
  }

  Future<void> clearBalls(String groundId) async {
    await firestore.runTransaction((transaction) async {
      QuerySnapshot<Map<String, dynamic>> redSnapshots = await firestore
          .collection("grounds")
          .doc(groundId)
          .collection(Team.redTeam.name)
          .get();
      QuerySnapshot<Map<String, dynamic>> blueSnapshots = await firestore
          .collection("grounds")
          .doc(groundId)
          .collection(Team.blueTeam.name)
          .get();
      for (var querySnapshot in redSnapshots.docs) {
        transaction.delete(querySnapshot.reference);
      }
      for (var querySnapshot in blueSnapshots.docs) {
        transaction.delete(querySnapshot.reference);
      }
      transaction.set(
          firestore.collection("grounds").doc(groundId),
          {
            "lastBall": 0,
            "nowBatting": Team.redTeam.name,
          },
          SetOptions(merge: true),
        );
    });
  }


}
