import 'package:a_sync_programming_lect_1/Views/count_down_screen_of_stream.dart';
import 'package:a_sync_programming_lect_1/Views/weather_and_clock_screen.dart';
import 'package:a_sync_programming_lect_1/Views/weather_screen_of_future.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'A_sync_Programming_Lect_1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> itemWidget = [
    CountDownScreenOfStream(),
    WeatherScreenOfFuture(),
    WeatherAndClockScreen(),
  ];
  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(icon: Icon(Icons.stream), label: 'Stream'),
    BottomNavigationBarItem(icon: Icon(Icons.functions), label: 'Fututre'),
    BottomNavigationBarItem(
        icon: Icon(Icons.stream_rounded), label: 'Future & Stream'),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: itemWidget[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}
