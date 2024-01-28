import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/departing_flights_list.dart';

class ApiService {
  //인천국제공항공사_여객기 운항 현황 상세 조회 서비스(출발)
  final String _departingFlightsListPath =
      'http://apis.data.go.kr/B551177/StatusOfPassengerFlightsDeOdp/getPassengerDeparturesDeOdp';

  final String _departingFlightsListKey = dotenv.env['PassengerFlightsDeOdp']!;

  //인천국제공항공사_여객기 운항 현황 상세 조회 서비스(출발)
  Future<DepartingFlightsList> getDepartingFlightsList(
      Map<String, dynamic> request,
      {defaultData = false}) async {
    String path = _departingFlightsListPath;
    request['serviceKey'] = _departingFlightsListKey;
    try {
      var response = await http.get(
        Uri.parse(path).replace(
            queryParameters: request.map((key, value) =>
                MapEntry<String, dynamic>(key.toString(), value.toString()))),
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return DepartingFlightsList.fromJson(
            {'status': 200, "items": jsonData['response']['body']['items']});
      } else {
        return DepartingFlightsList.fromJson(
            {'status': response.statusCode, "items": []});
      }
    } on Exception catch (_) {
      return DepartingFlightsList.fromJson({'status': 404, "items": []});
    }
  }

  Future<List<DepartingFlightsInfo>> getFlightsInfoToTomorrow() async {
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
    tasks.add(getDepartingFlightsList(todayRequest, defaultData: {}));
    tasks.add(getDepartingFlightsList(tommorowRequest, defaultData: {}));

    List responseList = await Future.wait(tasks);

    List<DepartingFlightsInfo> resultList = [];
    if (responseList[0].status == 200) {
      resultList.addAll(responseList[0].items);
    }
    if (responseList[1].status == 200) {
      resultList.addAll(responseList[1].items);
    }

    return resultList;
  }

  Future<List<DepartingFlightsInfo>> getFlightsInfoSearch(
      String keyword) async {
    Map<String, dynamic> todayRequest = {
      'pageNo': 1,
      'numOfRows': 4000,
      'type': 'json',
      'from_time': DateFormat('HHmm').format(DateTime.now()).toString(),
      'searchday': DateFormat('yyyyMMdd').format(DateTime.now()).toString(),
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
          .toString(),
    };

    List<Future> tasks = [];
    tasks.add(getDepartingFlightsList(todayRequest, defaultData: {}));
    tasks.add(getDepartingFlightsList(tommorowRequest, defaultData: {}));

    List responseList = await Future.wait(tasks);

    List<DepartingFlightsInfo> resultList = [];
    if (responseList[0].status == 200) {
      resultList.addAll(responseList[0].items);
    }
    if (responseList[1].status == 200) {
      resultList.addAll(responseList[1].items);
    }

    resultList.where((info) {
      if (info.flightId != null) {
        return info.flightId!.contains(keyword.toUpperCase());
      } else {
        return false;
      }
    });

    debugPrint('[API] getFlightsInfoSearch length : ${resultList.length}');
    return resultList;
  }
}
