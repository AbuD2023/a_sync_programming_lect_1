/*

في هذا الكود، يتم استخدام StreamController و Future 
لعرض بيانات الطقس ووقت حي يتم تحديثه بشكل مستمر.
الهدف من هذا الكود هو بناء تطبيق يعرض الطقس ووقت الساعة الحالي مع إمكانية إيقاف واستئناف الوقت.

*/

/*
        1. هنا نستورد مكتبة 
        async:
        لإدارة البرمجة غير المتزامنة،
        ومكتبة material.dart 
        لبناء واجهة المستخدم،
        وملف api_openweathermap.dart
        الذي يحتوي على كود لجلب بيانات الطقس من
        API.
*/
import 'dart:async';

import 'package:a_sync_programming_lect_1/Controllers/Future/api_openweathermap.dart';
import 'package:flutter/material.dart';

//                    2. تعريف واجهة WeatherAndClockScreen
class WeatherAndClockScreen extends StatefulWidget {
  const WeatherAndClockScreen({super.key});

  @override
  State<WeatherAndClockScreen> createState() => _WeatherAndClockScreenState();
}
/*
        يتم تعريف واجهة WeatherAndClockScreen باستخدام StatefulWidget
        لأننا سنحتاج لتحديث الواجهة عند بدء/إيقاف الساعة أو عند تحديث بيانات الطقس.
*/

class _WeatherAndClockScreenState extends State<WeatherAndClockScreen> {
  /*
                      3. تعريف المتغيرات الأساسية في State
  */
  late Future<Map<String, dynamic>>
      weatherData; // متغير من نوع Future سيتم تخزين بيانات الطقس فيه.
  StreamController<String> timeController = StreamController<
      String>(); // يتم استخدامه للتحكم في تدفق الوقت باستخدام StreamController.
  ApiOpenweathermap apiOpenweathermap =
      ApiOpenweathermap(); // كائن من فئة ApiOpenweathermap يستخدم لاستدعاء API للطقس.

/*
                      4.
        initState وبدء الساعة
        داخل initState،
        نقوم باستدعاء
        fetchWeather
        لجلب بيانات الطقس عند تحميل الصفحة لأول مرة.
*/
  @override
  void initState() {
    super.initState();
    weatherData = apiOpenweathermap.fetchWeather(city: 'sanaa', lang: 'ar');
  }

//                     5. دوال التحكم بالساعة
  /*
        startClock
        تستخدم
        Stream.periodic
        لإنشاء تدفق يُحدّث الوقت كل ثانية.
  */
  void startClock() {
    /*
        تقوم الدالة بإرسال الوقت الحالي كل ثانية إلى
        timeController
        الذي يتحكم بتدفق البيانات.
    */
    if (timeController.isClosed) {
      setState(() {
        timeController = StreamController<String>();
      });
    }
    Stream.periodic(
            const Duration(seconds: 1), // تحديد متى يتم التحديث التلقائي
            (_) => DateTime.now()
                .toLocal()
                .toString()) // تحديد نوع البيانات الراجعة من الـ Stream
        .takeWhile(// يتوقف عن بث البيانات عند إغلاق timeController.
            (_) => !timeController.isClosed) // شرط للتاكد من إنه ليس مغلقاً
        .listen((time) {
      // الأستماع للتحديثات التي تحدث في الـ Stream اولاً باول.
      timeController.sink.add(time); // إضافة القيمة الجديدة الى المحكم
    });
  }

/*
        تغلق هذه الدالة
        timeController،
        مما يؤدي إلى إيقاف الساعة.
*/
  void stopClock() {
    timeController.close();
  }

//                    6. dispose
  @override
  void dispose() {
    /*
          نغلق الـ
          timeController
          هنا عند تدمير الصفحة لمنع تسرب الذاكرة.
    */
    timeController.close();
    super.dispose();
  }

//                    7. بناء واجهة المستخدم
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather and Clock')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // يعرض زرًا لتحديث بيانات الطقس بالاستعانة بـ FutureBuilder.
          ElevatedButton(
            onPressed: () {
              setState(() {
                weatherData =
                    apiOpenweathermap.fetchWeather(city: 'sanaa', lang: 'ar');
              });
            },
            child: const Text('Refresh Weather'),
          ),
          // FutureBuilder لعرض بيانات الطقس
          /*
                    FutureBuilder
                    يراقب
                    weatherData
                    ويعرض بيانات الطقس عندما تصبح جاهزة.
          */
          FutureBuilder<Map<String, dynamic>>(
            future: weatherData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // مؤشر إنتضار عند تحميل البيانات من الـ API.
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                //إذا كان هناك خطأ، يعرض رسالة الخطأ.
                return Text('Error: ${snapshot.error}');
              } else {
                final data = snapshot.data!;
                return Column(
                  children: [
                    Text('City: ${data['name']}'),
                    Text('Temperature: ${data['main']['temp']}°C'),
                  ],
                );
              }
            },
          ),
          // فاصل بين الـ Widget
          const SizedBox(height: 20),
          //
          //      زر بدء الساعة
          // يتم عرض زر Start Clock لبدء الساعة.
          ElevatedButton(
            onPressed: startClock,
            child: const Text('Start Clock'),
          ),
          //      زر إيقاف الساعة
          // يتم عرض زر Stop Clock لإيقاف الساعة.
          ElevatedButton(
            onPressed: stopClock,
            child: const Text('Stop Clock'),
          ),
          // StreamBuilder لعرض الوقت.
          /*
                    StreamBuilder
                    يقوم بمراقبة
                    timeController.stream
                    ويعرض الوقت الحالي.
          */
          StreamBuilder<String>(
            stream: timeController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                //      إذا لم يكن هناك بيانات بعد، يظهر رسالة
                //             Clock not started.
                return const Center(child: Text('Clock not started'));
              } else {
                return Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'Current Time: ${snapshot.data}',
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}


 /*
    يتم عرض الوقت في
    Text
    مع زرين للاستئناف والتوقف.
*/
// ElevatedButton(
    //   onPressed: onResumeClock,
    //   child: const Text('on Resume Clock'),
    // ),
    // ElevatedButton(
    //   onPressed: onPauseClock,
    //   child: const Text('on Pause Clock'),
    // ),

// void onPauseClock() {
  //   timeController.onPause;
  // }

// void onResumeClock() {
  //   timeController.onResume;
  // }