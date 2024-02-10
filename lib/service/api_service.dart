import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/departing_flights_list.dart';
import '../model/passenger_notice_list.dart';

class ApiService {
  //인천국제공항공사_여객기 운항 현황 상세 조회 서비스(출발)
  final String _departingFlightsListPath =
      'http://apis.data.go.kr/B551177/StatusOfPassengerFlightsDeOdp/getPassengerDeparturesDeOdp';

  final String _passengerNoticeListPath =
      'http://apis.data.go.kr/B551177/PassengerNoticeKR/getfPassengerNoticeIKR';

  final String _departingFlightsListKey = dotenv.env['PassengerFlightsDeOdp']!;

  final String _passenegerNoticeListKey = dotenv.env['PassengerNotice']!;

  Future ajaxGet(String path, Map<String, dynamic> request) async {
    return await http.get(
      Uri.parse(path).replace(
          queryParameters: request.map((key, value) =>
              MapEntry<String, dynamic>(key.toString(), value.toString()))),
    );
  }

  //인천국제공항공사_여객기 운항 현황 상세 조회 서비스(출발)
  Future<DepartingFlightsList> getDepartingFlightsList(
      Map<String, dynamic> request,
      {defaultData = false}) async {
    debugPrint('[API] request : $request');
    String path = _departingFlightsListPath;
    request['serviceKey'] = _departingFlightsListKey;

    try {
      var response = await ajaxGet(path, request);
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

  List<Map<String, dynamic>> makeFlightInfoRequestList(
      DateTime? from, DateTime? to,
      {String? flightId, int? length, String timetype = 'E'}) {
    List<Map<String, dynamic>> requestList = [];
    if (from != null && to != null) {
      for (var i = 0; i < to.day - from.day + 1; i++) {
        Map<String, dynamic> request = {
          'pageNo': 1,
          'numOfRows': length ?? 4000,
          'type': 'json',
          'searchday': DateFormat('yyyyMMdd')
              .format(from.add(Duration(days: i)))
              .toString(),
          'inqtimechcd': timetype
        };
        if (i == 0) {
          request['from_time'] = DateFormat('HHmm').format(from).toString();
        } else if (i == to.day - from.day) {
          request['to_time'] = DateFormat('HHmm')
              .format(DateTime.now().add(const Duration(hours: 24)))
              .toString();
        }
        if (flightId != null) request['flight_id'] = flightId;

        requestList.add(request);
      }
    } else if (from != null && to == null) {
      Map<String, dynamic> request = {
        'pageNo': 1,
        'numOfRows': length ?? 4000,
        'type': 'json',
        'from_time': DateFormat('HHmm').format(from).toString(),
        'searchday': DateFormat('yyyyMMdd').format(from).toString(),
        'inqtimechcd': timetype
      };
      if (flightId != null) request['flight_id'] = flightId;
      requestList.add(request);
    } else {
      Map<String, dynamic> request = {
        'pageNo': 1,
        'numOfRows': length ?? 4000,
        'type': 'json',
        'searchday': DateFormat('yyyyMMdd').format(DateTime.now()).toString(),
        'inqtimechcd': timetype
      };
      if (flightId != null) request['flight_id'] = flightId;
      requestList.add(request);
    }
    return requestList;
  }

  Future<List<DepartingFlightsInfo>> getFlightsInfoByFlightId(String flightId,
      {DateTime? from,
      DateTime? to,
      int? length,
      String timeType = 'S'}) async {
    List<Map<String, dynamic>> requestList = makeFlightInfoRequestList(from, to,
        flightId: flightId, length: length, timetype: timeType);

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

    List<Map<String, dynamic>> requestList =
        makeFlightInfoRequestList(from, to);

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

  /// 인천국제공항공사 출입국별 승객예고 조회 서비스
  Future<PassengerNoticeList> getPassengerNoticeList(
      Map<String, dynamic> request,
      {defaultData = false}) async {
    debugPrint('[API] request : $request');
    String path = _passengerNoticeListPath;
    request['serviceKey'] = _passenegerNoticeListKey;
    request['type'] = 'json';

    try {
      var response = await ajaxGet(path, request);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return PassengerNoticeList.fromJson(
            {'status': 200, "items": jsonData['response']['body']['items']});
      } else {
        debugPrint("[API] error ... status : ${response.statusCode} ");
        return PassengerNoticeList.fromJson(
            {'status': response.statusCode, "items": []});
      }
    } on Exception catch (_) {
      debugPrint("[API] error ... request : $request");
      return PassengerNoticeList.fromJson({'status': 404, "items": []});
    }
  }

  Future<PassengerNoticeList> getTodayPassengerNoticeList() async {
    return await getPassengerNoticeList({'selectdate': '0'});
  }

  Future<PassengerNoticeList> getTomorrowPassengerNoticeList() async {
    return await getPassengerNoticeList({'selectdate': '1'});
  }
}
