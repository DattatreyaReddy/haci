import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haci/app/core/const.dart';
import 'package:haci/app/data/enums/balls_type.dart';
import 'package:haci/app/data/enums/team.dart';
import 'package:haci/app/data/ground_model.dart';
import 'package:haci/app/modules/home/repository/home_repository.dart';
import 'package:haci/app/routes/app_pages.dart';

import '../../../../main.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final HomeRepository repository = HomeRepository();
  final TextEditingController userName = TextEditingController();
  final TextEditingController groundId = TextEditingController();
  final TextEditingController noOfballs = TextEditingController();
  final LocalStorageService localController = Get.find<LocalStorageService>();
  final Rx<BallsType> _ballsType = BallsType.limitedBalls.obs;
  BallsType get ballsType => _ballsType.value;
  set ballsType(BallsType value) => _ballsType.value = value;

  Future<void> createGround() async {
    if (userName.text.isEmpty) {
      Get.snackbar("Empty User Name", "User name Can't be Empty");
      return;
    }
    localController.userName = userName.text.toLowerCase();
    DocumentReference<Ground> reference = await repository.addDoc(
      Ground(
        balls: ballsType == BallsType.limitedBalls
            ? int.parse(noOfballs.text)
            : int64MaxValue,
        ballsType: ballsType.name,
        redPalyer: userName.text.toLowerCase(),
        nowBatting: Team.redTeam.name,
        lastBall: 0,
      ),
    );
    Get.toNamed(
        "/${userName.text.toLowerCase()}" + Routes.ground + "/${reference.id}");
  }

  Future<void> joinGround() async {
    if (userName.text.isEmpty || groundId.text.isEmpty) {
      Get.snackbar("Empty User Name", "User name Can't be Empty");
      return;
    }
    localController.userName = userName.text;
    Ground? ground = await repository.getDoc(groundId.text);
    if (ground != null && ground.documentID != null) {
      if (ground.redPalyer != userName.text) {
        await repository.updateDoc(
            ground.copyWith(bluePalyer: userName.text.toLowerCase()));
      }
      Get.toNamed(
        "/${userName.text.toLowerCase()}" +
            Routes.ground +
            "/${ground.documentID}",
      );
    }
  }

  @override
  void onInit() {
    userName.text = localController.userName;
    noOfballs.text = "5";
    super.onInit();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {}
}
