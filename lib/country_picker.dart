import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:direct_message_for_whatsapp/dashboard_model.dart';
import 'package:direct_message_for_whatsapp/main.dart';
import 'package:direct_message_for_whatsapp/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryPicker extends StatefulWidget {
  const CountryPicker({Key? key}) : super(key: key);

  @override
  _CountryPickerState createState() => _CountryPickerState();
}

getStringValuesSF() async {
  SharedPreferences prefs = SharedPreferencesManager.instance;
  String? stringValue = prefs.getString('selected_country');
  return stringValue;
}

addStringToSF(String value) async {
  SharedPreferences prefs = SharedPreferencesManager.instance;
  prefs.setString('selected_country', value);
}

class _CountryPickerState extends State<CountryPicker> {
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    SharedPreferences prefs = SharedPreferencesManager.instance;
    String? selectedCountry = prefs.getString('selected_country');

    if (selectedCountry != null) {
      _selectedCountry =
          CountryPickerUtils.getCountryByIsoCode(selectedCountry);
    } else {
      _selectedCountry = CountryPickerUtils.getCountryByIsoCode("IN");
    }

    var countryByIsoCode = CountryPickerUtils.getCountryByIsoCode(_selectedCountry.isoCode);

    Provider.of<DashboardModel>(context, listen: false)
        .updateSelectedCountry(countryByIsoCode.phoneCode, countryByIsoCode.name);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        _openCountryPickerDialog(context);
      },
      title: _buildDialogItem(_selectedCountry, context, true),
    );
  }

  void _openCountryPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.black),
          child: CountryPickerDialog(
              titlePadding: const EdgeInsets.all(8.0),
              searchInputDecoration:
                  const InputDecoration(hintText: 'Search...'),
              isSearchable: true,
              title: Text(
                'Select your country',
                style: buildMontserrat(context, Colors.black, FontWeight.bold,
                    Theme.of(context).textTheme.headline6),
              ),
              onValuePicked: (Country country) {
                if (mounted) {
                  setState(() {
                    _selectedCountry = country;
                    addStringToSF(country.isoCode.replaceAll("+", ""));
                    Provider.of<DashboardModel>(context, listen: false)
                        .updateSelectedCountry(country.phoneCode, country.name);
                  });
                }
              },
              priorityList: [
                CountryPickerUtils.getCountryByIsoCode('IN'),
                CountryPickerUtils.getCountryByIsoCode('US'),
                CountryPickerUtils.getCountryByIsoCode('GB-ENG'),
              ],
              itemBuilder: (country) => _buildDialogItem(country, context))),
    );
  }

  Widget _buildDialogItem(Country country, BuildContext context,
      [bool isForBuild = false]) {
    return Row(
      children: [
        CountryPickerUtils.getDefaultFlagImage(country),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
              text: country.phoneCode,
              style: buildMontserrat(
                context,
                Colors.black,
                FontWeight.bold,
                Theme.of(context).textTheme.headline6,
              ),
              children: [
                TextSpan(
                    text: ' ${country.isoCode}',
                    style: buildMontserrat(
                      context,
                      Colors.black,
                      FontWeight.normal,
                      Theme.of(context).textTheme.headline6,
                    )),
              ]),
        ),
        if (isForBuild) const Icon(Icons.arrow_drop_down, color: Colors.black)
      ],
    );
  }
}
