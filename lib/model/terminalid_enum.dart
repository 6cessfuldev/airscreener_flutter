enum TerminalidEnum {
  p01,
  p02;

  String get convertEnumToStr {
    switch (this) {
      case TerminalidEnum.p01:
        return '제1터미널';
      case TerminalidEnum.p02:
        return '제2터미널';
      default:
        return '';
    }
  }

  static TerminalidEnum? convertStrToEnum(String str) {
    switch (str) {
      case '제1터미널':
        return TerminalidEnum.p01;
      case '제2터미널':
        return TerminalidEnum.p02;
      default:
        return null;
    }
  }
}
