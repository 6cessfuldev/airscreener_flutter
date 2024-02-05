import 'package:flutter/material.dart';

import '../common/style.dart';
import '../model/departing_flights_list.dart';
import '../service/api_service.dart';
import '../service/data_service.dart';
import 'package:url_launcher/url_launcher.dart';

class FlightInfoDetailPage extends StatefulWidget {
  const FlightInfoDetailPage(
      {required this.flightId,
      required this.scheduleDateTime,
      required this.estimatedDateTime,
      super.key});

  final String flightId;
  final String scheduleDateTime;
  final String? estimatedDateTime;

  @override
  State<FlightInfoDetailPage> createState() => _FlightInfoDetailPageState();
}

class _FlightInfoDetailPageState extends State<FlightInfoDetailPage> {
  List<DepartingFlightsInfo> _dataList = [];
  final DataService _dataService = DataService();
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dataFetch();
  }

  Future<void> dataFetch() async {
    if (!isLoading && mounted) {
      setState(() {
        isLoading = true;
      });
    }
    List<DepartingFlightsInfo> dataList = await ApiService()
        .getFlightsInfoByFlightId(widget.flightId,
            from: convertStringToDate(widget.scheduleDateTime));

    if (mounted) {
      setState(() {
        _dataList = dataList;
        isLoading = false;
      });
    }
  }

  DateTime? convertStringToDate(String strDate) {
    try {
      String yyyyMMdd = strDate.substring(0, 8);
      int hour = int.parse(strDate.substring(8, 10));
      int minute = int.parse(strDate.substring(10, 12));
      return DateTime.parse(yyyyMMdd)
          .add(Duration(hours: hour))
          .add(Duration(minutes: minute));
    } catch (e) {
      debugPrint('Failed DateFormat parsing');
      return null;
    }
  }

  String formatyyyyMMddDate(String? yyyyMMddHHmm) {
    if (yyyyMMddHHmm == null ||
        yyyyMMddHHmm == '' ||
        yyyyMMddHHmm.length < 12) {
      return '';
    }
    return '${yyyyMMddHHmm.substring(0, 4)}-'
        '${yyyyMMddHHmm.substring(4, 6)}-'
        '${yyyyMMddHHmm.substring(6, 8)}';
  }

  String formatHHmmDate(String? yyyyMMddHHmm) {
    if (yyyyMMddHHmm == null ||
        yyyyMMddHHmm == '' ||
        yyyyMMddHHmm.length < 12) {
      return '';
    }
    return '${yyyyMMddHHmm.substring(8, 10)}:${yyyyMMddHHmm.substring(10, 12)}';
  }

  @override
  Widget build(BuildContext context) {
    DepartingFlightsInfo? data;
    if (!isLoading && _dataList.isNotEmpty) data = _dataList[0];

    return Stack(
      children: [
        Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            centerTitle: true,
            title: const Text('항공편 상세정보',
                style: TextStyle(
                    color: mainBlueColor, fontWeight: FontWeight.w600)),
            actions: [
              IconButton(onPressed: dataFetch, icon: const Icon(Icons.refresh)),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_outlined),
              )
            ],
          ),
          body: !isLoading && _dataList.isEmpty
              ? const Expanded(
                  child: Center(
                      child: Text(
                  'Data Error...',
                  style: TextStyle(fontSize: 40),
                )))
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      margin: const EdgeInsets.all(outsideShadowDistance),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(outsideShadowDistance,
                                    outsideShadowDistance),
                                color: downsideShadowColor,
                                blurRadius: outsideShadowDistance,
                                spreadRadius: 3),
                            const BoxShadow(
                                offset: Offset(-outsideShadowDistance,
                                    -outsideShadowDistance),
                                color: upsideShadowColor,
                                blurRadius: outsideShadowDistance,
                                spreadRadius: 3)
                          ]),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                            decoration: const BoxDecoration(
                                color: darkBlueColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        data?.airline ?? '',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      remarkWidget(isLoading, _dataList),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        data?.flightId ?? '',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(width: 15),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        formatyyyyMMddDate(
                                            data?.scheduleDateTime),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        formatHHmmDate(data?.scheduleDateTime),
                                        style: TextStyle(
                                            color: Colors.white,
                                            decoration:
                                                data?.scheduleDateTime !=
                                                        data?.estimatedDateTime
                                                    ? TextDecoration.lineThrough
                                                    : null),
                                      ),
                                      if (data?.scheduleDateTime !=
                                          data?.estimatedDateTime)
                                        Text(
                                          ' -> ${formatHHmmDate(data?.estimatedDateTime)}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.place,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        data?.airport ?? '',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    ],
                                  )
                                ]),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: lightBlueColor,
                                border:
                                    Border.all(width: 0.5, color: Colors.grey),
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                            child: Column(children: [
                              if (data?.masterflightid != null &&
                                  data?.masterflightid != '')
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.white60,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: lightestBlueColor,
                                          width: 0.5)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      itemWiget(
                                          const Icon(
                                              Icons.airplanemode_active_sharp),
                                          '예약편명',
                                          data?.flightId ?? ''),
                                      const VerticalDivider(
                                        color: mainBlueColor,
                                        width: 1,
                                        thickness: 1,
                                        indent: 10,
                                        endIndent: 10,
                                      ),
                                      itemWiget(
                                          const Icon(
                                              Icons.airplanemode_active_sharp),
                                          '탑승편명',
                                          data?.masterflightid ?? ''),
                                    ],
                                  ),
                                ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                height: 80,
                                decoration: BoxDecoration(
                                    color: Colors.white60,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: lightestBlueColor, width: 0.5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    itemWiget(
                                        const Icon(Icons.luggage_outlined),
                                        '체크인카운터',
                                        data?.chkinrange ?? ''),
                                    const VerticalDivider(
                                      color: mainBlueColor,
                                      width: 1,
                                      thickness: 1,
                                      indent: 10,
                                      endIndent: 10,
                                    ),
                                    itemWiget(const Icon(Icons.stairs_outlined),
                                        '탑승구', data?.gatenumber ?? ''),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                height: 80,
                                decoration: BoxDecoration(
                                    color: Colors.white60,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: lightestBlueColor, width: 0.5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    itemWiget(const Icon(Icons.alt_route),
                                        '터미널', data?.terminalid ?? ''),
                                    const VerticalDivider(
                                      color: mainBlueColor,
                                      width: 1,
                                      thickness: 1,
                                      indent: 10,
                                      endIndent: 10,
                                    ),
                                    itemWithBtnWiget(
                                        const Icon(
                                            Icons.airplane_ticket_outlined),
                                        '항공사 전화연결', () async {
                                      try {
                                        final Uri launchUri = Uri(
                                            scheme: 'tel',
                                            path: _dataService.airlineCallNum[
                                                data?.airline!]);
                                        await launchUrl(launchUri);
                                      } catch (e) {
                                        debugPrint(e.toString());
                                      }
                                    }),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
        loadingWidget(isLoading)
      ],
    );
  }

  Widget loadingWidget(bool isLoading) {
    return isLoading
        ? Positioned(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: const Color.fromRGBO(0, 0, 0, 0.5), // 반투명 검정색
              child: Center(
                child: Image.asset(
                  'assets/images/character.png',
                  width: 70,
                  height: 70,
                ), // 로딩 인디케이터
              ),
            ),
          )
        : Container();
  }

  Widget remarkWidget(bool isLoading, List<DepartingFlightsInfo> dataList) {
    if (isLoading || dataList.isEmpty || dataList[0].remark == null) {
      return const SizedBox(height: 25, width: 100);
    } else {
      late Color bgColor;
      late Color fontColor;
      switch (dataList[0].remark!) {
        case '출발':
          bgColor = Colors.green;
          fontColor = darkestBlueColor;
          break;
        case '결항':
          bgColor = Colors.red;
          fontColor = Colors.black;
          break;
        case '지연':
          bgColor = Colors.yellow;
          fontColor = Colors.black;
          break;
        case '탑승중':
          bgColor = lightestBlueColor;
          fontColor = darkestBlueColor;
          break;
        case '마감예정':
          bgColor = lightBlueColor;
          fontColor = darkestBlueColor;
          break;
        case '탑승마감':
          bgColor = mainBlueColor;
          fontColor = darkestBlueColor;
          break;
        case '탑승준비':
          bgColor = Colors.green;
          fontColor = Colors.white;
          break;
        default:
          bgColor = Colors.white;
          fontColor = darkestBlueColor;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        height: 25,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: bgColor),
        child: Text(
          dataList[0].remark ?? '',
          style: TextStyle(
              color: fontColor, fontWeight: FontWeight.w700, letterSpacing: 2),
        ),
      );
    }
  }

  Widget itemWiget(Icon icon, String title, String contents) {
    return Expanded(
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: icon,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: mainBlueColor),
            ),
            Text(contents,
                style: const TextStyle(fontSize: 17, color: darkestBlueColor)),
          ],
        )
      ]),
    );
  }

  Widget itemWithBtnWiget(Icon icon, String title, Function callback) {
    return Expanded(
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: icon,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => callback(),
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
