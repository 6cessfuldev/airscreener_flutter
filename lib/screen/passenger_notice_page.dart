import 'package:flutter/material.dart';

import '../model/departure_hall_enum.dart';
import '../model/passenger_notice_list.dart';
import '../service/api_service.dart';
import '../widget/passenger_notice/departure_hall_select_box.dart';

class PassengerNoticePage extends StatefulWidget {
  const PassengerNoticePage({super.key});

  @override
  State<PassengerNoticePage> createState() => _PassengerNoticePageState();
}

class _PassengerNoticePageState extends State<PassengerNoticePage> {
  final ApiService _apiService = ApiService();
  bool isLoading = true;
  PassengerNoticeList? passengerNoticeList;
  DepartureHallEnum departureHallEnum = DepartureHallEnum.t1sumset2;
  String? _passengerCntAllDay;

  @override
  void initState() {
    super.initState();
    dataFetch();
  }

  dataFetch() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    PassengerNoticeList dataList =
        await _apiService.getTodayPassengerNoticeList();

    String? passengerCntAllDay;
    if (dataList.status == 200) {
      passengerCntAllDay =
          setPassengerCntByDepartureHall(dataList, departureHallEnum);
    }

    if (mounted) {
      setState(() {
        passengerNoticeList = dataList;
        isLoading = false;
        _passengerCntAllDay = passengerCntAllDay;
      });
    }
  }

  void setDepartureHallEnum(DepartureHallEnum departureHallEnum) {
    setState(() {
      this.departureHallEnum = departureHallEnum;
    });
  }

  String? setPassengerCntByDepartureHall(
      PassengerNoticeList dataList, DepartureHallEnum departureHall) {
    switch (departureHall) {
      case DepartureHallEnum.t1sum1:
        return dataList.items!.last.t1sum1;
      case DepartureHallEnum.t1sum2:
        return dataList.items!.last.t1sum2;
      case DepartureHallEnum.t1sum3:
        return dataList.items!.last.t1sum3;
      case DepartureHallEnum.t1sum4:
        return dataList.items!.last.t1sum4;
      case DepartureHallEnum.t1sumset1:
        return dataList.items!.last.t1sumset1;
      case DepartureHallEnum.t1sum5:
        return dataList.items!.last.t1sum5;
      case DepartureHallEnum.t1sum6:
        return dataList.items!.last.t1sum6;
      case DepartureHallEnum.t1sum7:
        return dataList.items!.last.t1sum7;
      case DepartureHallEnum.t1sum8:
        return dataList.items!.last.t1sum8;
      case DepartureHallEnum.t1sumset2:
        return dataList.items!.last.t1sumset2;
      case DepartureHallEnum.t2sum1:
        return dataList.items!.last.t2sum1;
      case DepartureHallEnum.t2sum2:
        return dataList.items!.last.t2sum2;
      case DepartureHallEnum.t2sumset1:
        return dataList.items!.last.t2sumset1;
      case DepartureHallEnum.t2sum3:
        return dataList.items!.last.t2sum3;
      case DepartureHallEnum.t2sum4:
        return dataList.items!.last.t2sum4;
      case DepartureHallEnum.t2sumset2:
        return dataList.items!.last.t2sumset2;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          DepartureHallSelectBox(
            isLoading: isLoading,
            reload: dataFetch,
            selectedValue: departureHallEnum,
            setSelectedValue: setDepartureHallEnum,
          ),
          const SizedBox(height: 30),
          if (!isLoading && _passengerCntAllDay != null)
            Container(
              child: Column(
                children: [
                  Text(departureHallEnum.toString()),
                  Text(_passengerCntAllDay!),
                ],
              ),
            )
        ],
      ),
    );
  }
}
