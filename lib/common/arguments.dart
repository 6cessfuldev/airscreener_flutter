class FlightInfoDetailArgument {
  final String flightId;
  final String scheduleDateTime;
  final String? estimatedDateTime;

  FlightInfoDetailArgument(
      {required this.flightId,
      required this.scheduleDateTime,
      this.estimatedDateTime});
}
