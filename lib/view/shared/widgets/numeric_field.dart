import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NumericField extends StatelessWidget {
  final TextEditingController controller;
  final String? title;
  const NumericField(this.controller, {this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value!.isEmpty) {
            return "cannot be empty";
          } else {
            int isDigitsOnly = int.tryParse(value) ?? 0;
            return isDigitsOnly == 0 ? 'Integer only' : null;
          }
        },
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            labelText: title,
            labelStyle: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            contentPadding: EdgeInsets.zero,
            prefixIcon: IconButton(
              icon: Icon(
                FontAwesomeIcons.minus,
                size: 20,
                color: Colors.grey.withOpacity(0.5),
              ),
              onPressed: () {
                int d = int.parse(controller.text);
                if (d > 1) {
                  d--;
                  controller.text = "$d";
                }
              },
            ),
            suffixIcon: IconButton(
              icon: Icon(
                FontAwesomeIcons.plus,
                size: 20,
                color: Colors.grey.withOpacity(0.5),
              ),
              onPressed: () {
                int d = int.parse(controller.text);
                d++;
                controller.text = "$d";
              },
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.4), width: 2.0),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }
}
