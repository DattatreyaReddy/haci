import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Ground {
  int? balls;
  String? ballsType;
  int? lastBall;
  String? bluePalyer;
  String? redPalyer;
  String? nowBatting;
  DocumentSnapshot? snapshot;
  DocumentReference? reference;
  String? documentID;

  Ground({
    this.balls,
    this.ballsType,
    this.lastBall,
    this.bluePalyer,
    this.redPalyer,
    this.nowBatting,
    this.snapshot,
    this.reference,
    this.documentID,
  });

  Ground copyWith({
    int? balls,
    String? ballsType,
    int? lastBall,
    String? bluePalyer,
    String? redPalyer,
    String? nowBatting,
  }) {
    return Ground(
      balls: balls ?? this.balls,
      ballsType: ballsType ?? this.ballsType,
      lastBall: lastBall ?? this.lastBall,
      bluePalyer: bluePalyer ?? this.bluePalyer,
      redPalyer: redPalyer ?? this.redPalyer,
      nowBatting: nowBatting ?? this.nowBatting,
      snapshot: snapshot,
      reference: reference,
      documentID: documentID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balls': balls,
      'ballsType': ballsType,
      'lastBall': lastBall,
      'bluePalyer': bluePalyer,
      'redPalyer': redPalyer,
      'nowBatting': nowBatting,
    };
  }

  factory Ground.fromMap(Map<String, dynamic> map) {
    return Ground(
      balls: map['balls']?.toInt(),
      ballsType: map['ballsType'],
      lastBall: map['lastBall']?.toInt(),
      bluePalyer: map['bluePalyer'],
      redPalyer: map['redPalyer'],
      nowBatting: map['nowBatting'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Ground.fromJson(String source) => Ground.fromMap(json.decode(source));

  factory Ground.fromSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      return Ground(
        snapshot: snapshot,
        reference: snapshot.reference,
        documentID: snapshot.id,
      );
    }
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    return Ground(
      balls: map['balls']?.toInt(),
      ballsType: map['ballsType'],
      lastBall: map['lastBall']?.toInt(),
      bluePalyer: map['bluePalyer'],
      redPalyer: map['redPalyer'],
      nowBatting: map['nowBatting'],
      snapshot: snapshot,
      reference: snapshot.reference,
      documentID: snapshot.id,
    );
  }

  @override
  String toString() {
    return 'Ground(balls: $balls, ballsType: $ballsType, lastBall: $lastBall'
        ' bluePalyer: $bluePalyer, redPalyer: $redPalyer,'
        ' nowBatting: $nowBatting, referance: ${reference.toString()},'
        ' documentId: $documentID, snapshot: ${snapshot.toString()} )';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ground &&
        other.balls == balls &&
        other.ballsType == ballsType &&
        other.lastBall == lastBall &&
        other.bluePalyer == bluePalyer &&
        other.redPalyer == redPalyer &&
        other.nowBatting == nowBatting &&
        other.reference == reference &&
        other.snapshot == snapshot &&
        other.documentID == documentID;
  }

  @override
  int get hashCode {
    return balls.hashCode ^
        ballsType.hashCode ^
        lastBall.hashCode ^
        bluePalyer.hashCode ^
        redPalyer.hashCode ^
        nowBatting.hashCode ^
        reference.hashCode ^
        snapshot.hashCode ^
        documentID.hashCode;
  }
}
