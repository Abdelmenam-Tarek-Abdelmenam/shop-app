import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/view/resources/styles_manager.dart';
import 'package:shop/view/ui/money_details/widgets/edit_box.dart';
import 'package:shop/view/ui/money_details/widgets/old_edits.dart';
import 'package:shop/view_model/app_provider.dart';

class MoneyDetailsView extends StatelessWidget {
  MoneyDetailsView({Key? key}) : super(key: key);
  final TextEditingController amountController =
      TextEditingController(text: "10");
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Money Box"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                upperBox(context),
                ...List.generate(2, (index) => divider()),
                Text("Edit Money",
                    style: Theme.of(context).textTheme.headline4),
                divider(),
                EditBox(notesController, amountController),
                ...List.generate(2, (index) => divider()),
                Text("Old Edits", style: Theme.of(context).textTheme.headline4),
                divider(),
                const OldEditList(),
              ],
            ),
          )),
    );
  }

  Widget upperBox(BuildContext context) => Hero(
        tag: "MoneyBox",
        child: Container(
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
                  Selector<AppProvider, double>(
                    selector: (_, val) => val.moneyInBox,
                    builder: (context, val, _) => Text(
                      "Revenue ${val == -1 ? '-' : val} EGP",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  divider(),
                  Selector<AppProvider, int>(
                    selector: (_, val) => val.revenue,
                    builder: (context, val, _) => Text(
                      "Revenue ${val == -1 ? '-' : val} EGP",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ],
              ),
              verticalLine(context),
              Column(
                children: [
                  Text("Deals", style: Theme.of(context).textTheme.subtitle1),
                  divider(),
                  Selector<AppProvider, int>(
                    selector: (_, val) => val.orders,
                    builder: (context, val, _) => Text(
                      "Orders ${val == -1 ? '-' : val}",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  divider(),
                  Selector<AppProvider, int>(
                    selector: (_, val) => val.entries,
                    builder: (context, val, _) => Text(
                      "Entry ${val == -1 ? '-' : val}",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

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
