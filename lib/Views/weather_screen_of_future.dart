import 'package:a_sync_programming_lect_1/Controllers/Future/api_openweathermap.dart';
import 'package:flutter/material.dart';

class WeatherScreenOfFuture extends StatefulWidget {
  const WeatherScreenOfFuture({super.key});

  @override
  State<WeatherScreenOfFuture> createState() => _WeatherScreenOfFutureState();
}

class _WeatherScreenOfFutureState extends State<WeatherScreenOfFuture> {
  ApiOpenweathermap apiOpenweathermap = ApiOpenweathermap();
  late Future<Map<String, dynamic>> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = apiOpenweathermap.fetchWeather(city: 'sanaa', lang: 'ar');
    // weatherData = apiOpenweathermap.fetchWeatherDontAwait(city: 'sanaa', lang: 'en');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: weatherData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final data = snapshot.data!;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('المدينة: ${data['name']}',
                      textDirection:
                          TextDirection.rtl), // Text('City: ${data['name']}'),

                  Text('درجة الحرارة: ${data['main']['temp']}°C',
                      textDirection: TextDirection
                          .rtl), // Text('Temperature: ${data['main']['temp']}°C'),

                  Text('الطقس: ${data['weather'][0]['description']}',
                      textDirection: TextDirection
                          .rtl), // Text('Weather: ${data['weather'][0]['description']}'),
                  Image.network(
                    color: Colors.blue,
                    'https://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png',
                    width: 50, // يمكنك تعديل العرض حسب الحاجة
                    height: 50, // يمكنك تعديل الارتفاع حسب الحاجة
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
