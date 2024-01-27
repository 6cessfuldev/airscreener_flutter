import '../model/departing_flights_list.dart';

class FlightsInfoProvider {
  List<DepartingFlightsInfo> _dataList = [];

  List<DepartingFlightsInfo> get dataList => _dataList;

  void setFlightsInfos(List<DepartingFlightsInfo> data) {
    _dataList = data;
  }
}
