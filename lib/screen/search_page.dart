import 'package:flutter/material.dart';
import '../widget/search/searchbar_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    double outsidePadding = 10;

    return Padding(
      padding: EdgeInsets.all(outsidePadding),
      child: const Stack(
        children: [
          SearchBarWidget(),
        ],
      ),
    );
  }
}
