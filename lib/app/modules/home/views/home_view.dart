import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  // 创建 Picker
  Widget _buildNumberPicker({
    int? value,
    int? minValue,
    int? maxValue,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 50,
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

  // 创建闹钟
  List<Widget> _quickCreation(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Text(
                '创建闹钟',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Icon(
                Symbols.bolt_rounded,
                size: 16,
              ),
            ],
          ),
        ]),
      ),
      Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  _buildNumberPicker(
                    value: controller.pickerDataRoutine['hour']!.value,
                    minValue: 0,
                    maxValue: 12,
                    onChanged: (value) {
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
              _buildActionButtons(() {
                controller.setAlarm(
                    hour: controller.pickerDataRoutine['hour']!.value,
                    minute: controller.pickerDataRoutine['minute']!.value);
              }, const Text('创建')),
            ],
          )),
    ];
  }

  // 创建桌面快捷方式
  List<Widget> _fixedShortcutCreation(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Text(
                '创建桌面快捷图标',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Icon(
                Symbols.app_shortcut_rounded,
                size: 16,
              ),
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                _buildNumberPicker(
                  value: controller.pickerDataShortcut['hour']!.value,
                  minValue: 0,
                  maxValue: 12,
                  onChanged: (value) {
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
            _buildActionButtons(() {
              if (controller.isCreatingFixedShortcut.value) return;
              controller.createFixedShortcut();
            },
                controller.isCreatingFixedShortcut.value
                    ? SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.lightGreen.shade700,
                        ),
                      )
                    : const Text('创建')),
          ],
        ),
      )
    ];
  }

  // 操作按钮
  Widget _buildActionButtons(void Function() onPressed, Widget child) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
          (Set<MaterialState> states) {
            return const EdgeInsets.symmetric(horizontal: 8.0);
          },
        ),
      ),
      child: child,
    );
  }

  // 头部
  Row _buildHeader(BuildContext context) {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 6, 10),
        child: SvgPicture.asset(
          'assets/logo.svg',
          height: 16,
          width: 16,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          '叶子闹钟',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    ]);
  }

  // 卡片
  Container _buildCard(BuildContext context, Widget containerChild) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.lightGreen[100]),
        child: containerChild);
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
              Icon(Symbols.check_circle, size: 20, color: Colors.lightGreen),
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
        body: SafeArea(
      left: true,
      top: true,
      right: true,
      bottom: true,
      minimum: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(context),
          const SizedBox(
            height: 20,
          ),
          _buildCard(
              context,
              Column(children: [
                ..._quickCreation(context),
              ])),
          const SizedBox(
            height: 40,
          ),
          _buildCard(
              context,
              Column(children: [
                ..._fixedShortcutCreation(context),
              ])),
        ],
      ),
    ));
  }
}
