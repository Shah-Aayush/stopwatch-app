import 'dart:convert';

class Lap {
  String title;
  final int hours;
  final int minutes;
  final int seconds;
  final int milliseconds;

  Lap({
    required this.title,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.milliseconds,
  });

  factory Lap.fromJson(Map<String, dynamic> jsonData) {
    return Lap(
      title: jsonData['title'],
      hours: jsonData['hours'],
      minutes: jsonData['minutes'],
      seconds: jsonData['seconds'],
      milliseconds: jsonData['milliseconds'],
    );
  }

  static Map<String, dynamic> toMap(Lap lap) => {
        'title': lap.title,
        'hours': lap.hours,
        'minutes': lap.minutes,
        'seconds': lap.seconds,
        'milliseconds': lap.milliseconds,
      };

  static String encode(List<Lap> laps) => json.encode(
        laps.map<Map<String, dynamic>>((lap) => Lap.toMap(lap)).toList(),
      );

  static List<Lap> decode(String laps) => (json.decode(laps) as List<dynamic>)
      .map<Lap>((item) => Lap.fromJson(item))
      .toList();
}
