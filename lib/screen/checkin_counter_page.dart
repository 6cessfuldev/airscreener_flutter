import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../common/style.dart';
import '../model/departing_flights_list.dart';
import '../model/terminalid_enum.dart';
import '../provider/flights_info_provider.dart';
import '../service/api_service.dart';
import '../widget/checkin_counter/check_in_counter_select_box.dart';
import '../widget/common/flight_info_table.dart';
import '../widget/checkin_counter/reload_button.dart';
import '../widget/checkin_counter/terminal_select_box.dart';

class CheckInCounterPage extends StatefulWidget {
  const CheckInCounterPage({super.key});

  @override
  State<CheckInCounterPage> createState() => _CheckInCounterPageState();
}

class _CheckInCounterPageState extends State<CheckInCounterPage> {
  TerminalidEnum terminalid = TerminalidEnum.p01;
  String counterCode = 'A';
  bool _isLoading = true;
  DateTime? lastUpdateDate;

  final ApiService _apiService = ApiService();
  List<DepartingFlightsInfo> _dataList = [];

  @override
  void initState() {
    dataFetchAndFilter();
    super.initState();
  }

  void setCounterCode(String counterCode) {
    setState(() {
      this.counterCode = counterCode;
    });
  }

  void setTerminalid(TerminalidEnum terminalid) {
    setState(() {
      this.terminalid = terminalid;
    });
  }

  void setLoadingStatus(bool isLoading) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isLoading = isLoading;
        });
      }
    });
  }

  Future<void> dataFetchAndFilter() async {
    setLoadingStatus(true);
    await dataFetch();
    if (mounted) {
      setState(() {
        _dataList = filterData(_dataList);
        lastUpdateDate = DateTime.now();
      });
    }
    setLoadingStatus(false);
  }

  Future<void> dataFetch() async {
    List<DepartingFlightsInfo> resultList =
        await _apiService.getFlightsInfoToTomorrow();
    _dataList = resultList;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final flightsInfoProvider =
          Provider.of<FlightsInfoProvider>(context, listen: false);
      flightsInfoProvider.setFlightsInfos(resultList);
    });
  }

  List<DepartingFlightsInfo> filterData(List<DepartingFlightsInfo> resultList) {
    return resultList.where((item) {
      if (item.terminalid != null) {
        if (terminalid == TerminalidEnum.p01 &&
            !['P01', 'P02'].contains(item.terminalid)) {
          return false;
        } else if (terminalid == TerminalidEnum.p02 &&
            item.terminalid != 'P03') {
          return false;
        }
      }

      /// counterCode 선택했을 경우 filtering 로직
      /// '-'가 포함된 경우 앞의 알파벳00 뒤의 알파벳00 사이에 올 수 있는 모든 알파벳과 코드를 계산한다
      if (item.chkinrange != null &&
          item.chkinrange!.contains('-') &&
          item.chkinrange!.length >= 7) {
        int firstChar = item.chkinrange![0].codeUnits[0];
        int firstCode = int.parse(item.chkinrange!.substring(1, 3));
        int lastChar = item.chkinrange![4].codeUnits[0];
        int lastCode = int.parse(item.chkinrange!.substring(5, 7));

        // debugPrint("checkin : ${item.chkinrange}");
        // debugPrint(
        //     "firstChar : $firstChar, firstCode : $firstCode, lastChar : $lastChar, lastCode : $lastCode");
        // debugPrint(widget.counterCode![0].codeUnits[0].toString());
        int selectChkChar = counterCode[0].codeUnits[0];
        int? selectChkNum =
            counterCode.length > 1 ? int.parse(counterCode[1]) : null;

        // debugPrint(
        //     "selectChkChar : $selectChkChar, selectChkNum : $selectChkNum");

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
            !item.chkinrange!.contains(counterCode[0])) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const double selectBoxHeight = 60;
    const double bottomGap = 5;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.constrainHeight();
        return SingleChildScrollView(
          child: Column(children: [
            selectBox(height: selectBoxHeight),
            FlightInfoTable(
                dataList: _dataList,
                isLoading: _isLoading,
                height: maxHeight - selectBoxHeight - bottomGap),
            const SizedBox(height: bottomGap)
          ]),
        );
      },
    );
  }

  Widget selectBox({required double height}) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 5,
          ),
          Expanded(child: reloadTimeWidget()),
          const SizedBox(
            width: 5,
          ),
          TerminalSelectBox(
              isLoading: _isLoading,
              reload: dataFetchAndFilter,
              selectedValue: terminalid,
              setSelectedValue: setTerminalid),
          const SizedBox(
            width: 5,
          ),
          CheckInCounterSelectBox(
              isLoading: _isLoading,
              reload: dataFetchAndFilter,
              selectedValue: counterCode,
              setSelectedValue: setCounterCode),
          const SizedBox(
            width: 5,
          ),
          ReloadButton(reload: dataFetchAndFilter, isLoading: _isLoading),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  Widget reloadTimeWidget() {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 380 ? 11 : 13;
    return Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Text(
          lastUpdateDate != null
              ? DateFormat('yy-MM-dd\nHH:mm').format(lastUpdateDate!).toString()
              : '',
          style: TextStyle(fontSize: fontSize, color: mainBlueColor),
          textAlign: TextAlign.center,
        ));
  }
}
