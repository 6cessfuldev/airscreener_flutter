import 'package:flutter/material.dart';

import '../screen/flight_info_detail_page.dart';
import 'arguments.dart';

class RouteManager {
  static const String homePage = '/';
  static const String screenA = '/screenA';
  static const String screenB = '/screenB';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case 'FlightInfoDetailPage':
        FlightInfoDetailArgument argument = args as FlightInfoDetailArgument;
        return MaterialPageRoute(
            builder: (context) => FlightInfoDetailPage(
                  flightid: argument.flightId,
                  scheduleDateTime: argument.scheduleDateTime,
                  estimatedDateTime: argument.estimatedDateTime,
                ));
      default:
        throw const FormatException(
            'Route not found! Check route names again.');
    }
  }
}
