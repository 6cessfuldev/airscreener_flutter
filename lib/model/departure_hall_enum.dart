enum DepartureHallEnum {
  t1sum1,
  t1sum2,
  t1sum3,
  t1sum4,
  t1sumset1,
  t1sum5,
  t1sum6,
  t1sum7,
  t1sum8,
  t1sumset2,
  t2sum1,
  t2sum2,
  t2sumset1,
  t2sum3,
  t2sum4,
  t2sumset2;

  String get convertEnumToStr {
    switch (this) {
      case DepartureHallEnum.t1sum1:
        return 'T1 입국장 A,B';
      case DepartureHallEnum.t1sum2:
        return 'T1 입국장 E,F';
      case DepartureHallEnum.t1sum3:
        return 'T1 입국장 C';
      case DepartureHallEnum.t1sum4:
        return 'T1 입국장 D';
      case DepartureHallEnum.t1sumset1:
        return 'T1 입국장 전체';
      case DepartureHallEnum.t1sum5:
        return 'T1 출국장 1,2';
      case DepartureHallEnum.t1sum6:
        return 'T1 출국장 3';
      case DepartureHallEnum.t1sum7:
        return 'T1 출국장 4';
      case DepartureHallEnum.t1sum8:
        return 'T1 출국장 5,6';
      case DepartureHallEnum.t1sumset2:
        return 'T1 출국장 전체';
      case DepartureHallEnum.t2sum1:
        return 'T2 입국장 A';
      case DepartureHallEnum.t2sum2:
        return 'T2 입국장 B';
      case DepartureHallEnum.t2sumset1:
        return 'T2 입국장 전체';
      case DepartureHallEnum.t2sum3:
        return 'T2 출국장 1';
      case DepartureHallEnum.t2sum4:
        return 'T2 출국장 2';
      case DepartureHallEnum.t2sumset2:
        return 'T2 출국장 전체';
      default:
        return '';
    }
  }

  static DepartureHallEnum? convertStrToEnum(String str) {
    switch (str) {
      case 'T1 입국장 A,B':
        return DepartureHallEnum.t1sum1;
      case 'T1 입국장 E,F':
        return DepartureHallEnum.t1sum2;
      case 'T1 입국장 C':
        return DepartureHallEnum.t1sum3;
      case 'T1 입국장 D':
        return DepartureHallEnum.t1sum4;
      case 'T1 입국장 전체':
        return DepartureHallEnum.t1sumset1;
      case 'T1 출국장 1,2':
        return DepartureHallEnum.t1sum5;
      case 'T1 출국장 3':
        return DepartureHallEnum.t1sum6;
      case 'T1 출국장 4':
        return DepartureHallEnum.t1sum7;
      case 'T1 출국장 5,6':
        return DepartureHallEnum.t1sum8;
      case 'T1 출국장 전체':
        return DepartureHallEnum.t1sumset2;
      case 'T2 입국장 A':
        return DepartureHallEnum.t2sum1;
      case 'T2 입국장 B':
        return DepartureHallEnum.t2sum2;
      case 'T2 입국장 전체':
        return DepartureHallEnum.t2sumset1;
      case 'T2 출국장 1':
        return DepartureHallEnum.t2sum3;
      case 'T2 출국장 2':
        return DepartureHallEnum.t2sum4;
      case 'T2 출국장 전체':
        return DepartureHallEnum.t2sumset2;
      default:
        return null;
    }
  }
}
