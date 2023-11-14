import 'package:direct_message_for_whatsapp/main.dart';
import 'package:flutter/cupertino.dart';

class DashboardModel extends ChangeNotifier {
  var selectedCountryISO = "";
  var suggestedMessage = "";
  var numberInput = "";

  void updateNumber(String number) {
    numberInput = number;
    notifyListeners();
  }

  void updateSelectedCountry(String countryISO, String name) {
    if (!countryISO.startsWith("+")) {
      countryISO = "+$countryISO";
    }

    selectedCountryISO = countryISO;

    MixpanelManager.instance.track("Country: $selectedCountryISO | $name");

    notifyListeners();
  }

  void updateSuggestedMessage(String message) {
    suggestedMessage = message;
    notifyListeners();
  }
}