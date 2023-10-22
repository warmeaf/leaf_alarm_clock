/*
 * @Author: nextc 1391040917@qq.com
 * @Date: 2023-04-11 20:08:23
 * @LastEditors: nextc 1391040917@qq.com
 * @LastEditTime: 2023-05-05 21:07:52
 * @FilePath: \leaf_alarm_clock\lib\main.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "叶子闹钟",
      theme: ThemeData(useMaterial3: true),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
