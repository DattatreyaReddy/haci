import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

import 'firebase_options.dart';

late final List<CameraDescription> cameras;
class LocalStorageService extends GetxService {
  final box = GetStorage();

  String get userName => box.read("userName") ?? "";
  set userName(String val) => box.write("userName", val);
}

Future<void> main() async {
    try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    // logError(e.code, e.description);
  }
  await GetStorage.init();
  Get.put(LocalStorageService());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: ThemeData(
        colorScheme: ColorScheme.light(),
        iconTheme: IconThemeData(
          color: ColorScheme.light().primary,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(),
        iconTheme: IconThemeData(
          color: ColorScheme.dark().primary,
        ),
      ),
      themeMode: ThemeMode.dark,
    ),
  );
}
