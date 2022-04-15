import 'package:haci/app/data/ball_model.dart';
import 'package:haci/app/data/providers/ball_provider.dart';
import 'package:haci/app/data/providers/ground_provider.dart';

import '../../../data/enums/run_type.dart';
import '../../../data/enums/team.dart';
import '../../../data/ground_model.dart';

class GroundReposiory {
  final GroundProvider _groundProvider = GroundProvider();
  final BallProvider _ballProvider = BallProvider();
  Stream<Ground?> groundSnapshotsForId(String id) {
    return _groundProvider.groundSnapshotsForId(id);
  }

  Future<void> addBall({
    required String groundId,
    required Team nowBatting,
    required RunType runType,
    required int score,
  }) =>
      _ballProvider.addDoc(
        groundId: groundId,
        nowBatting: nowBatting,
        runType: runType,
        score: score,
      );

  Stream<List<Ball>> ballsSnapshotsForTeam({
    required String groundId,
    required Team teamName,
  }) =>
      _ballProvider.ballsSnapshotsForTeam(
        groundId: groundId,
        teamName: teamName,
      );
  Future<void> clearBalls(String groundId) =>
      _ballProvider.clearBalls(groundId);
}
