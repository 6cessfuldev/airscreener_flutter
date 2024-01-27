import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../common/style.dart';

class CheckInCounterSelectBox extends StatefulWidget {
  const CheckInCounterSelectBox(
      {super.key,
      required this.isLoading,
      required this.reload,
      required this.selectedValue,
      required this.setSelectedValue});

  final bool isLoading;
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
        width: 80,
        height: 40,
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
                      color: fontColor,
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: fontColor,
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
                boxShadow: isClicked || widget.isLoading
                    ? null
                    : [
                        BoxShadow(
                            offset: const Offset(
                                outsideShadowDistance, outsideShadowDistance),
                            color: downsideShadowColor,
                            blurRadius: outsideShadowDistance,
                            spreadRadius: 2),
                        const BoxShadow(
                            offset: Offset(
                                -outsideShadowDistance, -outsideShadowDistance),
                            color: upsideShadowColor,
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
              iconEnabledColor: mainBlueColor,
              iconDisabledColor: Colors.grey,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: lightBlueColor.withOpacity(0.5),
              ),
              offset: const Offset(0, 0),
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
