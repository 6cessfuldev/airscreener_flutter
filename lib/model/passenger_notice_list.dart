import 'package:json_annotation/json_annotation.dart';

part 'passenger_notice_list.g.dart';

class PassengerNoticeList {
  final int? status;
  final List<PassengerNoticeByTime>? items;

  PassengerNoticeList({this.status, this.items});

  factory PassengerNoticeList.fromJson(Map<String, dynamic> json) {
    return PassengerNoticeList(
        status: json['status'],
        items: (json['items'])
            ?.map<PassengerNoticeByTime>(
                (data) => PassengerNoticeByTime.fromJson(data))
            .toList());
  }
}

@JsonSerializable()
class PassengerNoticeByTime {
  final String? adate;
  final String? atime;
  final String? t1sum2;
  final String? t1sum3;
  final String? t1sum1;
  final String? t1sum4;
  final String? t1sumset1;
  final String? t1sum5;
  final String? t1sum6;
  final String? t1sum7;
  final String? t1sum8;
  final String? t1sumset2;
  final String? t2sum1;
  final String? t2sum2;
  final String? t2sumset1;
  final String? t2sum3;
  final String? t2sum4;
  final String? t2sumset2;

  PassengerNoticeByTime(
      {this.adate,
      this.atime,
      this.t1sum1,
      this.t1sum2,
      this.t1sum3,
      this.t1sum4,
      this.t1sumset1,
      this.t1sum5,
      this.t1sum6,
      this.t1sum7,
      this.t1sum8,
      this.t1sumset2,
      this.t2sum1,
      this.t2sum2,
      this.t2sumset1,
      this.t2sum3,
      this.t2sum4,
      this.t2sumset2});

  factory PassengerNoticeByTime.fromJson(Map<String, dynamic> json) =>
      _$PassengerNoticeByTimeFromJson(json);
}
