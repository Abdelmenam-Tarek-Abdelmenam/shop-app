import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/module/deals.dart';

import '../../../../view_model/app_provider.dart';
import '../layouts/entry/widgtes/entry_design.dart';

class EntriesSearchDelegate extends SearchDelegate<EntryModel?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isNotEmpty) {
            query = '';
          } else {
            close(context, null);
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("results of $query");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<EntryModel>>(
        future: context.read<AppProvider>().findEntries(query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  EntryDesign(snapshot.data![index]),
              separatorBuilder: (_, __) => const SizedBox(
                height: 5,
              ),
              itemCount: snapshot.data?.length ?? 0,
            );
          } else {
            if (snapshot.hasError) {
              return const Center(child: Text("Sorry, something went wrong"));
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
