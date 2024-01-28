import 'package:flutter/material.dart';
import '../model/departing_flights_list.dart';
import '../service/api_service.dart';
import '../widget/checkin_counter/flight_info_table.dart';
import '../widget/search/searchbar_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchInputController;
  bool hasInputText = false;
  final ApiService _apiService = ApiService();
  List<DepartingFlightsInfo> searchList = [];

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

  Future<void> fetchSearchData() async {
    List<DepartingFlightsInfo> resList =
        await _apiService.getFlightsInfoSearch(_searchInputController.text);

    if (mounted) {
      setState(() {
        searchList = resList;
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
            searchData: searchList,
          ),
          SearchBarWidget(
            height: searchbarHeight,
            inputController: _searchInputController,
            hasInputText: hasInputText,
            hasInputTextSetter: setHasInputText,
            searchCallback: fetchSearchData,
          ),
        ],
      ),
    );
  }
}

class SearchResultWidget extends StatefulWidget {
  const SearchResultWidget(
      {super.key, required this.topMargin, required this.searchData});

  final double topMargin;
  final List<DepartingFlightsInfo> searchData;

  @override
  State<SearchResultWidget> createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.topMargin),
      padding: const EdgeInsets.symmetric(vertical: 20),
        child: FlightInfoTable(
          dataList: widget.searchData,
          height: 500,
          isLoading: false,
        )
    );
  }
}
