import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/config.dart';
import '../common/style.dart';
import '../model/departing_flights_list.dart';
import '../provider/flights_info_provider.dart';

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

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _searchInputController;
  bool hasInputText = false;
  List<DepartingFlightsInfo> typeAheadData = [];
  int lastDataListLenght = 0;

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

  List<DepartingFlightsInfo> filterData(
      String input, List<DepartingFlightsInfo> dataList) {
    int counter = 0;
    List<DepartingFlightsInfo> filteredList = [];
    for (DepartingFlightsInfo info in dataList) {
      if (info.flightId != null &&
          info.flightId!.contains(input.toUpperCase())) {
        counter++;
        filteredList.add(info);
      } else {
        continue;
      }
      if (counter >= typeAheadCount) break;
    }

    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double searchBarWidth = screenWidth * 0.95;
    double submitBtnWidth = 50;
    double searchBarPadding = 5;
    double searchInputHeight = 50;
    double typeAheadItemHeight = 50;
    double borderRadius = 20.0;
    double bottomGapHeigt = 0;

    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Consumer<FlightsInfoProvider>(
          builder: (context, value, child) {
            List<DepartingFlightsInfo> dataList = value.dataList;
            dataList = filterData(_searchInputController.text, dataList);
            return Container(
              width: searchBarWidth,
              height: hasInputText && dataList.isNotEmpty
                  ? searchInputHeight +
                      searchBarPadding * 2 +
                      dataList.length * typeAheadItemHeight +
                      bottomGapHeigt
                  : searchInputHeight + searchBarPadding * 2,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(
                          outsideShadowDistance, outsideShadowDistance),
                      color: downsideShadowColor,
                      blurRadius: outsideShadowDistance,
                      spreadRadius: 2),
                  const BoxShadow(
                      offset: Offset(
                          -outsideShadowDistance, -outsideShadowDistance),
                      color: upsideShadowColor,
                      blurRadius: outsideShadowDistance,
                      spreadRadius: 2)
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: searchInputWidget(searchInputHeight,
                          searchBarWidth, submitBtnWidth, searchBarPadding)),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: typeAheadCount,
                    itemBuilder: (context, index) {
                      return Container(
                          child: hasInputText && dataList.length > index
                              ? Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Colors.white70))),
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 10),
                          alignment: Alignment.centerLeft,
                          height: typeAheadItemHeight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                        '${dataList[index].flightId}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: mainBlueColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                        ' • ${dataList[index].airline}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: fontColor, fontSize: 17),
                              ),
                              Expanded(
                                child: Text(
                                          ' • ${dataList[index].airport}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: fontColor, fontSize: 17),
                                ),
                              ),
                            ],
                                  ),
                                )
                              : Container());
                    },
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget searchInputWidget(
      searchInputHeight, searchBarWidth, submitBtnWidth, searchBarPadding) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: searchInputHeight,
          width: searchBarWidth - submitBtnWidth - searchBarPadding * 2 - 1,
          child: TextField(
            controller: _searchInputController,
            style: const TextStyle(fontSize: 20, color: fontColor),
            decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.airplanemode_active,
                  color: mainBlueColor,
                ),
                border: InputBorder.none,
                hintText: '비행편 검색'),
            onChanged: (value) {
              setState(() {
                hasInputText = value != '';
              });
            },
          ),
        ),
        Container(
          height: submitBtnWidth,
          width: submitBtnWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999.0),
            color: mainBlueColor,
            boxShadow: !hasInputText
                ? null
                : [
                    BoxShadow(
                        offset: const Offset(
                            outsideShadowDistance, outsideShadowDistance),
                        color: downsideShadowColor,
                        blurRadius: outsideShadowDistance,
                        spreadRadius: 2),
                    const BoxShadow(
                        offset: Offset(
                            -outsideShadowDistance, -outsideShadowDistance),
                        color: upsideShadowColor,
                        blurRadius: outsideShadowDistance,
                        spreadRadius: 2)
                  ],
          ),
          child: IconButton(
            icon: const Icon(Icons.search),
            color: lightestBlueColor,
            onPressed: () {},
          ),
        )
      ],
    );
  }
}
