import 'package:country_codes/country_codes.dart';
import 'package:direct_message_for_whatsapp/dashboard.dart';
import 'package:direct_message_for_whatsapp/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager.initialize();
  await CountryCodes.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) =>
      runApp(ChangeNotifierProvider(
          create: (context) => DashboardModel(),
          child: const MaterialApp(
            home: Dashboard(),
          ))));
}


class SharedPreferencesManager {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    if (_prefs == null) {
      throw Exception("SharedPreferences not initialized. Call initialize() first.");
    }
    return _prefs!;
  }
}
