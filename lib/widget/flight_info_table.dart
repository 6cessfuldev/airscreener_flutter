import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/style.dart';
import '../model/departing_flights_list.dart';
import '../service/api_service.dart';

class FlightInfoTable extends StatefulWidget {
  const FlightInfoTable({required this.selectedValue, super.key});

  final String selectedValue;

  @override
  State<FlightInfoTable> createState() => _FlightInfoTableState();
}

class _FlightInfoTableState extends State<FlightInfoTable> {
  late final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _dataFetch();
  }

  Future<DepartingFlightsList> _dataFetch() async {
    Map<String, dynamic> request = {
      'pageNo': 1,
      'numOfRows': 100,
      'type': 'json',
      // 'from_time': DateFormat('HHmm').format(DateTime.now()).toString(),
      'searchday': DateFormat('yyyyMMdd').format(DateTime.now()).toString()
    };

    DepartingFlightsList flightInfoList =
        await _apiService.getDepartingFlightsList(request, defaultData: {});

    return DepartingFlightsList(
        status: flightInfoList.status,
        items: flightInfoList.items
            ?.where((item) => item.chkinrange == null
                ? false
                : item.chkinrange!.contains(widget.selectedValue))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _dataFetch(),
        builder: (context, snapshot) {
          return Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(
                        outsideShadowDistance, outsideShadowDistance),
                    color: Colors.blue.shade300,
                    blurRadius: outsideShadowDistance,
                    spreadRadius: 1),
                const BoxShadow(
                    offset:
                        Offset(-outsideShadowDistance, -outsideShadowDistance),
                    color: Colors.white60,
                    blurRadius: outsideShadowDistance,
                    spreadRadius: 1)
              ],
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Table(
                  border: TableBorder.all(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.transparent,
                  ),
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(70.0),
                    1: FixedColumnWidth(120.0),
                    // 2: FixedColumnWidth(110.0),
                    2: FixedColumnWidth(120.0),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    const TableRow(children: [
                      Center(child: Text('카운터')),
                      Center(child: Text('항공사')),
                      Center(child: Text('출발 시간')),
                    ]),
                    if (snapshot.connectionState != ConnectionState.waiting &&
                        !snapshot.hasError)
                      ...?snapshot.data?.items
                          ?.map((info) => TableRow(children: [
                                Center(child: Text(info.chkinrange ?? '')),
                                Center(child: Text(info.airline ?? '')),
                                // Center(child: Text(info.scheduleDateTime ?? '')),
                                Center(
                                    child: Text(info.estimatedDateTime ?? '')),
                              ]))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
