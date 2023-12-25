import 'dart:io';
import 'dart:ui';

import 'package:direct_message_for_whatsapp/country_picker.dart';
import 'package:direct_message_for_whatsapp/dashboard_model.dart';
import 'package:direct_message_for_whatsapp/number_input.dart';
import 'package:direct_message_for_whatsapp/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DashboardModel? dashboardModel;
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  _initBannerAd() {
    final adUnitId = Platform.isAndroid
        ? 'ca-app-pub-2664611290118817/4695190804' //real ad-unit for Android
        : 'ca-app-pub-2664611290118817/8459175997'; //real ad-unit for iOS

    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnitId,
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isAdLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, error) {
              MixpanelManager.instance.track("Ad load failed: $error");
            },
            onAdImpression: (ad) {
              MixpanelManager.instance.track("Ad impression: $ad");
            },
            onAdClicked: (ad) {
              MixpanelManager.instance.track("Ad clicked: $ad");
            }
        ),
        request: const AdRequest());
    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Icon(Icons.double_arrow, color: Colors.black, size: 50),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Start WhatsApp chat without saving new contact.',
                  textAlign: TextAlign.center,
                  style: buildMontserrat(
                    context,
                    Colors.black,
                    FontWeight.bold,
                    Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: GestureDetector(
                  onTap: () {
                    launchHelp();
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(Icons.play_circle_filled_sharp, color: Colors.black),
                      const SizedBox(width: 5),
                      Text(
                        'How it works?',
                        textAlign: TextAlign.center,
                        style: buildMontserratUnderline(
                          context,
                          Colors.black,
                          FontWeight.normal,
                          Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 64),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                height: 200,
                child: Card(
                  elevation: 4,
                  color: Colors.white70,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 2.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: CountryPicker(),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(32, 0, 16, 30),
                        child: NumberInput(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: buildPrimaryButton(),
                icon: const Icon(Icons.send, color: Colors.white),
                label: Text(
                  'Direct Message',
                  style: buildMontserrat(
                    context,
                    Colors.white,
                    FontWeight.bold,
                    Theme.of(context).textTheme.headline6,
                  ),
                ),
                onPressed: () {
                  _launchWithNumber(context);
                },
              ),
              const Spacer(),
              if (_isAdLoaded)
                SizedBox(
                  height: _bannerAd.size.height.toDouble(),
                  width: _bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              Consumer<DashboardModel>(
                builder: (context, model, child) {
                  dashboardModel = model;
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchWithNumber(BuildContext context) async {
    var number = dashboardModel?.numberInput;
    var message = dashboardModel?.suggestedMessage ?? "";
    var countryISO = dashboardModel?.selectedCountryISO;

    if (number?.isEmpty == true) {
      createAlertDialog(context, "Number cannot be empty");
      return;
    }

    String url;

    if (message.isNotEmpty) {
      url = "https://wa.me/$countryISO$number?text=$message";
    } else {
      url = "https://wa.me/$countryISO$number?text=%20";
    }

    if (!await launch(url)) {
      createAlertDialog(context, "Failed to send message");
    }

    MixpanelManager.instance.track("Opened WhatsApp: $number");
  }

  void createAlertDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              title: Text(message),
              titleTextStyle: buildMontserrat(context, Colors.black,
                  FontWeight.bold, Theme.of(context).textTheme.headline6),
              actionsOverflowButtonSpacing: 20,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "OK",
                      style: buildMontserrat(
                          context,
                          Colors.white,
                          FontWeight.bold,
                          Theme.of(context).textTheme.bodySmall),
                    ),
                    style: buildDialogButton(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void launchHelp() async {
    MixpanelManager.instance.track("Opened help hint");

    if (!await launch("https://www.youtube.com/shorts/-diZAn3_KvU")) {
      createAlertDialog(context, "Failed to open app help hint!");
    }
  }
}
