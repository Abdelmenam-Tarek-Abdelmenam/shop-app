import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/view/ui/add_deals/widgets/add_box.dart';
import 'package:shop/view/ui/add_deals/widgets/confirm_dialog.dart';
import 'package:shop/view/ui/add_deals/widgets/old_entries.dart';
import 'package:shop/view_model/add_deal_provider.dart';

import '../../../model/repository/dates_repository.dart';
import '../../resources/styles_manager.dart';

class AddDealView extends StatelessWidget {
  const AddDealView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.save_outlined),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return Dialog(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: ConfirmDialog(context.read<AddDealProvider>()),
                      //  contentPadding: const EdgeInsets.all(0.0),
                    );
                  });

              // context.read<AddEntryProvider>().save();
            },
          ),
          appBar: AppBar(
            title: Text(
                "${context.read<AddDealProvider>().deal.isEmpty ? "Add" : "Edit"} ${context.read<AddDealProvider>().isEntry ? "Entry" : "Order"}"),
            actions: [
              IconButton(
                  onPressed: () async {
                    DateTime entryDate =
                        context.read<AddDealProvider>().deal.date.parseDate;
                    entryDate = await DateRepository.selectDate(
                        context: context, initial: entryDate);
                    context.read<AddDealProvider>().changeDate(entryDate);
                  },
                  icon: const Icon(Icons.calendar_today))
            ],
          ),
          body: AbsorbPointer(
            absorbing: !context.read<AddDealProvider>().deal.isEmpty,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Text("Date: ${provider(context).deal.date}",
                      style: Theme.of(context).textTheme.headline4),
                  const SizedBox(height: 10),
                  upperBox(context),
                  ...List.generate(2, (index) => divider()),
                  Text("Add Product",
                      style: Theme.of(context).textTheme.headline4),
                  divider(),
                  Visibility(
                      visible: context.read<AddDealProvider>().deal.isEmpty,
                      child: AddBox()),
                  ...List.generate(2, (index) => divider()),
                  Text("Products",
                      style: Theme.of(context).textTheme.headline4),
                  divider(),
                  ProductsList(provider(context).products),
                ],
              ),
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
                  "${provider(context).deal.totalPrice} EGP",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            verticalLine(context),
            Column(
              children: [
                Text("Items", style: Theme.of(context).textTheme.subtitle1),
                divider(),
                Text("${provider(context).deal.items.length} item",
                    style: Theme.of(context).textTheme.subtitle1),
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

  AddDealProvider provider(BuildContext context) =>
      context.watch<AddDealProvider>();
}
