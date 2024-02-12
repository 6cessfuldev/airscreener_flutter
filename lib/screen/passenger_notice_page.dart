import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../common/style.dart';
import '../model/departure_hall_enum.dart';
import '../model/passenger_notice_list.dart';
import '../service/api_service.dart';
import '../widget/passenger_notice/animated_count_text.dart';
import '../widget/passenger_notice/animated_face_icon.dart';
import '../widget/passenger_notice/departure_hall_animation.dart';

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
  IconData? _faceIcon;

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
        _faceIcon = getIconByPassengerCnt(passengerCntAllDay);
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

  IconData getIconByPassengerCnt(String? passengerCnt) {
    if (passengerCnt == null) return FontAwesomeIcons.question;

    try {
      double cnt = double.parse(passengerCnt);

      if (cnt < 60000) {
        return FontAwesomeIcons.faceLaugh;
      } else {
        return FontAwesomeIcons.faceDizzy;
      }
    } catch (e) {
      print(e);
      return FontAwesomeIcons.question;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.constrainHeight();
      double animationHeight = 250;
      return Container(
        height: maxHeight,
        width: MediaQuery.of(context).size.width,
        color: darkestBlueColor,
        child: Column(
          children: [
            !isLoading && _passengerCntAllDay != null
                ? Container(
                    height: (maxHeight - animationHeight) / 2,
                    width: MediaQuery.of(context).size.width,
                    color: darkestBlueColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AnimatedFaceIcon(delay: 2, icon: _faceIcon!),
                        AnimatedCountText(
                            count: double.parse(_passengerCntAllDay!).round(),
                            duration: 2),
                      ],
                    ),
                  )
                : SizedBox(height: (maxHeight - animationHeight) / 2),
            DepartureHallAnimation(
                height: animationHeight,
                isLoading: isLoading,
                passengerCnt: _passengerCntAllDay),
            Container(
              height: (maxHeight - animationHeight) / 2,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: const Text(
                '안녕',
                style: TextStyle(color: lightestBlueColor, fontSize: 50),
              ),
            ),
          ],
        ),
      );
    });
  }
}
