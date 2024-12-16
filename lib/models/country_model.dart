class Country {
  final String flag;
  final String country;
  final String code;

  Country({required this.flag, required this.country, required this.code});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      flag: json['flag'] ?? '', // Provide a default value if null
      country: json['country'] ?? 'Unknown',
      code: json['code'] ?? 'N/A',
    );
  }
}
