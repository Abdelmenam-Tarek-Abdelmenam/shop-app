import 'package:flutter/material.dart';
import 'package:shop/view/shared/widgets/numeric_field.dart';

import '../../../../resources/styles_manager.dart';

class SettingLayout extends StatelessWidget {
  const SettingLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          _title(context, "Database sector"),
          const Divider(
            height: 10,
            thickness: 0,
          ),
          database(context),
          const Divider(
            height: 10,
            thickness: 0,
          ),
          _title(context, "Product sector"),
          const Divider(
            height: 10,
            thickness: 0,
          ),
          product(context),
          const Divider(
            height: 10,
            thickness: 0,
          ),
          _title(context, "Reports sector"),
          const Divider(
            height: 10,
            thickness: 0,
          ),
          reports(context),
        ],
      ),
    );
  }

  Widget _title(BuildContext context, String text) => Row(
        children: [
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.onBackground,
              // thickness: 10,
              height: 10,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(text, style: Theme.of(context).textTheme.headline4),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.onBackground,
              // thickness: 10,
              height: 10,
            ),
          ),
        ],
      );
  Widget database(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: StyleManager.border,
            boxShadow: StyleManager.shadow),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Import database',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            divider(context),
            Text(
              'Export database',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            divider(context),
            Text(
              'Clear database',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      );
  Widget product(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: StyleManager.border,
            boxShadow: StyleManager.shadow),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Minimum amount',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(
                    width: 120,
                    child: NumericField(TextEditingController(text: '15')))
              ],
            ),
            divider(context),
            Text(
              'Hide wholesale price',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      );
  Widget reports(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: StyleManager.border,
            boxShadow: StyleManager.shadow),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Not in stock items',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            divider(context),
            Text(
              'Less than minimum amount',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            divider(context),
            Text(
              'All products',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            divider(context),
            Text(
              'All entries',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            divider(context),
            Text(
              'All Orders',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      );

  Widget divider(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Divider(
          color: Theme.of(context).colorScheme.onBackground,
          height: 10,
        ),
      );
}
