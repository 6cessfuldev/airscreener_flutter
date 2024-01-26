import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../common/style.dart';
import '../model/departing_flights_list.dart';
import '../model/terminalid_enum.dart';
import '../service/api_service.dart';
import '../widget/flight_info_table.dart';

class CheckInCounterPage extends StatefulWidget {
  const CheckInCounterPage({super.key});

  @override
  State<CheckInCounterPage> createState() => _CheckInCounterPageState();
}

class _CheckInCounterPageState extends State<CheckInCounterPage> {
  TerminalidEnum terminalid = TerminalidEnum.p01;
  String counterCode = 'A';
  bool _isLoading = true;

  final ApiService _apiService = ApiService();
  List<DepartingFlightsInfo> _dataList = [];

  @override
  void initState() {
    dataFetchAndFilter();
    super.initState();

    _apiService.getDepartingFlightsList({
      'pageNo': 1,
      'numOfRows': 4000,
      'type': 'json',

      // 'from_time': DateFormat('HHmm').format(DateTime.now()).toString(),
      'searchday': DateFormat('yyyyMMdd').format(DateTime.now()).toString()
    }).then((value) => value.items!.map((e) {
          if (e.chkinrange!.contains('E')) {
            print('e');
          }
        }));
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
          debugPrint("setState");
          _isLoading = isLoading;
        });
      }
    });
    debugPrint('isLoading $_isLoading');
  }

  Future<void> dataFetchAndFilter() async {
    setLoadingStatus(true);
    await dataFetch();
    setState(() {
      _dataList = filterData(_dataList);
    });
    setLoadingStatus(false);
  }

  Future<void> dataFetch() async {
    Map<String, dynamic> todayRequest = {
      'pageNo': 1,
      'numOfRows': 4000,
      'type': 'json',
      'from_time': DateFormat('HHmm').format(DateTime.now()).toString(),
      'searchday': DateFormat('yyyyMMdd').format(DateTime.now()).toString()
    };

    Map<String, dynamic> tommorowRequest = {
      'pageNo': 1,
      'numOfRows': 2000,
      'type': 'json',
      'to_time': DateFormat('HHmm')
          .format(DateTime.now().add(const Duration(hours: 24)))
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

    debugPrint('status ');

    List<DepartingFlightsInfo> resultList = [];
    if (responseList[0].status == 200) {
      resultList.addAll(responseList[0].items);
    }
    if (responseList[1].status == 200) {
      resultList.addAll(responseList[1].items);
    }

    _dataList = resultList;
  }

  List<DepartingFlightsInfo> filterData(List<DepartingFlightsInfo> resultList) {
    return resultList.where((item) {
      if (item.terminalid != null &&
          !item.terminalid!
              .contains(terminalid.toString().split('.').last.toUpperCase())) {
        return false;
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
    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        // clockContainer(),
        selectBox(),
        FlightInfoTable(
          dataList: _dataList,
          isLoading: _isLoading,
        ),
        const SizedBox(
          height: 80,
        )
      ]),
    );
  }

  Widget headerWidget() {
    return const SizedBox(
        height: 100,
        child: Text(
          '위탁 화이팅~!',
          style: TextStyle(fontSize: 50, color: lightPinkColor),
        ));
  }

  Widget selectBox() {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TerminalSelectBox(
              reload: dataFetchAndFilter,
              selectedValue: terminalid,
              setSelectedValue: setTerminalid),
          CheckInCounterSelectBox(
              reload: dataFetchAndFilter,
              selectedValue: counterCode,
              setSelectedValue: setCounterCode),
          ReloadButton(reload: dataFetchAndFilter, isLoading: _isLoading),
        ],
      ),
    );
  }
}

class CheckInCounterSelectBox extends StatefulWidget {
  const CheckInCounterSelectBox(
      {super.key,
      required this.reload,
      required this.selectedValue,
      required this.setSelectedValue});

  final Function reload;
  final String? selectedValue;
  final Function setSelectedValue;

  @override
  State<CheckInCounterSelectBox> createState() =>
      _CheckInCounterSelectBoxState();
}

class _CheckInCounterSelectBoxState extends State<CheckInCounterSelectBox> {
  final List<String> items = [
    'A',
    'B1',
    'B2',
    'C1',
    'C2',
    'D1',
    'D2',
    'E1',
    'E2',
    'F1',
    'F2',
    'G',
    'H1',
    'H2',
    'I1',
    'I2',
    'J1',
    'J2',
    'K1',
    'K2',
    'L1',
    'L2',
    'M1',
    'M2',
    'N'
  ];

  bool isClicked = false;
  bool isSelected = false;
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(outsideShadowDistance),
      child: SizedBox(
        // padding: const EdgeInsets.symmetric(vertical: 30.0),
        width: 85,
        height: 50,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: const Row(
              children: [
                // const Icon(Icons.list, size: 16, color: lightPinkColor),
                // const SizedBox(
                //   width: 4,
                // ),
                Expanded(
                  child: Text(
                    '카운터',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: items
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            value: widget.selectedValue,
            onChanged: (value) {
              widget.setSelectedValue(value);
              widget.reload();
            },
            onMenuStateChange: (isOpen) {
              setState(() {
                isClicked = isOpen;
              });
            },
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: isClicked
                    ? null
                    : [
                        BoxShadow(
                            offset: const Offset(
                                outsideShadowDistance, outsideShadowDistance),
                            color: Colors.blue.shade300,
                            blurRadius: outsideShadowDistance,
                            spreadRadius: 2),
                        const BoxShadow(
                            offset: Offset(
                                -outsideShadowDistance, -outsideShadowDistance),
                            color: Colors.white60,
                            blurRadius: outsideShadowDistance,
                            spreadRadius: 2)
                      ],
              ),
              // elevation: 2,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
              iconSize: 14,
              iconEnabledColor: Colors.yellow,
              iconDisabledColor: Colors.grey,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.blue.withOpacity(0.6),
              ),
              offset: const Offset(-20, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all(6),
                thumbVisibility: MaterialStateProperty.all(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ),
      ),
    );
  }
}

class TerminalSelectBox extends StatefulWidget {
  const TerminalSelectBox(
      {super.key,
      required this.reload,
      required this.selectedValue,
      required this.setSelectedValue});

  final Function reload;
  final TerminalidEnum? selectedValue;
  final Function setSelectedValue;

  @override
  State<TerminalSelectBox> createState() => _TerminalSelectBoxState();
}

class _TerminalSelectBoxState extends State<TerminalSelectBox> {
  List<TerminalidEnum> items = TerminalidEnum.values;

  bool isClicked = false;
  bool isSelected = false;
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(outsideShadowDistance),
      child: SizedBox(
        // padding: const EdgeInsets.symmetric(vertical: 30.0),
        width: 140,
        height: 50,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Row(
              children: [
                Expanded(
                  child: Text(
                    '터미널',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[200],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: items
                .map((TerminalidEnum item) => DropdownMenuItem<String>(
                      value: item.convertEnumToStr,
                      child: Text(
                        item.convertEnumToStr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            value: widget.selectedValue?.convertEnumToStr,
            onChanged: (value) {
              if (value != null) {
                widget.setSelectedValue(TerminalidEnum.convertStrToEnum(value));
                widget.reload();
              }
            },
            onMenuStateChange: (isOpen) {
              setState(() {
                isClicked = isOpen;
              });
            },
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: isClicked
                    ? null
                    : [
                        BoxShadow(
                            offset: const Offset(
                                outsideShadowDistance, outsideShadowDistance),
                            color: Colors.blue.shade300,
                            blurRadius: outsideShadowDistance,
                            spreadRadius: 2),
                        const BoxShadow(
                            offset: Offset(
                                -outsideShadowDistance, -outsideShadowDistance),
                            color: Colors.white60,
                            blurRadius: outsideShadowDistance,
                            spreadRadius: 2)
                      ],
              ),
              // elevation: 2,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
              iconSize: 14,
              iconEnabledColor: Colors.yellow,
              iconDisabledColor: Colors.grey,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.blue.withOpacity(0.6),
              ),
              offset: const Offset(-20, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all(6),
                thumbVisibility: MaterialStateProperty.all(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ),
      ),
    );
  }
}

class ReloadButton extends StatefulWidget {
  const ReloadButton(
      {required this.reload, required this.isLoading, super.key});

  final Function reload;
  final bool isLoading;

  @override
  State<ReloadButton> createState() => _ReloadBoxState();
}

class _ReloadBoxState extends State<ReloadButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading && !widget.isLoading) {
      controller.stop();
    } else if (!oldWidget.isLoading && widget.isLoading) {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(outsideShadowDistance),
      child: GestureDetector(
        onTap: () {
          debugPrint("isLoading ${widget.isLoading}");
          if (widget.isLoading) return;
          widget.reload();
          controller.repeat();
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14.0),
            boxShadow: widget.isLoading
                ? null
                : [
                    BoxShadow(
                        offset: const Offset(
                            outsideShadowDistance, outsideShadowDistance),
                        color: Colors.blue.shade300,
                        blurRadius: outsideShadowDistance,
                        spreadRadius: 2),
                    const BoxShadow(
                        offset: Offset(
                            -outsideShadowDistance, -outsideShadowDistance),
                        color: Colors.white60,
                        blurRadius: outsideShadowDistance,
                        spreadRadius: 2)
                  ],
          ),
          child: Lottie.asset(
            'assets/animations/reload_animation.json',
            controller: controller,
            onLoaded: (composition) {
              controller.duration = composition.duration;
              controller.forward();
            },
            frameBuilder: (context, child, composition) {
              return ColorFiltered(
                colorFilter:
                    const ColorFilter.mode(Colors.blue, BlendMode.srcATop),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}
