import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

class AppUpdateHelper {
  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability ==
          UpdateAvailability.updateAvailable) {

        // Immediate update means user must update before continuing
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      debugPrint("Update check error: $e");
    }
  }
}