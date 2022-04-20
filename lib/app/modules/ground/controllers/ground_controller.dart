import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:haci/app/data/ball_model.dart';
import 'package:haci/app/data/enums/run_type.dart';
import 'package:haci/app/data/enums/team.dart';
import 'package:haci/app/data/ground_model.dart';
import 'package:haci/app/modules/ground/repository/ground_repository.dart';
import 'package:haci/main.dart';

class GroundController extends GetxController {
  //TODO: Implement GroundController

  CameraController? cameraController;
  final GroundReposiory reposiory = GroundReposiory();
  late final String groundId;
  late final String userName;

  CameraImage? cameraImage;
  final RxInt _score = 0.obs;
  int get score => _score.value;
  void scoreUpdate(int value) {
    _score.value = value;
    _score.refresh();
  }

  final Rx<Ground> _ground = Ground().obs;
  Ground get ground {
    return _ground.value;
  }

  set ground(Ground value) => _ground.value = value;

  final RxList<Ball> _redBalls = <Ball>[].obs;
  List<Ball> get redBalls => _redBalls;
  set redBalls(List<Ball> value) => _redBalls.value = value;

  final RxList<Ball> _blueBalls = <Ball>[].obs;
  List<Ball> get blueBalls => _blueBalls;
  set blueBalls(List<Ball> value) => _blueBalls.value = value;

  final RxBool _lockInput = false.obs;
  bool get lockInput => _lockInput.value;
  set lockInput(bool value) => _lockInput.value = value;

  final RxBool _showCam = false.obs;
  bool get showCam => _showCam.value;
  set showCam(bool value) => _showCam.value = value;

  bool get isSecondInnings =>
      ground.nowBatting == Team.blueTeam.name ||
      (ground.nowBatting == Team.redTeam.name && blueBalls.isNotEmpty);

  Team get userTeam =>
      ground.redPalyer == userName ? Team.redTeam : Team.blueTeam;

  RunType get nowRuntype =>
      ground.nowBatting == userTeam.name ? RunType.batsman : RunType.bowler;

  int get redScore {
    int score = 0;
    for (Ball i in redBalls) {
      if (i.batsman != null && i.bowler != null && i.bowler != i.batsman) {
        score += i.batsman!;
      }
    }
    return score;
  }

  int get blueScore {
    int score = 0;
    for (Ball i in blueBalls) {
      if (i.batsman != null && i.bowler != null && i.bowler != i.batsman) {
        score += i.batsman!;
      }
    }
    return score;
  }

  Future<void> addBall() async {
    lockInput = true;
    await reposiory.addBall(
      groundId: groundId,
      nowBatting: Team.values
          .firstWhere((element) => element.name == ground.nowBatting),
      runType: nowRuntype,
      score: score,
    );
  }

  Ball lastBall() {
    return presentInnings().lastWhere(
        (element) => element.batsman != null && element.bowler != null,
        orElse: () => Ball(bowler: 0, batsman: 0));
  }

  List<Ball> presentInnings() =>
      ground.nowBatting == Team.redTeam.name ? redBalls : blueBalls;

  @override
  void onInit() {
    groundId = Get.parameters["groundId"]!;
    userName = Get.parameters["userName"]!;
    _ground.bindStream(reposiory.groundSnapshotsForId(groundId).map(
          (event) => event ?? ground,
        ));
    _redBalls.bindStream(reposiory.ballsSnapshotsForTeam(
      groundId: groundId,
      teamName: Team.redTeam,
    ));

    _blueBalls.bindStream(reposiory.ballsSnapshotsForTeam(
      groundId: groundId,
      teamName: Team.blueTeam,
    ));
    _ground.listen((p0) {
      lockInput = false;
    });
    _blueBalls.listen(
      (ball) {
        if (isSecondInnings) {
          if (blueScore > redScore) {
            Get.defaultDialog(
              title: "Game Over",
              middleText: "Blue Team Won",
            );
            reposiory.clearBalls(groundId);
            return;
          }
          if ((ball.any((i) =>
                  i.batsman != null &&
                  i.bowler != null &&
                  i.bowler == i.batsman) ||
              (ground.balls! ==
                  ball
                      .where((i) => i.batsman != null && i.bowler != null)
                      .toList()
                      .length))) {
            if (blueScore == redScore) {
              Get.defaultDialog(title: "Game Over", middleText: "IT'S A DRAW");
            } else {
              Get.defaultDialog(
                title: "Game Over",
                middleText: (blueScore > redScore
                        ? teamAsString(Team.blueTeam)
                        : teamAsString(Team.redTeam)) +
                    " Won",
              );
            }
            reposiory.clearBalls(groundId);
          }
        }
      },
    );
    debounce(
      _score,
      (val) {
        print(val);
        addBall();
      },
      time: 1.seconds,
    );
    super.onInit();
  }

  @override
  void onReady() async {
    cameraController =
        CameraController(cameras[1], ResolutionPreset.low, enableAudio: false);
    print(cameraController);
    super.onReady();
  }

  @override
  void onClose() {
    cameraController?.dispose();
  }
}
