import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/style.dart';
import '../model/departing_flights_list.dart';
import '../model/terminalid_enum.dart';
import '../service/api_service.dart';

class FlightInfoTable extends StatefulWidget {
  const FlightInfoTable({this.terminalid, this.counterCode, super.key});

  final TerminalidEnum? terminalid;
  final String? counterCode;

  @override
  State<FlightInfoTable> createState() => _FlightInfoTableState();
}

class _FlightInfoTableState extends State<FlightInfoTable> {
  late final ApiService _apiService = ApiService();
  bool isClicked = false;

  @override
  void initState() {
    super.initState();
    _dataFetch();
  }

  Future<List<DepartingFlightsInfo>> _dataFetch() async {
    Map<String, dynamic> todayRequest = {
      'pageNo': 1,
      'numOfRows': 2000,
      'type': 'json',
      'from_time': DateFormat('HHmm').format(DateTime.now()).toString(),
      'searchday': DateFormat('yyyyMMdd').format(DateTime.now()).toString()
    };

    Map<String, dynamic> tommorowRequest = {
      'pageNo': 1,
      'numOfRows': 2000,
      'type': 'json',
      'to_time': DateFormat('HHmm')
          .format(DateTime.now().add(const Duration(hours: 12)))
          .toString(),
      'searchday': DateFormat('yyyyMMdd')
          .format(DateTime.now().add(const Duration(days: 1)))
          .toString()
    };

    List<Future> tasks = [];
    tasks.add(
        _apiService.getDepartingFlightsList(todayRequest, defaultData: {}));
    tasks.add(
        _apiService.getDepartingFlightsList(tommorowRequest, defaultData: {}));

    List responseList = await Future.wait(tasks);

    // debugPrint(responseList[0].status.toString());

    List<DepartingFlightsInfo> resultList = [];
    if (responseList[0].status == 200) {
      resultList.addAll(responseList[0].items);
    }
    if (responseList[1].status == 200) {
      resultList.addAll(responseList[1].items);
    }

    // debugPrint(resultList.length.toString());

    return resultList.where((item) {
      if (widget.terminalid != null &&
          item.terminalid != null &&
          !item.terminalid!.contains(
              widget.terminalid!.toString().split('.').last.toUpperCase())) {
        return false;
      }

      /// counterCode 선택했을 경우 filtering 로직
      if (widget.counterCode != null) {
        /// '-'가 포함된 경우 앞의 알파벳00 뒤의 알파벳00 사이에 올 수 있는 모든 알파벳과 코드를 계산한다
        if (item.chkinrange != null &&
            item.chkinrange!.contains('-') &&
            item.chkinrange!.length >= 7) {
          int firstChar = item.chkinrange![0].codeUnits[0];
          int firstCode = int.parse(item.chkinrange!.substring(1, 3));
          int lastChar = item.chkinrange![4].codeUnits[0];
          int lastCode = int.parse(item.chkinrange!.substring(5, 7));

          debugPrint("checkin : ${item.chkinrange}");
          debugPrint(
              "firstChar : $firstChar, firstCode : $firstCode, lastChar : $lastChar, lastCode : $lastCode");
          debugPrint(widget.counterCode![0].codeUnits[0].toString());
          int selectChkChar = widget.counterCode![0].codeUnits[0];
          int? selectChkNum = widget.counterCode!.length > 1
              ? int.parse(widget.counterCode![1])
              : null;

          debugPrint(
              "selectChkChar : $selectChkChar, selectChkNum : $selectChkNum");

          /// 알파벳 범위 밖은 제외
          if (selectChkChar < firstChar || selectChkChar > lastChar) {
            return false;
          }

          /// 알파벳 범위 안에 있고 선택한 체크인 구분이 숫자가 없는 구분값일 경우는 (ex A, G, N)
          /// 알파벳 범위 안에만 들면 되지만 B1, C2와 같이 번호가 있는 경우
          /// 1은 1~18, 2는 19~... 코드에 해당하는 번호다.
          /// 예를 들어 B1를 선택했을 경우 B19-C18 체크인 카운터 데이터는 필터링해야 한다.
          /// 반대로 C2를 선택했을 경우에도 C19부터이므로 해당 B19-C18 데이터는 필터링해야 한다.
          if (selectChkNum != null) {
            if (selectChkChar == firstChar &&
                selectChkNum == 1 &&
                firstCode > 18) {
              return false;
            }
            if (selectChkChar == lastChar &&
                selectChkNum == 2 &&
                lastCode <= 18) {
              return false;
            }
          }
        }
        // 알파벳만 있는 경우 A B C 와 같이 모두 나열하므로 contains로 체크
        else {
          if (item.chkinrange != null &&
              !item.chkinrange!.contains(widget.counterCode!)) {
            return false;
          }
        }
      }
      return true;
    }).toList();
  }

  String convertDateFormat(String? rawDate) {
    if (rawDate == null || rawDate == '') return '';
    return '${rawDate.substring(4, 6)}/${rawDate.substring(6, 8)} ${rawDate.substring(8, 10)}:${rawDate.substring(10, 12)}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _dataFetch(),
        builder: (context, snapshot) {
          return GestureDetector(
            onTapDown: (_) {},
            child: Container(
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
                      spreadRadius: 5),
                  const BoxShadow(
                      offset: Offset(
                          -outsideShadowDistance, -outsideShadowDistance),
                      color: Colors.white60,
                      blurRadius: outsideShadowDistance,
                      spreadRadius: 5)
                ],
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Table(
                      border: TableBorder.all(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.transparent,
                      ),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(1.5),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(3),
                        3: FlexColumnWidth(3),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        const TableRow(children: [
                          Center(
                              child: Text(
                            '터미널',
                            style: TextStyle(color: Colors.blueAccent),
                            textAlign: TextAlign.center,
                          )),
                          Center(
                              child: Text(
                            '카운터',
                            style: TextStyle(color: Colors.blueAccent),
                            textAlign: TextAlign.center,
                          )),
                          Center(
                              child: Text(
                            '항공사',
                            style: TextStyle(color: Colors.blueAccent),
                            textAlign: TextAlign.center,
                          )),
                          Center(
                              child: Text(
                            '출발 시간',
                            style: TextStyle(color: Colors.blueAccent),
                            textAlign: TextAlign.center,
                          )),
                        ]),
                        if (snapshot.connectionState !=
                                ConnectionState.waiting &&
                            !snapshot.hasError)
                          ...?snapshot.data?.map((info) => TableRow(children: [
                                Center(
                                    child: Text(
                                  info.terminalid ?? '',
                                  textAlign: TextAlign.center,
                                )),
                                SizedBox(
                                    height: 40,
                                    child: Center(
                                        child: Text(
                                      info.chkinrange ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.blueGrey),
                                    ))),
                                Center(
                                    child: Text(
                                  info.airline ?? '',
                                  textAlign: TextAlign.center,
                                )),
                                // Center(child: Text(info.scheduleDateTime ?? '')),
                                Center(
                                    child: Text(
                                  convertDateFormat(info.estimatedDateTime),
                                  textAlign: TextAlign.center,
                                )),
                              ]))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
