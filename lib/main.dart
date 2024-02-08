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
import 'package:flutter/services.dart';

void main() {
  initSystem();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "叶子闹钟",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightGreen, background: Colors.lightGreen[50]),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

initSystem() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.lightGreen[50], // 设置状态栏的背景颜色为透明色
    statusBarBrightness: Brightness.dark, // 设置状态栏文字为暗色
    statusBarIconBrightness: Brightness.dark, // 设置状态栏图标为暗色
  ));
}
