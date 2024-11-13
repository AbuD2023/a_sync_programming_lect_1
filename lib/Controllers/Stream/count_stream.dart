import 'dart:developer';

class CountStream {
  Stream<int> countdown(int max) async* {
    for (int i = max; i >= 0; i--) {
      // تاخير لمدة ثانية وان لم نعملها لم يظهر اي شي على الشاشة سيتم العد التنازلي بشكل سريع جداً
      await Future.delayed(const Duration(seconds: 1));

      log(i.toString());
      yield i;
    }
  }
}
