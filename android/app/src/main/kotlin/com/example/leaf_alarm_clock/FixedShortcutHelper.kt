package com.example.leaf_alarm_clock

import android.content.Context
import android.content.Intent
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.drawable.Icon
import android.os.Build

class FixedShortcutHelper(private val context: Context) {

    fun createFixedShortcut(timeText: String, hour: Int, minute: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N_MR1) {
            val shortcutManager = context.getSystemService(ShortcutManager::class.java)

            if (shortcutManager.isRequestPinShortcutSupported) {
                val shortcutIntent = Intent(context, MainActivity::class.java)
                shortcutIntent.action = Intent.ACTION_VIEW

                // 添加额外的数据，以便在应用程序中执行特定操作
                shortcutIntent.putExtra("shortcut_action", "create_fixed_shortcut")
                shortcutIntent.putExtra("hour", hour)
                shortcutIntent.putExtra("minute", minute)

                val shortcut = ShortcutInfo.Builder(context, timeText)
                    .setShortLabel(timeText)
                    .setLongLabel("${timeText}后响铃")
                    .setIcon(Icon.createWithResource(context, R.mipmap.ic_short_launcher))
                    .setIntent(shortcutIntent)
                    .build()

                shortcutManager.requestPinShortcut(shortcut, null)
            } else {
                // 设备的默认启动器不支持固定快捷方式
                // Logger.warn("MainActivity", "Device launcher does not support pinned shortcuts")
            }            
        } else {
            // 设备运行的 Android 版本低于 8.0 (O)
            // Logger.warn("MainActivity", "Device is running an Android version lower than 8.0 (O)")
        }
    }
}
