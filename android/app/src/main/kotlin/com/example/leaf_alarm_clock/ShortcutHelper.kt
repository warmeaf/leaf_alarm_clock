package com.example.leaf_alarm_clock

import android.content.Context
import android.content.Intent
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.drawable.Icon
import android.os.Build

class ShortcutHelper(private val context: Context) {

    fun createFixedShortcut() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N_MR1) {
            val shortcutManager = context.getSystemService(ShortcutManager::class.java)

            val shortcutIntent = Intent(context, MainActivity::class.java)
            shortcutIntent.action = Intent.ACTION_VIEW

            // 添加额外的数据，以便在应用程序中执行特定操作
            shortcutIntent.putExtra("shortcut_action", "create_30_min_alarm")

            val shortcut = ShortcutInfo.Builder(context, "shortcut_id")
                .setShortLabel("30-min Alarm")
                .setLongLabel("Create 30-min Alarm")
                .setIcon(Icon.createWithResource(context, R.mipmap.ic_short_launcher))
                .setIntent(shortcutIntent)
                .build()

            shortcutManager.dynamicShortcuts = listOf(shortcut)
        }
    }
}
