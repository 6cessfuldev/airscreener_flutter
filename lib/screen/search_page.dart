import 'package:flutter/material.dart';

import '../common/style.dart';

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double outsidePadding = 10;
    double searchBarWidth = screenWidth * 0.95;
    double submitBtnWidth = 50;

    return Padding(
      padding: EdgeInsets.all(outsidePadding),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            width: searchBarWidth,
            height: 60,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(9999.0),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(
                        outsideShadowDistance, outsideShadowDistance),
                    color: downsideShadowColor,
                    blurRadius: outsideShadowDistance,
                    spreadRadius: 2),
                const BoxShadow(
                    offset:
                        Offset(-outsideShadowDistance, -outsideShadowDistance),
                    color: upsideShadowColor,
                    blurRadius: outsideShadowDistance,
                    spreadRadius: 2)
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    width: searchBarWidth - submitBtnWidth - 20,
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
                                  offset: const Offset(outsideShadowDistance,
                                      outsideShadowDistance),
                                  color: downsideShadowColor,
                                  blurRadius: outsideShadowDistance,
                                  spreadRadius: 2),
                              const BoxShadow(
                                  offset: Offset(-outsideShadowDistance,
                                      -outsideShadowDistance),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
