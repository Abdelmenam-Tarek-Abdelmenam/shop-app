import 'package:flutter/material.dart';
import 'package:shop/view/resources/styles_manager.dart';
import 'package:shop/view/shared/widgets/numeric_field.dart';

enum EditType { add, remove }

// ignore: must_be_immutable
class MoneyDetailsView extends StatelessWidget {
  MoneyDetailsView({Key? key}) : super(key: key);

  final TextEditingController amountController =
      TextEditingController(text: "0");
  EditType editType = EditType.add;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Money Box"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              upperBox(context),
              divider(),
              divider(),
              Text("Edit Money", style: Theme.of(context).textTheme.headline4),
              divider(),
              editBox(context),
              Text("Old Edits", style: Theme.of(context).textTheme.headline4),
            ],
          ),
        ));
  }

  Widget upperBox(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            boxShadow: StyleManager.shadow,
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: StyleManager.border),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  "Money",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                divider(),
                Text(
                  "850 EGP",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                divider(),
                Text(
                  "Revenue 75 EGP",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
            verticalLine(context),
            Column(
              children: [
                Text("Today", style: Theme.of(context).textTheme.subtitle1),
                divider(),
                Text("500 EGP", style: Theme.of(context).textTheme.subtitle1),
                divider(),
                Text(
                  "75 EGP",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ],
        ),
      );

  Widget editBox(BuildContext context) => Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow: StyleManager.shadow,
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: StyleManager.border),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: NumericField(amountController)),
              Expanded(
                child: _radioButtons(context),
              )
            ],
          )
        ],
      ));

  Widget _radioButtons(BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 20,
                  child: Radio<EditType>(
                      value: editType,
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.red),
                      groupValue: EditType.add,
                      onChanged: (val) {
                        setState(() {
                          editType = EditType.add;
                        });
                      }),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  "Add",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 20,
                  child: Radio<EditType>(
                      value: editType,
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue),
                      groupValue: EditType.remove,
                      onChanged: (val) {
                        setState(() {
                          editType = EditType.remove;
                        });
                      }),
                ),
                const SizedBox(
                  width: 15,
                ),
                // ignore: prefer_const_constructors
                Text(
                  "Remove",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ]),
            ],
          ));

  Widget verticalLine(BuildContext context) => Container(
        height: 60.0,
        width: 1.0,
        color: Theme.of(context).colorScheme.onPrimary,
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      );

  Widget divider() => const SizedBox(
        height: 5.0,
      );
}
