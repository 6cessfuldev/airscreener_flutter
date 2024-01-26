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
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  String convertDateFormat(String? rawDate) {
    if (rawDate == null || rawDate == '') return '';
    return '${rawDate.substring(8, 10)}:${rawDate.substring(10, 12)}';
  }

  List<TableRow> _tableRowList() {
    bool backgroundFlag = false;
    String? lastScheduleDateTime;
    String? lastEstiamteDateTime;
    String? lastGateNumber;
    return widget.dataList.map((info) {
      if (lastEstiamteDateTime != info.estimatedDateTime ||
          lastScheduleDateTime != info.scheduleDateTime ||
          lastGateNumber != info.gatenumber) {
        backgroundFlag = !backgroundFlag;
      }
      lastEstiamteDateTime = info.estimatedDateTime;
      lastScheduleDateTime = info.scheduleDateTime;
      lastGateNumber = info.gatenumber;
      return TableRow(
          decoration:
              BoxDecoration(color: backgroundFlag ? Colors.white54 : null),
          children: [
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  convertDateFormat(info.scheduleDateTime),
                  textAlign: TextAlign.center,
                    style: info.estimatedDateTime != info.scheduleDateTime
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough)
                        : null
                ),
                if (info.estimatedDateTime != info.scheduleDateTime)
                  Text(
                    '-> ${convertDateFormat(info.estimatedDateTime)}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
              ],
            )),
            Center(
                child: Column(
              children: [
                Text(
                  info.flightId ?? '',
                  textAlign: TextAlign.center,
                ),
                if (info.remark != null && info.remark != "")
                  Text(
                    info.remark!,
                    textAlign: TextAlign.center,
                  ),
              ],
            )),
            SizedBox(
              height: 48,
              child: Center(
                  child: Text(
                info.airport ?? '',
                textAlign: TextAlign.center,
              )),
            ),
            Center(
                child: Text(
              info.gatenumber ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.blueGrey),
            ))
          ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<TableRow> dataWidgets = _tableRowList();
    _scrollController.animateTo(0,
        curve: Curves.ease, duration: const Duration(milliseconds: 300));

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: widget.isLoading
            ? null
            : [
                BoxShadow(
                    offset: const Offset(
                        outsideShadowDistance, outsideShadowDistance),
                    color: Colors.blue.shade300,
                    blurRadius: outsideShadowDistance,
                    spreadRadius: 5),
                const BoxShadow(
                    offset:
                        Offset(-outsideShadowDistance, -outsideShadowDistance),
                    color: Colors.white60,
                    blurRadius: outsideShadowDistance,
                    spreadRadius: 5)
              ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: widget.height - (2 * outsideShadowDistance),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 10,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Table(
              border: TableBorder.all(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.transparent,
              ),
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(1.2),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(children: [
                  SizedBox(
                    height: 30,
                    child: Center(
                        child: Text(
                      '출발 시간',
                      style: TextStyle(color: Colors.blueAccent),
                      textAlign: TextAlign.center,
                    )),
                  ),
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
                if (dataWidgets.isNotEmpty) ...dataWidgets
              ],
            ),
          ),
        ),
      ),
    );
  }
}
