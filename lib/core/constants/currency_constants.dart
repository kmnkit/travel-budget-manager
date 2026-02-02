// ignore_for_file: constant_identifier_names
enum SupportedCurrency {
  KRW('KRW', '₩', '대한민국 원', 'Korean Won', 0),
  USD('USD', '\$', '미국 달러', 'US Dollar', 2),
  EUR('EUR', '€', '유로', 'Euro', 2),
  JPY('JPY', '¥', '일본 엔', 'Japanese Yen', 0),
  GBP('GBP', '£', '영국 파운드', 'British Pound', 2),
  AUD('AUD', 'A\$', '호주 달러', 'Australian Dollar', 2),
  CAD('CAD', 'C\$', '캐나다 달러', 'Canadian Dollar', 2);

  const SupportedCurrency(this.code, this.symbol, this.nameKo, this.nameEn, this.decimalPlaces);

  final String code;
  final String symbol;
  final String nameKo;
  final String nameEn;
  final int decimalPlaces;

  static SupportedCurrency fromCode(String code) {
    return SupportedCurrency.values.firstWhere(
      (c) => c.code == code.toUpperCase(),
      orElse: () => SupportedCurrency.USD,
    );
  }

  static List<String> get codes => values.map((c) => c.code).toList();
}
