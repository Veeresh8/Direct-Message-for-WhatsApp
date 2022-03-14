import 'package:flutter/cupertino.dart';

class DashboardModel extends ChangeNotifier {
  var selectedCountryISO = "";
  var suggestedMessage = "";
  var numberInput = "";

  void updateNumber(String number) {
    print("updateNumber: $number");

    numberInput = number;
    notifyListeners();
  }

  void updateSelectedCountry(String countryISO) {
    print("updateSelectedCountry: $countryISO");

    selectedCountryISO = countryISO;
    notifyListeners();
  }

  void updateSuggestedMessage(String message) {
    print("updateSuggestedMessage: $message");

    suggestedMessage = message;
    notifyListeners();
  }
}