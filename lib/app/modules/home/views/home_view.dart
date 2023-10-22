import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../controllers/home_controller.dart';
import 'package:numberpicker/numberpicker.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  Widget _buildNumberPicker({
    int? value,
    int? minValue,
    int? maxValue,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 60,
          child: NumberPicker(
            value: value ?? 0,
            minValue: minValue ?? 0,
            maxValue: maxValue ?? 59,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _showPicker(BuildContext context, int index) {
    controller.pickerData['hour']!.value =
        controller.quickList[index]['time']!.value.hour;
    controller.pickerData['minute']!.value =
        controller.quickList[index]['time']!.value.minute;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 240,
          child: Column(
            children: <Widget>[
              ListTile(
                title: const Text('选择小时和分钟'),
                trailing: TextButton(
                  onPressed: () {
                    controller.quickList[index]['time']!.value = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        controller.pickerData['hour']!.value,
                        controller.pickerData['minute']!.value);
                    // 这里可以处理用户点击“确定”按钮后的逻辑
                    Navigator.of(context).pop();
                  },
                  child: const Text('确定'),
                ),
              ),
              Obx(() => Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildNumberPicker(
                          value: controller.pickerData['hour']!.value,
                          minValue: 0,
                          maxValue: 12,
                          onChanged: (value) {
                            // 这里最好做防抖处理
                            // print(value);
                            controller.pickerData['hour']!.value = value;
                          },
                        ),
                        // Text('小时'),
                        _buildNumberPicker(
                          value: controller.pickerData['minute']!.value,
                          minValue: 0,
                          maxValue: 59,
                          onChanged: (value) {
                            controller.pickerData['minute']!.value = value;
                          },
                        ),
                        // Text('分钟'),
                      ],
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  // 快捷创建
  List<Widget> _quickCreation(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            '快捷创建',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            '长按可编辑',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Colors.grey),
          ),
        ]),
      ),
      Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: controller.quickList.asMap().entries.map((entry) {
              return OutlinedButton(
                onPressed: () {},
                onLongPress: () {
                  _showPicker(context, entry.key);
                },
                child: Text(controller.timeToText(
                    controller.quickList[entry.key]['time']!.value)),
              );
            }).toList(),
          )),
    ];
  }

  // 桌面快捷方式创建
  List<Widget> _fixedShortcutCreation(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            '桌面快捷方式创建',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ]),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => InkWell(
                    // onTap: () {
                    // },
                    child: Text(
                      controller.fixedShortcutCurrentTimeText,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Theme.of(context).primaryColor,
                            decorationThickness: 2.0,
                          ),
                    ),
                  )),
              Text(
                '之后响铃的桌面快捷图标',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          FilledButton(
            onPressed: () {
              controller.createFixedShortcut();
            },
            child: const Text('创建'),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                '叶子闹钟',
                style: Theme.of(context).textTheme.titleMedium,
              )),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ..._quickCreation(context),
              const SizedBox(
                height: 40,
              ),
              ..._fixedShortcutCreation(context)
            ],
          ),
        ));
  }
}
