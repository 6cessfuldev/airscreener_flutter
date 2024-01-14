import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

import '../common/style.dart';
import '../widget/flight_info_table.dart';

class CheckInCounterPage extends StatefulWidget {
  const CheckInCounterPage({super.key});

  @override
  State<CheckInCounterPage> createState() => _CheckInCounterPageState();
}

class _CheckInCounterPageState extends State<CheckInCounterPage> {
  String selectedValue = 'A';

  void setSelectedValue(String counterCode) {
    setState(() {
      selectedValue = counterCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        clockContainer(),
        // headerWidget(),
        const TitleWidget(),
        SelectBox(
            selectedValue: selectedValue, setSelectedValue: setSelectedValue),
        const SizedBox(
          height: 20,
        ),
        FlightInfoTable(selectedValue: selectedValue),
        const SizedBox(
          height: 50,
        )
      ]),
    );
  }

  Widget clockContainer() {
    double screenWidth = MediaQuery.of(context).size.width;
    double width = 300;
    double height = 100;
    return SizedBox(
      width: 300,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: width,
              height: height,
              color: backgroundColor,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(-width + insideShoadowDistance, 0),
                          color: Colors.white70,
                          blurRadius: insideShoadowDistance,
                          spreadRadius: 1),
                      BoxShadow(
                          offset: Offset(width - insideShoadowDistance, 0),
                          color: Colors.blue.shade300,
                          blurRadius: insideShoadowDistance,
                          spreadRadius: 1),
                      BoxShadow(
                          offset: Offset(0, -height + insideShoadowDistance),
                          color: Colors.white70,
                          blurRadius: insideShoadowDistance,
                          spreadRadius: 1),
                      BoxShadow(
                          offset: Offset(0, height - insideShoadowDistance),
                          color: Colors.blue.shade300,
                          blurRadius: insideShoadowDistance,
                          spreadRadius: 1),
                      // BoxShadow(
                      //     offset: const Offset(-2, -2),
                      //     color: Colors.blue.shade300,
                      //     blurRadius: 2,
                      //     spreadRadius: 2)
                    ],
                  ),
                  child: Center(
                    child: DigitalClock(
                      showSecondsDigit: false,
                      amPmDigitTextStyle:
                          const TextStyle(fontFamily: 'Montserrat'),
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
          ),
        ],
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

class SelectBox extends StatefulWidget {
  const SelectBox(
      {super.key, required this.selectedValue, required this.setSelectedValue});

  final String selectedValue;
  final Function setSelectedValue;

  @override
  State<SelectBox> createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {
  final List<String> items = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N'
  ];

  bool isClicked = false;
  String dropdownValue = 'A';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(outsideShadowDistance),
      child: SizedBox(
        // padding: const EdgeInsets.symmetric(vertical: 30.0),
        width: 80,
        height: 50,
        // child: Container(
        //   decoration: BoxDecoration(
        //     color: backgroundColor,
        //     borderRadius: BorderRadius.circular(14),
        //     boxShadow: [
        //       BoxShadow(
        //           offset: const Offset(shadowDistance, shadowDistance),
        //           color: Colors.blue.shade300,
        //           blurRadius: shadowDistance,
        //           spreadRadius: 1),
        //       const BoxShadow(
        //           offset: Offset(-shadowDistance, -shadowDistance),
        //           color: Colors.white60,
        //           blurRadius: shadowDistance,
        //           spreadRadius: 1)
        //     ],
        //   ),
        //   child: DropdownButton<String>(
        //     padding: const EdgeInsets.symmetric(horizontal: 20),
        //     value: dropdownValue,
        //     icon: const Icon(Icons.arrow_drop_down),
        //     iconSize: 24,
        //     style: const TextStyle(color: Colors.blueGrey),
        //     borderRadius: BorderRadius.circular(16.0),
        //     dropdownColor: backgroundColor,
        //     menuMaxHeight: 200,
        //     alignment: Alignment.center,
        //     underline: Container(
        //       height: 2,
        //       color: Colors.transparent,
        //     ),
        //     onTap: () {
        //       setState(() {
        //         isClicked = !isClicked;
        //       });
        //     },
        //     onChanged: (String? newValue) {
        //       if (newValue != null) {
        //         setState(() {
        //           isClicked = !isClicked;
        //           dropdownValue = newValue;
        //         });
        //       }
        //     },
        //     // selectedItemBuilder: (context) {
        //     //   return items.map<DropdownMenuItem<String>>((String value) {
        //     //     return DropdownMenuItem<String>(
        //     //       value: value,
        //     //       child: SizedBox(width: 120, child: Text(value)),
        //     //     );
        //     //   }).toList();
        //     // },
        //     items: items.map<DropdownMenuItem<String>>((String item) {
        //       return DropdownMenuItem<String>(
        //         value: item,
        //         child: Text(item),
        //       );
        //     }).toList(),
        //   ),
        // ),

        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Row(
              children: [
                const Icon(Icons.list, size: 16, color: lightPinkColor),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    'Select Item',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[200],
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
            buttonStyleData: ButtonStyleData(
              height: 100,
              width: 100,
              padding: const EdgeInsets.only(left: 14, right: 14),
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
                      offset: Offset(
                          -outsideShadowDistance, -outsideShadowDistance),
                      color: Colors.white60,
                      blurRadius: outsideShadowDistance,
                      spreadRadius: 1)
                ],
              ),
              elevation: 2,
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
              width: 140,
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
