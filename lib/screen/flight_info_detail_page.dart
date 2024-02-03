import 'package:flutter/material.dart';

class FlightInfoDetailPage extends StatelessWidget {
  const FlightInfoDetailPage({required this.flightid, super.key});

  final String flightid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(flightid)),
    );
  }
}
