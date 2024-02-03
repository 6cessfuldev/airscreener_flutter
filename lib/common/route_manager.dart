import 'package:flutter/material.dart';

import '../screen/flight_info_detail_page.dart';

class RouteManager {
  static const String homePage = '/';
  static const String screenA = '/screenA';
  static const String screenB = '/screenB';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'FlightInfoDetailPage':
        return MaterialPageRoute(
            builder: (context) => const FlightInfoDetailPage());
      default:
        throw const FormatException(
            'Route not found! Check route names again.');
    }
  }
}
