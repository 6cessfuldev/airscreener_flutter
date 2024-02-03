import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/style.dart';
import '../model/departing_flights_list.dart';
import '../service/api_service.dart';

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
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dataFetch();
  }

  Future<void> dataFetch() async {
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
    DateFormat format = DateFormat('yyyyMMddHHmm');
    try {
      return format.parse(strDate);
    } catch (e) {
      debugPrint('Failed DateFormat parsing');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('항공편 상세',
            style:
                TextStyle(color: mainBlueColor, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(onPressed: dataFetch, icon: const Icon(Icons.refresh))
        ],
      ),
      body: SizedBox(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Text(
                    "${widget.flightId} ${widget.scheduleDateTime} ${widget.estimatedDateTime}")),
            if (!isLoading) Text(_dataList[0].chkinrange.toString())
          ],
        ),
      ),
    );
  }
}
