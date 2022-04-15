import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haci/app/data/providers/ground_provider.dart';

import '../../../data/ground_model.dart';

class HomeRepository {
  final GroundProvider _groundProvider = GroundProvider();
  Future<DocumentReference<Ground>> addDoc(Ground ground) =>
      _groundProvider.addDoc(ground);

  Future<Ground?> getDoc(String id) => _groundProvider.getDoc(id);

  Future<void> updateDoc(Ground ground) => _groundProvider.updateDoc(ground);
}
