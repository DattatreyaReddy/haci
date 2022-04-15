import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haci/app/data/enums/balls_type.dart';
import 'package:haci/app/widgets/numerical_range_formatter.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/bg.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "HaCi",
              textAlign: TextAlign.center,
              style: GoogleFonts.specialElite(
                  textStyle:
                      Get.textTheme.headline1?.copyWith(color: Colors.white)),
              // style: ,
            ),
            Text(
              "ONLINE",
              textAlign: TextAlign.center,
              style: GoogleFonts.frederickaTheGreat(
                textStyle: Get.textTheme.headline2
                    ?.copyWith(color: Colors.yellowAccent),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Play Hand Cricket with your friends.",
                textAlign: TextAlign.center,
                style: GoogleFonts.fredokaOne(
                  textStyle:
                      Get.textTheme.headline5?.copyWith(color: Colors.white),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 450),
              child: TextField(
                controller: controller.userName,
                cursorColor: Colors.yellow,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 450),
              child: Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ),
            Obx(() => DropdownButton<BallsType>(
                  value: controller.ballsType,
                  borderRadius: BorderRadius.circular(20),
                  underline: Container(),
                  items: [
                    DropdownMenuItem(
                      value: BallsType.limitedBalls,
                      child: Text("Limited Overs"),
                    ),
                    DropdownMenuItem(
                      value: BallsType.unlimitedBalls,
                      child: Text("Unlimited Overs"),
                    ),
                  ],
                  onChanged: (item) {
                    controller.ballsType = item!;
                  },
                )),
            Obx(() => controller.ballsType == BallsType.limitedBalls
                ? Container(
                  padding: EdgeInsets.all(20),
                    constraints: BoxConstraints(maxWidth: 450),
                    child: TextField(
                      controller: controller.noOfballs,
                      cursorColor: Colors.yellow,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        NumericalRangeFormatter(min: 1, max: 1000)
                      ],
                      decoration: InputDecoration(
                        hintText: "Enter no of overs",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  )
                : Container()),
            ElevatedButton(
              onPressed: () => controller.createGround(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Create Ground",
                  style: Get.textTheme.headline5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            ListTile(
              title: Text(
                "OR",
                textAlign: TextAlign.center,
                style: Get.textTheme.headline5?.copyWith(color: Colors.white),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 450),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 280),
                    child: TextField(
                      controller: controller.groundId,
                      cursorColor: Colors.yellow,
                      decoration: InputDecoration(
                        hintText: "Enter the Ground ID",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => controller.joinGround(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Join Ground",
                        style: Get.textTheme.headline5
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.yellow.shade100,
                      Colors.orange,
                    ],
                  ),
                ),
                constraints: BoxConstraints(maxWidth: 450),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "How To Play:",
                      style: Get.textTheme.subtitle1?.copyWith(
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
