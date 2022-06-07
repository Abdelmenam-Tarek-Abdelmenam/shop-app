import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/module/deals.dart';

import '../../../model/repository/dates_repository.dart';
import '../../../view_model/add_entry_provider.dart';
import '../../resources/styles_manager.dart';
import 'widgets/add_box.dart';
import 'widgets/old_entries.dart';

class AddDealView extends StatelessWidget {
  const AddDealView({this.entry, Key? key}) : super(key: key);
  final EntryModel? entry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: ChangeNotifierProvider(
        create: (_) => AddEntryProvider(entry ?? EntryModel.empty()),
        child: Scaffold(
            appBar: AppBar(
              title: Text("${entry == null ? "Add" : "Edit"} entry"),
              actions: [
                IconButton(
                    onPressed: () async {
                      DateTime entryDate =
                          context.read<AddEntryProvider>().entry.date.parseDate;
                      entryDate = await DateRepository.selectDate(
                          context: context, initial: entryDate);
                      context.read<AddEntryProvider>().changeDate(entryDate);
                    },
                    icon: const Icon(Icons.calendar_today))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Text("Date: ${context.watch()<AddEntryProvider>().date}",
                      style: Theme.of(context).textTheme.headline4),
                  const SizedBox(height: 10),
                  upperBox(context),
                  ...List.generate(2, (index) => divider()),
                  Text("Add Product",
                      style: Theme.of(context).textTheme.headline4),
                  divider(),
                  AddBox(),
                  ...List.generate(2, (index) => divider()),
                  Text("Products",
                      style: Theme.of(context).textTheme.headline4),
                  divider(),
                  Selector<AddEntryProvider, List<DealAddProduct>>(
                      selector: (_, val) => val.products,
                      shouldRebuild: (_, __) => true,
                      builder: (context, val, _) => ProductsList(val)),
                ],
              ),
            )),
      ),
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
