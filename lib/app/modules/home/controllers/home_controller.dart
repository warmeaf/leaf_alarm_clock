import 'package:get/get.dart';
import 'package:flutter/services.dart';

class HomeController extends GetxController {
  MethodChannel platform = const MethodChannel('com.leaf.alarm_channel');

  RxInt selectedHour = 0.obs;
  RxInt selectedMinute = 0.obs;

  // 闹钟时间间隔
  final duration = const Duration(minutes: 30).obs;
  // 设置闹钟的时间
  void setDuration(Duration value) {
    duration.value = value;
  }

  String get durationText {
    var minutes = duration.value.inMinutes;
    var hours = duration.value.inHours;
    if (minutes < 60) {
      return '${duration.value.inMinutes.toString()}分钟';
    } else if (minutes % 60 == 0) {
      return '${hours.toString()}小时';
    } else {
      var residueMinutes = minutes - (hours * 60);
      return '${hours.toString()}小时${residueMinutes.toString()}分钟';
    }
  }

  // 快捷创建列表数据
  Future<void> setAlarm({Duration? durationQuick}) async {
    try {
      DateTime alarmTime;
      if (durationQuick != null) {
        alarmTime = DateTime.now().add(durationQuick);
      } else {
        alarmTime = DateTime.now().add(duration.value);
      }
      // print(duration.value);
      await platform.invokeMethod('setAlarm', alarmTime.millisecondsSinceEpoch);
    } on PlatformException catch (error) {
      // print("Error: '${e.message}'.");
    }
  }

  // 快捷创建列表数据
  final List<Map<String, Rx<DateTime>>> quickList = [
    {
      'time': DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 30)
          .obs
    },
    {
      'time': DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 1, 0)
          .obs
    },
    {
      'time': DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 7, 0)
          .obs
    },
    {
      'time': DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 8, 0)
          .obs
    },
  ].obs;

  // 上拉栏数据
  final Map<String, RxInt> pickerData = {'hour': 0.obs, 'minute': 0.obs};

  final fixedShortcutCurrentTime = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 30)
      .obs;
  void setFixedShortcutCurrentTime(int hour, int minute) {
    fixedShortcutCurrentTime.value = DateTime(DateTime.now().year,
        DateTime.now().month, DateTime.now().day, hour, minute);
  }

  String get fixedShortcutCurrentTimeText {
    var hour = fixedShortcutCurrentTime.value.hour;
    var minute = fixedShortcutCurrentTime.value.minute;
    var timeText = '';
    if (hour == 0) {
      timeText = '${minute.toString()}分钟';
    } else if (minute == 0) {
      timeText = '${hour.toString()}小时';
    } else {
      timeText = '${hour.toString()}小时${minute.toString()}分钟';
    }

    return timeText;
  }

  String timeToText(DateTime time) {
    var hour = time.hour;
    var minute = time.minute;
    var timeText = '';
    if (hour == 0) {
      timeText = '${minute.toString()}分钟';
    } else if (minute == 0) {
      timeText = '${hour.toString()}小时';
    } else {
      timeText = '${hour.toString()}小时${minute.toString()}分钟';
    }

    return timeText;
  }

  // 创建快捷图标
  createFixedShortcut() async {
    try {
      await platform.invokeMethod('createFixedShortcut', {
        'timeText': fixedShortcutCurrentTimeText,
        'hour': fixedShortcutCurrentTime.value.hour,
        'minute': fixedShortcutCurrentTime.value.minute
      });
    } on PlatformException catch (error) {
      // print("Error: '${e.message}'.");
    }
  }
}
