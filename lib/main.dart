import 'package:country_codes/country_codes.dart';
import 'package:direct_message_for_whatsapp/dashboard.dart';
import 'package:direct_message_for_whatsapp/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MixpanelManager.initialize();
  await SharedPreferencesManager.initialize();
  await CountryCodes.init();
  await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ['4BE37AA0503D599DC4353E7163A676F3']));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(ChangeNotifierProvider(
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
      throw Exception(
          "SharedPreferences not initialized. Call initialize() first.");
    }
    return _prefs!;
  }
}

class MixpanelManager {
  static Mixpanel? _mixpanel;

  static Future<void> initialize() async {
    _mixpanel = await Mixpanel.init("af121ecfd8a87fba145dc3d5d3282b3f",
        trackAutomaticEvents: true);
  }

  static Mixpanel get instance {
    if (_mixpanel == null) {
      throw Exception("Mixpanel not initialized. Call initialize() first.");
    }
    return _mixpanel!;
  }
}
