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
    double searchbarHeight = 50;

    return Padding(
      padding: EdgeInsets.all(outsidePadding),
      child: Stack(
        children: [
          SearchResultWidget(topMargin: searchbarHeight),
          SearchBarWidget(height: searchbarHeight),
        ],
      ),
    );
  }
}

class SearchResultWidget extends StatefulWidget {
  const SearchResultWidget({super.key, required this.topMargin});

  final double topMargin;

  @override
  State<SearchResultWidget> createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.topMargin),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Text('결과 페이지'),
    );
  }
}
