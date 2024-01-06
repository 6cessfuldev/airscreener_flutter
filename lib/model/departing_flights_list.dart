import 'package:json_annotation/json_annotation.dart';

part 'departing_flights_list.g.dart';

class DepartingFlightsList {
  final int? status;
  final List<DepartingFlightsInfo>? items;

  DepartingFlightsList({this.status, this.items});

  factory DepartingFlightsList.fromJson(Map<String, dynamic> json) {
    return DepartingFlightsList(
      status: json['status'],
      items:  (json['items'])?.map<DepartingFlightsInfo>((data) => DepartingFlightsInfo.fromJson(data))
            .toList()
    );
  }
      
}

@JsonSerializable()
class DepartingFlightsInfo {
  final String? airline;
  final String? flightId;
  final String? scheduleDateTime;
  final String? estimatedDateTime;
  final String? airport;
  final String? chkinrange;
  final String? gatenumber;
  final String? codeshare;
  final String? masterflightid;
  final String? remark;
  final String? airportCode;
  final String? terminalid;
  final String? typeOfFlight;
  final String? fid;
  final String? fstandposition;

  DepartingFlightsInfo({
    this.airline, 
    this.flightId, 
    this.scheduleDateTime, 
    this.estimatedDateTime, 
    this.airport, 
    this.chkinrange, 
    this.gatenumber, 
    this.codeshare, 
    this.masterflightid, 
    this.remark, 
    this.airportCode, 
    this.terminalid, 
    this.typeOfFlight, 
    this.fid, 
    this.fstandposition,
  });

  factory DepartingFlightsInfo.fromJson(Map<String, dynamic> json) =>
      _$DepartingFlightsInfoFromJson(json);

}
