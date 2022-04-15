import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Ball {
  int? batsman;
  int? bowler;
  DocumentSnapshot? snapshot;
  DocumentReference? reference;
  String? documentID;

  Ball({
    this.batsman,
    this.bowler,
    this.snapshot,
    this.reference,
    this.documentID,
  });

  Ball copyWith({
    int? ballNo,
    int? batsman,
    int? bowler,
  }) {
    return Ball(
      batsman: batsman ?? this.batsman,
      bowler: bowler ?? this.bowler,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'batsman': batsman,
      'bowler': bowler,
    };
  }

  factory Ball.fromMap(Map<String, dynamic> map) {
    return Ball(
      batsman: map['batsman']?.toInt(),
      bowler: map['bowler']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Ball.fromJson(String source) => Ball.fromMap(json.decode(source));
  factory Ball.fromSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      return Ball(
        snapshot: snapshot,
        reference: snapshot.reference,
        documentID: snapshot.id,
      );
    }
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    return Ball(
      batsman: map['batsman']?.toInt(),
      bowler: map['bowler']?.toInt(),
      snapshot: snapshot,
      reference: snapshot.reference,
      documentID: snapshot.id,
    );
  }
  @override
  String toString() =>
      'Ball( batsman: $batsman, bowler: $bowler,'
      ' referance: ${reference.toString()},'
      ' documentId: $documentID, snapshot: ${snapshot.toString()} ))';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ball &&
        other.batsman == batsman &&
        other.bowler == bowler &&
        other.reference == reference &&
        other.snapshot == snapshot &&
        other.documentID == documentID;
  }

  @override
  int get hashCode =>
      batsman.hashCode ^
      bowler.hashCode ^
      reference.hashCode ^
      snapshot.hashCode ^
      documentID.hashCode;
}
