import 'dart:ui';

import 'package:direct_message_for_whatsapp/dashboard_model.dart';
import 'package:direct_message_for_whatsapp/styles.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChipsWidget extends StatefulWidget {
  const ChipsWidget({Key? key}) : super(key: key);

  @override
  _ChipsWidgetState createState() => _ChipsWidgetState();
}

class _ChipsWidgetState extends State<ChipsWidget> {
  var customSuggestion = "";

  List<String> suggestions = [
    'What\'s up',
    'Hello!',
    'How are you?',
    'Be right back',
  ];

  var _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 0, 0),
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: buildSuggestions(context),
      ),
    );
  }

  List<Widget> buildSuggestions(BuildContext context) {
    return List<Widget>.generate(suggestions.length, (index) {
      if (index == 0) {
        return ActionChip(
            elevation: 3,
            padding: const EdgeInsets.all(4),
            labelPadding: const EdgeInsets.all(3),
            clipBehavior: Clip.antiAlias,
            backgroundColor: Colors.white,
            avatar: const Icon(Icons.add, color: Colors.black),
            label: Text('Add Message',
                style: buildMontserrat(context, Colors.black, FontWeight.bold,
                    Theme.of(context).textTheme.headline6)),
            onPressed: () {
              showCustomMessageBottomSheet(context);
            });
      }

      if (customSuggestion.isNotEmpty && index == 1) {
        return ChoiceChip(
            elevation: 3,
            selected: _selectedIndex == index,
            padding: const EdgeInsets.all(4),
            labelPadding: const EdgeInsets.all(3),
            clipBehavior: Clip.antiAlias,
            selectedColor: Colors.black,
            backgroundColor: Colors.white,
            labelStyle: buildMontserrat(
                context,
                _selectedIndex == index ? Colors.white : Colors.black,
                FontWeight.normal,
                Theme.of(context).textTheme.headline6),
            label: Text(customSuggestion),
            onSelected: (selected) {
              setState(() {
                if (!selected) {
                  _selectedIndex = -1;
                  Provider.of<DashboardModel>(context, listen: false).updateSuggestedMessage("");
                } else {
                  _selectedIndex = 1;
                  Provider.of<DashboardModel>(context, listen: false).updateSuggestedMessage(customSuggestion);
                }
              });
            });
      }

      return ChoiceChip(
        clipBehavior: Clip.antiAlias,
        selected: _selectedIndex == index,
        selectedColor: Colors.black,
        onSelected: (selected) {
          setState(() {
            if (_selectedIndex == index) {
              _selectedIndex = -1;
            } else {
              _selectedIndex = selected ? index : -1;
            }

            Provider.of<DashboardModel>(context, listen: false)
                .updateSuggestedMessage(
                    _selectedIndex >= 0 ? suggestions[_selectedIndex] : "");
          });
        },
        elevation: 3,
        padding: const EdgeInsets.all(4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        labelPadding: const EdgeInsets.all(3),
        labelStyle: buildMontserrat(
            context,
            _selectedIndex == index ? Colors.white : Colors.black,
            FontWeight.normal,
            Theme.of(context).textTheme.headline6),
        backgroundColor: Colors.white,
        label: Text(suggestions[index]),
      );
    });
  }

  void showCustomMessageBottomSheet(BuildContext context) {
    TextEditingController customMessageController =
        TextEditingController(text: customSuggestion);

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3 +
                  MediaQuery.of(context).viewInsets.bottom,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                    child: Text('Enter your message',
                        style: buildMontserrat(
                            context,
                            Colors.black,
                            FontWeight.bold,
                            Theme.of(context).textTheme.headline5)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(64, 32, 64, 0),
                    child: TextFormField(
                        controller: customMessageController,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.name,
                        style: buildMontserrat(
                            context,
                            Colors.black,
                            FontWeight.bold,
                            Theme.of(context).textTheme.headline6),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  customMessageController.clear();
                                },
                                icon: const Icon(Icons.cancel, color: Colors.black)),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            hintText: 'Message')),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                    child: ElevatedButton(
                        style: buildPrimaryButton(),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Done',
                            style: buildMontserrat(
                                context,
                                Colors.white,
                                FontWeight.bold,
                                Theme.of(context).textTheme.headline6))),
                  )
                ],
              ),
            ),
          );
        }).whenComplete(() {
      setState(() {
        if (customMessageController.text.isNotEmpty && !suggestions.contains(customMessageController.text)) {
          _selectedIndex = 1;
          suggestions.insert(1, customMessageController.text);
          logSuggestionToAnalytics(customMessageController.text);
        } else if (customMessageController.text.isEmpty &&
            customSuggestion.isNotEmpty) {
          suggestions.removeAt(1);
        }

        customSuggestion = customMessageController.text;
        Provider.of<DashboardModel>(context, listen: false).updateSuggestedMessage(customSuggestion);
      });
    });
  }
}

void logSuggestionToAnalytics(String customMessage) async {
  await FirebaseAnalytics.instance.logEvent(name: "custom_message_event", parameters: {
    "custom_message": customMessage
  });
}
