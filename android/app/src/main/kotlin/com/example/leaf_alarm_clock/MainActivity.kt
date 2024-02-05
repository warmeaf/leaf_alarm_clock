package com.example.leaf_alarm_clock

import android.content.Intent
import android.os.Bundle
import android.provider.AlarmClock
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.leaf.alarm_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            if (call.method == "setAlarm") {
                val alarmTimeInMillis = call.arguments as Long
                setAlarm(alarmTimeInMillis)
                result.success(null)
            }else if(call.method == "createFixedShortcut") {
                // val shortcutHelper = ShortcutHelper(this)
                // shortcutHelper.createFixedShortcut()
                var timeText = call.argument<String>("timeText")!!
                var hour = call.argument<Int>("hour")!!
                var minute = call.argument<Int>("minute")!!
                val fixedShortcutHelper = FixedShortcutHelper(this)
                fixedShortcutHelper.createFixedShortcut(timeText, hour, minute, channel)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    // 点击桌面固定快捷方式时调用
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }
    
    // 当应用运行时
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        if (intent.hasExtra("shortcut_action") && intent.hasExtra("hour") && intent.hasExtra("minute")) {
            val action = intent.getStringExtra("shortcut_action")
            var hour = intent.getIntExtra("hour", 0)
            var minute = intent.getIntExtra("minute", 0)
            var totalMinute = hour * 60 + minute + 1

            if (action == "create_fixed_shortcut") {
                val calendar = Calendar.getInstance()
                calendar.add(Calendar.MINUTE, totalMinute)
                val alarmTimeInMillis = calendar.timeInMillis
                setAlarm(alarmTimeInMillis, true)
            }
        }
    }

    // 设置闹钟
    private fun setAlarm(alarmTimeInMillis: Long, isClose: Boolean = false) {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = alarmTimeInMillis
        val hour = calendar.get(Calendar.HOUR_OF_DAY)
        val minute = calendar.get(Calendar.MINUTE)

        val intent = Intent(AlarmClock.ACTION_SET_ALARM).apply {
            putExtra(AlarmClock.EXTRA_MESSAGE, "叶子闹钟")
            putExtra(AlarmClock.EXTRA_HOUR, hour)
            putExtra(AlarmClock.EXTRA_MINUTES, minute)
            putExtra(AlarmClock.EXTRA_SKIP_UI, true)
        }
        startActivity(intent)

        // if(isClose) {
        //     closeApp()
        // }
    }

    // 关闭应用
    private fun closeApp() {
        finish()
        System.exit(0)
    }
}
