import 'package:direct_message_for_whatsapp/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dashboard_model.dart';

class NumberInput extends StatefulWidget {
  const NumberInput({Key? key}) : super(key: key);

  @override
  _NumberInputState createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (input) {
        Provider.of<DashboardModel>(context, listen: false).updateNumber(input);
      },
      controller: numberController,
      keyboardType: TextInputType.number,
      style: buildMontserrat(context, Colors.black, FontWeight.bold,
          Theme.of(context).textTheme.headline5),
      decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                numberController.clear();
                Provider.of<DashboardModel>(context, listen: false).updateNumber("");
              },
              icon: const Icon(Icons.cancel, color: Colors.black)),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          hintText: 'Enter Number'),
    );
  }
}
