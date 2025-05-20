import 'dart:async';

class TimerHelper {
  static Timer startCountdown(
      int seconds, Function(int) onTick, Function onDone) {
    int count = seconds;
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      if (count > 0) {
        count--;
        onTick(count);
      } else {
        timer.cancel();
        onDone();
      }
    });
  }
}
