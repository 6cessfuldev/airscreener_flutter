import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
}
