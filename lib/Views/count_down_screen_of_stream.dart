import 'package:a_sync_programming_lect_1/Controllers/Stream/count_stream.dart';
import 'package:flutter/material.dart';

class CountDownScreenOfStream extends StatelessWidget {
  const CountDownScreenOfStream({super.key});

  @override
  Widget build(BuildContext context) {
    CountStream countStream = CountStream();
    return Scaffold(
      appBar: AppBar(title: const Text('Countdown Timer')),
      body: Center(
        child: StreamBuilder<int>(
          stream: countStream.countdown(100), // العد التنازلي يبدأ من 10
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('لا توجد بيانات'),
              );
            } else {
              return Center(
                child: Text(snapshot.data!.toString()),
              );
            }
          },
        ),
      ),
    );
  }
}
