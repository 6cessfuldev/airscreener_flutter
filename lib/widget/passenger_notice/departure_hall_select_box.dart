import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../common/style.dart';
import '../../model/departure_hall_enum.dart';

class DepartureHallSelectBox extends StatefulWidget {
  const DepartureHallSelectBox(
      {super.key,
      required this.isLoading,
      required this.reload,
      required this.selectedValue,
      required this.setSelectedValue});

  final bool isLoading;
  final Function reload;
  final DepartureHallEnum? selectedValue;
  final Function setSelectedValue;

  @override
  State<DepartureHallSelectBox> createState() => _DepartureHallSelectBoxState();
}

class _DepartureHallSelectBoxState extends State<DepartureHallSelectBox> {
  List<DepartureHallEnum> items = DepartureHallEnum.values;

  bool isClicked = false;
  bool isSelected = false;
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(outsideShadowDistance),
      child: SizedBox(
        // padding: const EdgeInsets.symmetric(vertical: 30.0),
        width: 150,
        height: 40,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: const Row(
              children: [
                Expanded(
                  child: Text(
                    '출국장',
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
                .map((DepartureHallEnum item) => DropdownMenuItem<String>(
                      value: item.convertEnumToStr,
                      child: Text(
                        item.convertEnumToStr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: fontColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            value: widget.selectedValue?.convertEnumToStr,
            onChanged: (value) {
              if (value != null) {
                widget.setSelectedValue(
                    DepartureHallEnum.convertStrToEnum(value));
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
              width: 150,
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
