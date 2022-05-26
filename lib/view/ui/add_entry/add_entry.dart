import 'package:flutter/material.dart';
import 'package:shop/model/module/deals.dart';

import '../../../model/repository/dates_repository.dart';
import '../../resources/styles_manager.dart';
import 'widgets/add_box.dart';
import 'widgets/old_entries.dart';

class AddEntryView extends StatelessWidget {
  const AddEntryView(this.entry, {Key? key}) : super(key: key);
  final EntryModel? entry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Money Box"),
            actions: [
              IconButton(
                  onPressed: () {
                    DateRepository.selectDate(
                        context: context, initial: DateTime.now());
                  },
                  icon: const Icon(Icons.calendar_today))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Text("Last Updated: ${DateTime.now().formatDate}",
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 10),
                upperBox(context),
                ...List.generate(2, (index) => divider()),
                Text("Edit Money",
                    style: Theme.of(context).textTheme.headline4),
                divider(),
                AddBox(),
                ...List.generate(2, (index) => divider()),
                Text("Old Edits", style: Theme.of(context).textTheme.headline4),
                divider(),
                OldEntryList(),
              ],
            ),
          )),
    );
  }

  Widget upperBox(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            boxShadow: StyleManager.shadow,
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: StyleManager.border),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  "Total Money",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                divider(),
                Text(
                  "850 EGP",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            verticalLine(context),
            Column(
              children: [
                Text("Items", style: Theme.of(context).textTheme.subtitle1),
                divider(),
                Text("50 item", style: Theme.of(context).textTheme.subtitle1),
                divider(),
              ],
            ),
          ],
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
