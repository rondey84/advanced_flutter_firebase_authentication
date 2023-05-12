
part of 'country_picker.dart';

class Country {
  final String countryCode, phoneCode, name;

  Country({
    required this.countryCode,
    required this.phoneCode,
    required this.name,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryCode: json['e164_cc'],
      phoneCode: json['iso2_cc'],
      name: json['name'],
    );
  }
}
