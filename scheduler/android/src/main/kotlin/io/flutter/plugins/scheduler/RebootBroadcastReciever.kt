package io.flutter.plugins.scheduler

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class RebootBroadcastReciever : BroadcastReceiver() {

    companion object {
        private const val TAG = "RebootBroadcastReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "android.intent.action.BOOT_COMPLETED") {

            //Retrieve the scheduled notification and re-schedule it.
            val sharedPref = context.getSharedPreferences(
                    SchedulerPlugin.SHARED_PREF_FILE, Context.MODE_PRIVATE)
            val hour = sharedPref.getInt(SchedulerPlugin.HOUR, 9)
            val minute = sharedPref.getInt(SchedulerPlugin.MINUTE, 30)

            SchedulerPlugin.scheduleNotification(context, hour, minute)
        }
    }
}