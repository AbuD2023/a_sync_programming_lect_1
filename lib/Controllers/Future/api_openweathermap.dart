import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiOpenweathermap {
  Future<Map<String, dynamic>> fetchWeather(
      {required String city, required String lang}) async {
    const apiKey = '4ed36e2a480dd00f137877e8cd01a2dc';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=$lang';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherDontAwait(
      {required String city, required String lang}) async {
    const apiKey = '4ed36e2a480dd00f137877e8cd01a2dc';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=$lang';

    try {
      final response = http.get(Uri.parse(url));

      return response.then(
        (data) {
          if (data.statusCode == 200) {
            return json.decode(data.body);
          } else {
            throw Exception('Failed to load weather data');
          }
        },
      );
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
