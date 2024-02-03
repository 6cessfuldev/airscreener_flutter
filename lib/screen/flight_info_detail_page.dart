import 'package:flutter/material.dart';

class FlightInfoDetailPage extends StatelessWidget {
  const FlightInfoDetailPage(
      {required this.flightid,
      required this.scheduleDateTime,
      required this.estimatedDateTime,
      super.key});

  final String flightid;
  final String scheduleDateTime;
  final String? estimatedDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Center(child: Text("$flightid $scheduleDateTime $estimatedDateTime")),
    );
  }
}
