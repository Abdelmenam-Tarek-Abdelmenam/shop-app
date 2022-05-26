import 'package:flutter/material.dart';
import 'package:shop/model/module/deals.dart';

class AddEntryView extends StatelessWidget {
  const AddEntryView(this.entry, {Key? key}) : super(key: key);
  final EntryModel entry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Add Entry"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(),
          )),
    );
  }
}
