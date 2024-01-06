import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

import '../common/style.dart';
import '../model/departing_flights_list.dart';
import '../service/api_service.dart';

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
      child: Container(
        decoration: const BoxDecoration(color: darkBlueColor),
        child: Column(children: [
          // clockContainer(),
          const SizedBox(
            height: 50,
          ),
          headerWidget(),
          const TitleWidget(),
          SelectBox(
              selectedValue: selectedValue, setSelectedValue: setSelectedValue),
          FlightInfoTable(selectedValue: selectedValue),
          const SizedBox(
            height: 50,
          )
        ]),
      ),
    );
  }

  Widget clockContainer() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: lightBlueColor),
        width: screenWidth,
        height: 100,
        child: Center(
          child: DigitalClock(
            showSecondsDigit: false,
            amPmDigitTextStyle: const TextStyle(fontFamily: 'Montserrat'),
            hourMinuteDigitTextStyle: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: peachColor),
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
        ));
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
      height: 300,
      child: Image.asset('assets/images/character.png'),
    );
  }
}

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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            // height: 350,
            child: Container(
              decoration: BoxDecoration(
                color: lightBlueColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Table(
                border: TableBorder.all(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.deepPurple,
                    width: 2.0),
                columnWidths: const <int, TableColumnWidth>{
                  0: FixedColumnWidth(70.0),
                  1: FixedColumnWidth(120.0),
                  2: FixedColumnWidth(150.0),
                  3: FixedColumnWidth(80.0),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  if (snapshot.connectionState != ConnectionState.waiting &&
                      !snapshot.hasError)
                    ...?snapshot.data?.items?.map((info) => TableRow(children: [
                          Center(child: Text(info.chkinrange ?? '')),
                          Center(child: Text(info.airline ?? '')),
                          Center(child: Text(info.scheduleDateTime ?? '')),
                          Center(child: Text(info.estimatedDateTime ?? '')),
                        ]))
                ],
              ),
            ),
          );
        });
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: const Row(
            children: [
              Icon(Icons.list, size: 16, color: lightPinkColor),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  'Select Item',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: lightPinkColor,
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
            height: 50,
            width: 100,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.black26,
              ),
              color: lightBlueColor,
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
              color: lightBlueColor,
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
    );
  }
}
