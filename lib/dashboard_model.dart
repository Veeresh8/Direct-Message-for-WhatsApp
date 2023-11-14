import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class DashboardModel extends ChangeNotifier {
  var selectedCountryISO = "";
  var suggestedMessage = "";
  var numberInput = "";

  void updateNumber(String number) {
    numberInput = number;
    notifyListeners();
  }

  void updateSelectedCountry(String countryISO) {
    if (!countryISO.startsWith("+")) {
      countryISO = "+$countryISO";
    }

    selectedCountryISO = countryISO;
    notifyListeners();
  }

  void updateSuggestedMessage(String message) {
    suggestedMessage = message;
    notifyListeners();
  }
}