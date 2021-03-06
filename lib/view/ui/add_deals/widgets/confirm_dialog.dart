import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/view/shared/widgets/form_field.dart';
import 'package:shop/view_model/add_deal_provider.dart';

import '../../../../model/module/deals.dart';
import '../../../../view_model/app_provider.dart';
import '../../../resources/styles_manager.dart';
import '../../../shared/widgets/numeric_field.dart';

// ignore: must_be_immutable
class ConfirmDialog extends StatelessWidget {
  final AddDealProvider provider;
  ConfirmDialog(this.provider, {Key? key}) : super(key: key);

  late final TextEditingController _moneyController =
      TextEditingController(text: provider.deal.totalPrice.toString());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: StyleManager.border),
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${provider.isEntry ? "Entry" : "Order"} confirmation",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            child: DefaultFormField(
                border: true,
                controller: TextEditingController(text: provider.deal.name),
                onChanged: (value) {
                  provider.deal.name = value;
                },
                title: provider.isEntry ? "Supplier name" : "Buyer name",
                prefix: Icons.factory),
          ),
          _radioButtons(),
          Row(
            children: [
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: StyleManager.border,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      child:
                          NumericField(_moneyController, title: 'Paid Money'))),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Text("Rest of money",
                        style: Theme.of(context).textTheme.subtitle1),
                    const Divider(
                      height: 1,
                    ),
                    ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _moneyController,
                        builder: (context, value, _) {
                          double rest = (double.tryParse(value.text) ?? 0) -
                              provider.deal.totalPrice;
                          return Text(
                            "$rest EGP",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color:
                                        rest < 0 ? Colors.red : Colors.green),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  if (provider.deal.isEmpty) {
                    if (provider.isEntry) {
                      context.read<AppProvider>().addEntry(provider.entry);
                    } else {
                      context.read<AppProvider>().addOrder(provider.order);
                    }
                  } else {
                    if (provider.isEntry) {
                      context.read<AppProvider>().editEntry(provider.entry);
                    } else {
                      context.read<AppProvider>().editOrder(provider.order);
                    }
                  }
                  Navigator.of(context).pop();
                },
                child: Text(provider.deal.isEmpty ? "Save" : "Edit")),
          ),
        ],
      ),
    );
  }

  Widget _radioButtons() => StatefulBuilder(
      builder: (context, setState) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                SizedBox(
                  width: 30,
                  child: Radio<PaymentType>(
                      value: provider.deal.type,
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => PaymentType.paid.color),
                      groupValue: PaymentType.paid,
                      onChanged: (val) {
                        setState(() {
                          provider.deal.type = PaymentType.paid;
                        });
                      }),
                ),
                Text(
                  PaymentType.paid.text,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: PaymentType.paid.color),
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 30,
                  child: Radio<PaymentType>(
                      value: provider.deal.type,
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => PaymentType.not.color),
                      groupValue: PaymentType.not,
                      onChanged: (val) {
                        setState(() {
                          provider.deal.type = PaymentType.not;
                        });
                      }),
                ),
                Text(
                  PaymentType.not.text,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: PaymentType.not.color),
                ),
              ]),
            ],
          ));
}
