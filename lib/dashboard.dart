import 'dart:ui';

import 'package:direct_message_for_whatsapp/country_picker.dart';
import 'package:direct_message_for_whatsapp/dashboard_model.dart';
import 'package:direct_message_for_whatsapp/number_input.dart';
import 'package:direct_message_for_whatsapp/styles.dart';
import 'package:direct_message_for_whatsapp/suggestion_chips.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DashboardModel? dashboardModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(60),
                  child: Icon(Icons.double_arrow, color: Colors.black, size: 50),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, 100),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Start WhatsApp chat without saving new contact.',
                      textAlign: TextAlign.center,
                      style: buildMontserrat(
                          context,
                          Colors.black,
                          FontWeight.normal,
                          Theme.of(context).textTheme.headline6)),
                ),
              ),
              Transform.translate(
                offset: const Offset(80, 180),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: GestureDetector(
                    onTap: () {
                      launchHelp();
                    },
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Icon(Icons.play_circle_filled_sharp, color: Colors.black,),
                        const SizedBox(width: 5),
                        Text('How it works?',
                            textAlign: TextAlign.center,
                            style: buildMontserratUnderline(
                                context,
                                Colors.black,
                                FontWeight.bold,
                                Theme.of(context).textTheme.headline6)),
                      ],
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(40, 600),
                child: ElevatedButton.icon(
                  style: buildPrimaryButton(),
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: Text('Open in WhatsApp',
                      style: buildMontserrat(
                          context,
                          Colors.white,
                          FontWeight.bold,
                          Theme.of(context).textTheme.headline6)),
                  onPressed: () {
                    _launchWithNumber(context);
                  },
                ),
              ),
              Transform.translate(
                offset: const Offset(24, 250),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 250,
                      child: Card(
                        elevation: 4,
                        color: Colors.white70,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.black, width: 2.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Container(
                                margin:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                child: const CountryPicker()),
                            Container(
                              margin:
                                  const EdgeInsets.fromLTRB(32, 0, 16, 30),
                              child: const NumberInput(),
                            ),
                            const SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ChipsWidget(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
      createAlertDialog(context, "Phone number cannot be empty.");
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

    await FirebaseAnalytics.instance.logEvent(name: "message_event", parameters: {
      "number": number,
      "message": message,
      "country": countryISO
    });
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
    if (!await launch("https://www.youtube.com/watch?v=j3HiVidc5IQ")) {
        createAlertDialog(context, "Failed to open app help hint!");
    }
  }
}
