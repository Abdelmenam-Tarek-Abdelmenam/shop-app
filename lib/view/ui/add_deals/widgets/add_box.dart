import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/add_deal_provider.dart';
import '../../../resources/styles_manager.dart';
import '../../../shared/widgets/numeric_field.dart';
import '../../main_page/widgets/home_app_bar.dart';

class AddBox extends StatelessWidget {
  AddBox({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Consumer<AddDealProvider>(builder: (context, provider, _) {
        return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                boxShadow: StyleManager.shadow,
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: StyleManager.border),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SearchBar(),
                const SizedBox(height: 10),
                Text(provider.activeProduct.product.name,
                    style: Theme.of(context).textTheme.subtitle1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: NumericField(
                      TextEditingController(
                          text: provider.activeProduct.price.toString()),
                      onChange: (value) {
                        provider.changeActivePrice(double.tryParse(value));
                      },
                      title: "Price",
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: NumericField(
                      TextEditingController(
                          text: provider.activeProduct.amount.toString()),
                      onChange: (value) {
                        provider.changeActiveAmount(double.tryParse(value));
                      },
                      title: "Amount",
                    )),
                  ],
                ),
                const SizedBox(height: 5),
                Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        context.read<AddDealProvider>().addProduct();
                      },
                      child: const Text("Add")),
                )
              ],
            ));
      }),
    );
  }
}
