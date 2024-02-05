import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  MethodChannel platform = const MethodChannel('com.leaf.alarm_channel');

  Future<void> receiveDataFromNative(Function sucess, Function error) async {
    // 调用与原生代码对应的方法名，获取数据
    platform.setMethodCallHandler((call) async {
      if (call.method == 'shortcut_result') {
        final data = call.arguments;
        if (data == 'success') {
          sucess();
        } else {
          error();
        }
      }
    });
  }

  // 创建闹钟
  Future<void> setAlarm({int hour = 0, int minute = 30}) async {
    final duration = Duration(hours: hour, minutes: minute + 1);
    final alarmTime = DateTime.now().add(duration);
    await platform.invokeMethod('setAlarm', alarmTime.millisecondsSinceEpoch);
  }

  resetData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key);
    if (list != null) {
      var hour = int.parse(list[0]);
      var minute = int.parse(list[1]);

      if (key == 'pickerDataRoutine') {
        pickerDataRoutine['hour']!.value = hour;
        pickerDataRoutine['minute']!.value = minute;
      } else if (key == 'pickerDataShortcut') {
        pickerDataShortcut['hour']!.value = hour;
        pickerDataShortcut['minute']!.value = minute;
      }
    }
  }

  storeData(String key, List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(key, value);
  }

  // datePick数据
  final Map<String, RxInt> pickerDataRoutine = {'hour': 0.obs, 'minute': 0.obs};
  final Map<String, RxInt> pickerDataShortcut = {
    'hour': 0.obs,
    'minute': 0.obs
  };

  String timeToText(Map<String, RxInt> timeData) {
    var hour = timeData['hour']!.value;
    var minute = timeData['minute']!.value;
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

  // 是否正在创建快捷方式
  final RxBool isCreatingFixedShortcut = false.obs;

  // 创建快捷图标
  createFixedShortcut() async {
    isCreatingFixedShortcut.value = true;
    await platform.invokeMethod('createFixedShortcut', {
      'timeText': timeToText(pickerDataShortcut),
      'hour': pickerDataShortcut['hour']!.value,
      'minute': pickerDataShortcut['minute']!.value,
    });
  }
}
