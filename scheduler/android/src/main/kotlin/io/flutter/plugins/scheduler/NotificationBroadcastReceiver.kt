package io.flutter.plugins.scheduler

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class NotificationBroadcastReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "NotificationBroadcastReceiver"
    }
    
    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "Sending notification with intent: " + intent)

        Notification.sendNotification(context)
    }
}