import 'package:flutter/material.dart';
import '../widget/search/searchbar_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchInputController;
  bool hasInputText = false;

  @override
  void initState() {
    super.initState();
    _searchInputController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchInputController.dispose();
  }

  void setInputController(TextEditingController controller) {
    _searchInputController = controller;
  }

  void setHasInputText(bool hasInput) {
    if (mounted) {
      setState(() {
        hasInputText = hasInput;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double outsidePadding = 10;
    double searchbarHeight = 50;

    return Padding(
      padding: EdgeInsets.all(outsidePadding),
      child: Stack(
        children: [
          SearchResultWidget(
            topMargin: searchbarHeight,
          ),
          SearchBarWidget(
              height: searchbarHeight,
              inputController: _searchInputController,
              hasInputText: hasInputText,
              hasInputTextSetter: setHasInputText),
        ],
      ),
    );
  }
}

class SearchResultWidget extends StatefulWidget {
  const SearchResultWidget({
    super.key,
    required this.topMargin,
  });

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
