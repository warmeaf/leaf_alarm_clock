import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  MethodChannel platform = const MethodChannel('com.leaf.alarm_channel');

  Future<void> receiveDataFromNative(Function sucess, Function error) async {
    try {
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
    } catch (e) {}
  }

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
  ];
  resetQuickList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    quickList.asMap().forEach((index, element) {
      final list = prefs.getStringList('quickList$index');
      if (list != null) {
        var hour = int.parse(list[0]);
        var minute = int.parse(list[1]);

        element['time']!.value = DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day, hour, minute);
      }
    });
  }

  handleChangeList(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    quickList[index]['time']!.value = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickerData['hour']!.value,
        pickerData['minute']!.value);

    await prefs.setStringList('quickList$index', <String>[
      pickerData['hour']!.value.toString(),
      pickerData['minute']!.value.toString()
    ]);
  }

  // datePick数据
  final Map<String, RxInt> pickerData = {'hour': 0.obs, 'minute': 0.obs};

  // 桌面快捷方式数据
  final fixedShortcutCurrentTime = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 30)
      .obs;
  resetFixedShortcutCurrentTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('fixedShortcutCurrentTime');
    if (list != null) {
      var hour = int.parse(list[0]);
      var minute = int.parse(list[1]);
      fixedShortcutCurrentTime.value = DateTime(DateTime.now().year,
          DateTime.now().month, DateTime.now().day, hour, minute);
    }
  }

  handleChangeFixedShortcutCurrentTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    fixedShortcutCurrentTime.value = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickerData['hour']!.value,
        pickerData['minute']!.value);

    prefs.setStringList('fixedShortcutCurrentTime', <String>[
      pickerData['hour']!.value.toString(),
      pickerData['minute']!.toString()
    ]);
  }

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

  // 是否正在创建快捷方式
  final RxBool isCreatingFixedShortcut = false.obs;

  // 创建快捷图标
  createFixedShortcut() async {
    try {
      isCreatingFixedShortcut.value = true;
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
