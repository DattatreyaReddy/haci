import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haci/app/data/ball_model.dart';
import 'package:haci/app/data/enums/run_type.dart';
import 'package:haci/app/data/enums/team.dart';

import '../../../../main.dart';
import '../controllers/ground_controller.dart';

class GroundView extends GetView<GroundController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Row(children: groundOrder(controller))),
    );
  }
}

List<Widget> groundOrder(GroundController controller) {
  return <Widget>[
    Expanded(
      child: Column(
        children: [
          Text(
            controller.ground.redPalyer == controller.userName
                ? "Red Team"
                : "Blue Team",
            textAlign: TextAlign.center,
            style: GoogleFonts.fredokaOne(
              textStyle: Get.textTheme.headline5?.copyWith(color: Colors.white),
            ),
          ),
          Obx(() => Text(
                controller.score.toString(),
                style: Get.textTheme.headline1,
              )),
          Obx(() => SwitchListTile(
                value: controller.showCam,
                onChanged: (val) {
                  if (val) {
                    controller.cameraController = CameraController(
                        cameras[0], ResolutionPreset.max,
                        enableAudio: false);
                    controller.cameraController
                        ?.initialize()
                        .then((value) => controller.showCam = true);
                  } else {
                    controller.showCam = false;
                  }
                },
                title: Text("Camera"),
              )),
          !controller.lockInput
              ? controller.showCam
                  ? SizedBox(
                      height: 200,
                      width: 200,
                      child: controller.cameraController?.buildPreview())
                  : Wrap(
                      children: [0, 1, 2, 3, 4, 5, 6]
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.scoreUpdate(e);
                                },
                                child: Text("$e"),
                              ),
                            ),
                          )
                          .toList(),
                    )
              : Container(),
        ],
      ),
    ),
    VerticalDivider(),
    Expanded(
        child: Column(
      children: [
        Text(
          "Now Batting: "
          "${controller.ground.nowBatting == Team.redTeam.name ? "Red Team" : "Blue Team"}",
          style: Get.textTheme.headline5,
        ),
        controller.isSecondInnings
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Blue Team Score",
                    style: Get.textTheme.headline5,
                  ),
                  Text(
                    controller.blueScore.toString(),
                    style: Get.textTheme.headline1,
                  ),
                  Text("Balls left: "
                      "${controller.ground.balls! - controller.blueBalls.length}"),
                  Text("First Innings: ${controller.redScore}")
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Red Team Score",
                    style: Get.textTheme.headline5,
                  ),
                  Text(
                    controller.redScore.toString(),
                    style: Get.textTheme.headline1,
                  ),
                  Text(
                    "Balls left: "
                    "${(controller.ground.balls ?? 0) - (controller.ground.lastBall ?? 0)}",
                  ),
                ],
              ),
        Wrap(
          children: controller
              .presentInnings()
              .sublist(max(controller.presentInnings().length - 2, 0))
              .where(
                (element) => element.batsman != null && element.bowler != null,
              )
              .map<Widget>(
                (e) => Chip(
                  label: Text(
                    e.batsman != e.bowler ? (e.batsman ?? 0).toString() : "W",
                  ),
                ),
              )
              .toList(),
        )
      ],
    )),
    VerticalDivider(),
    Expanded(
      child: Column(
        children: [
          Text(
            controller.ground.redPalyer != controller.userName
                ? "Red Team"
                : "Blue Team",
            textAlign: TextAlign.center,
            style: GoogleFonts.fredokaOne(
              textStyle: Get.textTheme.headline5?.copyWith(color: Colors.white),
            ),
          ),
          Text(
            (controller.nowRuntype == RunType.batsman
                    ? controller.lastBall().bowler
                    : controller.lastBall().batsman)
                .toString(),
            style: Get.textTheme.headline1,
          ),
          Text(
            "Previous",
            style: Get.textTheme.headline5,
          ),
        ],
      ),
    ),
  ];
}
