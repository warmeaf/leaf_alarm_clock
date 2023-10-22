import 'package:get/get.dart';
import 'package:flutter/services.dart';

class HomeController extends GetxController {
  MethodChannel platform = const MethodChannel('com.leaf.alarm_channel');

  // 创建闹钟
  Future<void> setAlarm({int hour = 0, int minute = 30}) async {
    try {
      final duration = Duration(hours: hour, minutes: minute + 1);
      final alarmTime = DateTime.now().add(duration);
      await platform.invokeMethod('setAlarm', alarmTime.millisecondsSinceEpoch);
    } catch (error) {
      // 这里加个失败的提示
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
    // {
    //   'time': DateTime(DateTime.now().year, DateTime.now().month,
    //           DateTime.now().day, 7, 0)
    //       .obs
    // },
    // {
    //   'time': DateTime(DateTime.now().year, DateTime.now().month,
    //           DateTime.now().day, 8, 0)
    //       .obs
    // },
  ];

  // datePick数据
  final Map<String, RxInt> pickerData = {'hour': 0.obs, 'minute': 0.obs};

  // 桌面快捷方式数据
  final fixedShortcutCurrentTime = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 30)
      .obs;

  // 获取格式化时间
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
    } catch (error) {
      // 这里加个提示
      // print("Error: '${e.message}'.");
    }
  }
}
