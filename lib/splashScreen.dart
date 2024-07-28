// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jot_spot/showData.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (_) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(
                  child: Image(
                    // width: 40,
                      image: AssetImage(
                        "images/note.png",
                      )),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 90,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey,
                    borderRadius: BorderRadius.circular(10.0),
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.pink),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Future.delayed(const Duration(seconds: 5), () {
      Get.offAll(
            () => const ShowData(),
      );
    });
  }

  @override
  void onClose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.onClose();
  }
}