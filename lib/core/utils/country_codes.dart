class Country {
  final String name;
  final String code;
  final String flag;

  Country({required this.name, required this.code, required this.flag});
}

class CountryCodes {
  static List<Country> getCountries() {
    return [
      Country(name: 'India', code: '+91', flag: '🇮🇳'),
      // Country(name: 'Bangladesh', code: '+880', flag: '🇧🇩'),
      // Country(name: 'United States', code: '+1', flag: '🇺🇸'),
      // Country(name: 'United Kingdom', code: '+44', flag: '🇬🇧'),
      // Country(name: 'Canada', code: '+1', flag: '🇨🇦'),
      // Country(name: 'Australia', code: '+61', flag: '🇦🇺'),
      // Country(name: 'Germany', code: '+49', flag: '🇩🇪'),
      // Country(name: 'France', code: '+33', flag: '🇫🇷'),
      // Country(name: 'China', code: '+86', flag: '🇨🇳'),
      // Country(name: 'Japan', code: '+81', flag: '🇯🇵'),
      // Add more countries as needed
    ];
  }
}
