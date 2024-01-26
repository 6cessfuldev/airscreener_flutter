import 'package:flutter/material.dart';
import '../common/style.dart';
import '../model/departing_flights_list.dart';

class FlightInfoTable extends StatefulWidget {
  const FlightInfoTable(
      {super.key,
      required this.dataList,
      required this.isLoading,
      required this.height});

  final List<DepartingFlightsInfo> dataList;
  final bool isLoading;
  final double height;

  @override
  State<FlightInfoTable> createState() => _FlightInfoTableState();
}

class _FlightInfoTableState extends State<FlightInfoTable> {
  String convertDateFormat(String? rawDate) {
    if (rawDate == null || rawDate == '') return '';
    return '${rawDate.substring(8, 10)}:${rawDate.substring(10, 12)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              offset:
                  const Offset(outsideShadowDistance, outsideShadowDistance),
              color: Colors.blue.shade300,
              blurRadius: outsideShadowDistance,
              spreadRadius: 5),
          const BoxShadow(
              offset: Offset(-outsideShadowDistance, -outsideShadowDistance),
              color: Colors.white60,
              blurRadius: outsideShadowDistance,
              spreadRadius: 5)
        ],
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: widget.height - (2 * outsideShadowDistance),
        child: SingleChildScrollView(
          child: Table(
            border: TableBorder.all(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.transparent,
            ),
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(3),
              3: FlexColumnWidth(1),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              const TableRow(children: [
                Center(
                    child: Text(
                  '출발 시간',
                  style: TextStyle(color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                )),
                Center(
                    child: Text(
                  '편명',
                  style: TextStyle(color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                )),
                Center(
                    child: Text(
                  '도착지・경유지',
                  style: TextStyle(color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                )),
                Center(
                    child: Text(
                  '게이트',
                  style: TextStyle(color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                )),
              ]),
              ...widget.dataList.map((info) => TableRow(children: [
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          convertDateFormat(info.scheduleDateTime),
                          textAlign: TextAlign.center,
                        ),
                        if (info.estimatedDateTime != info.scheduleDateTime)
                          Text(
                            '-> ${convertDateFormat(info.estimatedDateTime)}',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    )),
                    SizedBox(
                        height: 45,
                        child: Center(
                            child: Text(
                          info.flightId ?? '',
                          textAlign: TextAlign.center,
                        ))),
                    Center(
                        child: Text(
                      info.airport ?? '',
                      textAlign: TextAlign.center,
                    )),
                    Center(
                        child: Text(
                      info.gatenumber ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.blueGrey),
                    )),
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
