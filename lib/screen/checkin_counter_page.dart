import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

import '../common/style.dart';
import '../model/terminalid_enum.dart';
import '../widget/flight_info_table.dart';

class CheckInCounterPage extends StatefulWidget {
  const CheckInCounterPage({super.key});

  @override
  State<CheckInCounterPage> createState() => _CheckInCounterPageState();
}

class _CheckInCounterPageState extends State<CheckInCounterPage> {
  TerminalidEnum? terminalid;
  String? counterCode;

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(
          height: 30,
        ),
        clockContainer(),
        // headerWidget(),
        const TitleWidget(),
        selectBox(),
        const SizedBox(
          height: 20,
        ),
        FlightInfoTable(terminalid: terminalid, counterCode: counterCode),
        const SizedBox(
          height: 80,
        )
      ]),
    );
  }

  Widget clockContainer() {
    double width = 300;
    double height = 100;
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                offset:
                    const Offset(outsideShadowDistance, outsideShadowDistance),
                color: Colors.blue.shade300,
                blurRadius: outsideShadowDistance,
                spreadRadius: 1),
            const BoxShadow(
                offset: Offset(-outsideShadowDistance, -outsideShadowDistance),
                color: Colors.white60,
                blurRadius: outsideShadowDistance,
                spreadRadius: 1)
          ],
        ),
        child: Container(
            margin: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 0.5)),
            child: Center(
              child: DigitalClock(
                showSecondsDigit: true,
                amPmDigitTextStyle: const TextStyle(fontFamily: 'Montserrat'),
                hourMinuteDigitTextStyle: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.white70),
                secondDigitTextStyle: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.white),
                colon: Text(
                  ":",
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
            )),
      ),
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
              selectedValue: terminalid, setSelectedValue: setTerminalid),
          CheckInCounterSelectBox(
              selectedValue: counterCode, setSelectedValue: setCounterCode),
        ],
      ),
    );
  }
}

class TitleWidget extends StatefulWidget {
  const TitleWidget({super.key});

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200, child: Image.asset('assets/images/character.png'));
  }
}

class CheckInCounterSelectBox extends StatefulWidget {
  const CheckInCounterSelectBox(
      {super.key, required this.selectedValue, required this.setSelectedValue});

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
      {super.key, required this.selectedValue, required this.setSelectedValue});

  final TerminalidEnum? selectedValue;
  final Function setSelectedValue;

  @override
  State<TerminalSelectBox> createState() => _TerminalSelectBoxState();
}

class _TerminalSelectBoxState extends State<TerminalSelectBox> {
  final List<TerminalidEnum> items = TerminalidEnum.values;

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
