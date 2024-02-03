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
        debugPrint("[API] error ... status : ${response.statusCode} ");
        return DepartingFlightsList.fromJson(
            {'status': response.statusCode, "items": []});
      }
    } on Exception catch (_) {
      debugPrint("[API] error ... request : $request");
      return DepartingFlightsList.fromJson({'status': 404, "items": []});
    }
  }

  List<Map<String, dynamic>> makeRequestList(DateTime from, DateTime to) {
    List<Map<String, dynamic>> requestList = [];
    for (var i = 0; i < to.day - from.day + 1; i++) {
      Map<String, dynamic> request = {
        'pageNo': 1,
        'numOfRows': 4000,
        'type': 'json',
        'searchday': DateFormat('yyyyMMdd')
            .format(from.add(Duration(days: i)))
            .toString()
      };
      if (i == 0) {
        request
            .addAll({'from_time': DateFormat('HHmm').format(from).toString()});
      } else if (i == to.day - from.day) {
        request.addAll({
          'to_time': DateFormat('HHmm')
              .format(DateTime.now().add(const Duration(hours: 24)))
              .toString()
        });
      }
      requestList.add(request);
    }
    return requestList;
  }

  Future<List<DepartingFlightsInfo>> getFlightsInfoByFlightId(String flightId,
      {DateTime? from, DateTime? to}) async {
    from ??= DateTime.now().subtract(const Duration(days: 1));
    to ??= DateTime.now().add(const Duration(days: 1));

    List<Map<String, dynamic>> requestList = makeRequestList(from, to);

    List<Future> tasks = [];
    tasks = requestList.map((e) {
      return getDepartingFlightsList(e, defaultData: {});
    }).toList();

    List responseList = await Future.wait(tasks);

    List<DepartingFlightsInfo> resultList = [];

    resultList = responseList
        .where((e) => e.status == 200)
        .expand<DepartingFlightsInfo>((e) => e.items)
        .toList();
    return resultList;
  }

  Future<List<DepartingFlightsInfo>> getFlightsInfoByTime(
      DateTime from, DateTime to) async {
    if (from.isAfter(to)) return [];

    List<Map<String, dynamic>> requestList = makeRequestList(from, to);

    List<Future> tasks = [];
    tasks = requestList.map((e) {
      return getDepartingFlightsList(e, defaultData: {});
    }).toList();

    List responseList = await Future.wait(tasks);

    List<DepartingFlightsInfo> resultList = [];

    resultList = responseList
        .where((e) => e.status == 200)
        .expand<DepartingFlightsInfo>((e) => e.items)
        .toList();
    return resultList;
  }

  Future<List<DepartingFlightsInfo>> getFlightsInfoToTomorrow() async {
    return await getFlightsInfoByTime(
        DateTime.now(), DateTime.now().add(const Duration(days: 1)));
  }

  Future<List<DepartingFlightsInfo>> getFlightsInfoSearch(
      String keyword) async {
    List<DepartingFlightsInfo> resultList = await getFlightsInfoByTime(
        DateTime.now().subtract(const Duration(days: 1)),
        DateTime.now().add(const Duration(days: 1)));

    resultList = resultList.where((info) {
      if (info.flightId != null) {
        return info.flightId!.contains(keyword.toUpperCase());
      } else {
        return false;
      }
    }).toList();

    debugPrint(
        '[API] getFlightsInfoSearch length : ${resultList.length} keyword : $keyword');
    return resultList;
  }
}
