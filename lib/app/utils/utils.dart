import 'dart:async';

class Utils {
  static Function debounce(Function function, Duration duration) {
    Timer? timer;

    return (arg) {
      if (timer != null) {
        timer!.cancel();
      }

      timer = Timer(duration, () {
        function(arg);
        timer = null;
      });
    };
  }
}
