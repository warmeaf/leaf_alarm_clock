import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

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

  // 快捷创建
  List<Widget> _quickCreation(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Text(
                '创建闹钟',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Icon(Symbols.bolt_rounded),
            ],
          ),
        ]),
      ),
      Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildNumberPicker(
                    value: controller.pickerDataRoutine['hour']!.value,
                    minValue: 0,
                    maxValue: 12,
                    onChanged: (value) {
                      // 这里最好做防抖处理
                      // print(value);
                      controller.pickerDataRoutine['hour']!.value = value;
                      controller.storeData('pickerDataRoutine', [
                        controller.pickerDataRoutine['hour']!.value.toString(),
                        controller.pickerDataRoutine['minute']!.value
                            .toString(),
                      ]);
                    },
                  ),
                  const Text('小时'),
                  _buildNumberPicker(
                    value: controller.pickerDataRoutine['minute']!.value,
                    minValue: 0,
                    maxValue: 59,
                    onChanged: (value) {
                      controller.pickerDataRoutine['minute']!.value = value;
                      controller.storeData('pickerDataRoutine', [
                        controller.pickerDataRoutine['hour']!.value.toString(),
                        controller.pickerDataRoutine['minute']!.value
                            .toString(),
                      ]);
                    },
                  ),
                  const Text('分钟'),
                ],
              ),
              FilledButton(
                  onPressed: () {
                    controller.setAlarm(
                        hour: controller.pickerDataRoutine['hour']!.value,
                        minute: controller.pickerDataRoutine['minute']!.value);
                  },
                  child: const Text('创建'))
            ],
          )),
    ];
  }

  // 桌面快捷方式创建
  List<Widget> _fixedShortcutCreation(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Text(
                '创建桌面快捷图标',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Icon(Symbols.app_shortcut_rounded),
            ],
          ),
          Text(
            '',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Colors.grey),
          ),
        ]),
      ),
      Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildNumberPicker(
                  value: controller.pickerDataShortcut['hour']!.value,
                  minValue: 0,
                  maxValue: 12,
                  onChanged: (value) {
                    // 这里最好做防抖处理
                    // print(value);
                    controller.pickerDataShortcut['hour']!.value = value;
                    controller.storeData('pickerDataShortcut', [
                      controller.pickerDataShortcut['hour']!.value.toString(),
                      controller.pickerDataShortcut['minute']!.value.toString(),
                    ]);
                  },
                ),
                const Text('小时'),
                _buildNumberPicker(
                  value: controller.pickerDataShortcut['minute']!.value,
                  minValue: 0,
                  maxValue: 59,
                  onChanged: (value) {
                    controller.pickerDataShortcut['minute']!.value = value;
                    controller.storeData('pickerDataShortcut', [
                      controller.pickerDataShortcut['hour']!.value.toString(),
                      controller.pickerDataShortcut['minute']!.value.toString(),
                    ]);
                  },
                ),
                const Text('分钟'),
              ],
            ),
            FilledButton(
                onPressed: () {
                  if (controller.isCreatingFixedShortcut.value) return;
                  controller.createFixedShortcut();
                },
                child: controller.isCreatingFixedShortcut.value
                    ? const SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.white,
                        ),
                      )
                    : const Text('创建')),
          ],
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    controller.resetData('pickerDataRoutine');
    controller.resetData('pickerDataShortcut');

    controller.receiveDataFromNative(() {
      controller.isCreatingFixedShortcut.value = false;
      const snackBar = SnackBar(
          content: Row(
            children: [
              Icon(Symbols.check_circle, size: 20, color: Colors.green),
              SizedBox(width: 4),
              Text('创建成功！')
            ],
          ),
          showCloseIcon: true);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }, () {
      controller.isCreatingFixedShortcut.value = false;
      const snackBar = SnackBar(
          content: Row(
            children: [
              Icon(Symbols.error, size: 20, color: Colors.red),
              SizedBox(width: 4),
              Text('创建失败，请开启相关权限！')
            ],
          ),
          showCloseIcon: true);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

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
                height: 80,
              ),
              ..._fixedShortcutCreation(context)
            ],
          ),
        ));
  }
}
