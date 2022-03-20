import 'package:country_codes/country_codes.dart';
import 'package:direct_message_for_whatsapp/dashboard.dart';
import 'package:direct_message_for_whatsapp/dashboard_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CountryCodes.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) =>
      runApp(ChangeNotifierProvider(
          create: (context) => DashboardModel(),
          child: const MaterialApp(
            home: Dashboard(),
          ))));
}

