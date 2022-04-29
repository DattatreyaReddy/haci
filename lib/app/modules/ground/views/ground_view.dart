import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haci/app/core/image_utils.dart';
import 'package:haci/app/data/enums/run_type.dart';
import 'package:haci/app/data/enums/team.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/ground_controller.dart';

class GroundView extends GetView<GroundController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            "Now Batting: " +
                (controller.ground.nowBatting == Team.redTeam.name
                    ? "Red Team"
                    : "Blue Team"),
            style: Get.textTheme.headline5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (!controller.showCam) {
                if (controller.initialCamera) {
                  controller.cameraController?.resumePreview();
                  controller.cameraController?.initialize().then((value) async {
                    controller.showCam = true;
                    controller.startStream();
                  });
                } else {
                  controller.initialCamera = true;
                  controller.cameraController?.initialize().then((value) async {
                    controller.showCam = true;
                    controller.startStream();
                  });
                }
              } else {
                controller.showCam = false;
                try {
                  await controller.cameraController?.stopImageStream();

                  await controller.cameraController?.pausePreview();
                } catch (e) {}
              }
            },
            icon: Icon(
              Icons.camera,
            ),
          ),
          IconButton(
            onPressed: () {
              Share.share(controller.groundId);
            },
            icon: Icon(
              Icons.share_rounded,
            ),
          ),
          // IconButton(
          //   onPressed: () async {
          //     controller.i != null
          //         ? Get.defaultDialog(
          //             content: Image.file(
          //                 File(await ImageUtils.saveImage(controller.i!))))
          //         : null;
          //   },
          //   icon: Icon(
          //     Icons.share_rounded,
          //   ),
          // ),
        ],
      ),
      body: Obx(() => Column(children: groundOrder(controller, context))),
    );
  }
}

List<Widget> groundOrder(GroundController controller, BuildContext context) {
  return <Widget>[
    Column(
      children: [
        ListTile(
          onTap: () {
            print(controller.ground.nowBatting);
            print(controller.userTeam.name);
          },
          title: Text(
            controller.ground.redPalyer == controller.userName
                ? "Red Team"
                : "Blue Team",
            textAlign: TextAlign.center,
            style: GoogleFonts.fredokaOne(
              textStyle: Get.textTheme.headline5?.copyWith(color: Colors.white),
            ),
          ),
          trailing: controller.ground.nowBatting == controller.userTeam.name
              ? ImageIcon(AssetImage("assets/images/bat.png"))
              : null,
        ),
        Obx(() => Text(
              controller.score.toString(),
              style: Get.textTheme.headline3,
            )),
      ],
    ),
    Divider(),
    Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Text(
          //   "Now Batting: "
          //   "${controller.ground.nowBatting == Team.redTeam.name ? "Red Team" : "Blue Team"}",
          //   style: Get.textTheme.headline5,
          // ),
          // Image.file(controller.cameraImage)
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
                      style: Get.textTheme.headline3,
                    ),
                    (controller.ground.ballsType == "unlimitedBalls")
                        ? Container()
                        : Text("Balls left: "
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
                      style: Get.textTheme.headline3,
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
                .sublist(max(controller.presentInnings().length - 6, 0))
                .where(
                  (element) =>
                      element.batsman != null && element.bowler != null,
                )
                .map<Widget>(
                  (e) => Chip(
                    label: Text(
                      e.batsman != e.bowler ? (e.batsman ?? 0).toString() : "W",
                    ),
                  ),
                )
                .toList(),
          ),
          !controller.lockInput
              ? controller.showCam
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 320,
                          width: 240,
                          child: controller.cameraController?.buildPreview(),
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border.all()),
                          height: 224,
                          width: 224,
                        ),
                      ],
                    )
                  : SizedBox(
                      width: context.width * .6,
                      child: Wrap(
                        alignment: WrapAlignment.center,
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
                      ),
                    )
              : Container(),
        ],
      ),
    ),
    Divider(),
    Column(
      children: [
        ListTile(
          title: Text(
            (controller.ground.redPalyer != controller.userName
                    ? "Red Team"
                    : "Blue Team") +
                " (Last)",
            textAlign: TextAlign.center,
            style: GoogleFonts.fredokaOne(
              textStyle: Get.textTheme.headline5?.copyWith(color: Colors.white),
            ),
          ),
          trailing: controller.ground.nowBatting != controller.userTeam.name
              ? ImageIcon(AssetImage("assets/images/bat.png"))
              : null,
        ),
        Text(
          (controller.nowRuntype == RunType.batsman
                  ? controller.lastBall().bowler
                  : controller.lastBall().batsman)
              .toString(),
          style: Get.textTheme.headline3,
        ),
      ],
    ),
  ];
}
