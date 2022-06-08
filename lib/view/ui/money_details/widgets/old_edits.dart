import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/view_model/app_provider.dart';

import '../../../../model/module/old_edit_money.dart';

class OldEditList extends StatelessWidget {
  const OldEditList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OldMoneyEdit>>(
      future: context.read<AppProvider>().readAllMoneyEdits(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                listItem(context, snapshot.data![index]),
            separatorBuilder: (_, __) => const SizedBox(
              height: 5,
            ),
            itemCount: snapshot.data?.length ?? 0,
          );
        } else {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Sorry an error accrued."),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      },
    );
  }

  Widget listItem(BuildContext context, OldMoneyEdit item) => ListTile(
        title: Text(
          item.notes,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text("${item.date} - ${item.time}"),
        trailing: FittedBox(
          fit: BoxFit.fill,
          child: Column(
            children: [
              Text("${item.amount} EGP"),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Icon(
                    item.type.icon,
                    size: 20,
                    color: item.type.color,
                  ),
                  Text(item.type.text,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: item.type.color))
                ],
              )
            ],
          ),
        ),
      );
}
