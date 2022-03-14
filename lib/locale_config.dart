import 'package:country_codes/country_codes.dart';

class LocaleConfig {

  static CountryDetails getLocale() {
    return CountryCodes.detailsForLocale();
  }
}