package io.flutter.plugins.scheduler

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import java.util.Calendar
import android.util.Log
import android.os.SystemClock
import android.app.AlarmManager
import android.content.SharedPreferences

import io.flutter.plugins.scheduler.Notification

/** SchedulerPlugin */
public class SchedulerPlugin(): FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var mContext : Context

  private fun setContext(context: Context) {
    Log.d(TAG, "set context:" + context)
    mContext = context
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "scheduler")
    channel.setMethodCallHandler(this);
    setContext(flutterPluginBinding.getApplicationContext())
  }


  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    private val TAG = "SchedulerPlugin"
    @JvmStatic
    val SHARED_PREF_FILE = "io.flutter.plugins.scheduler.PREFERENCE_FILE_KEY"
    const val HOUR = "hour"
    const val MINUTE = "minute"

    @JvmStatic
    private fun saveNotificationPreferences(context: Context,
                                  hour: Int,
                                  minute : Int,
                                  title: String,
                                  text: String) {

      val sharedPref = context.getSharedPreferences(SHARED_PREF_FILE, Context.MODE_PRIVATE)
      with (sharedPref.edit()) {
        putInt(HOUR, hour)
        putInt(MINUTE, minute)
        putString(Notification.TITLE, title)
        putString(Notification.TEXT, text)
        apply()
      }
    }

    @JvmStatic
    private fun saveChannelPreferences(context: Context,
                                channelId: String,
                                channelName: String,
                                channelImportance: Int) {

      val sharedPref = context.getSharedPreferences(SHARED_PREF_FILE, Context.MODE_PRIVATE)
      with (sharedPref.edit()) {
        putString(Notification.CHANNEL_ID, channelId)
        putString(Notification.CHANNEL_NAME, channelName)
        putInt(Notification.CHANNEL_IMPORTANCE, channelImportance)
        apply()
      }
    }

    @JvmStatic
    private fun cancelNextNotification(context: Context, hour : Int, minute : Int) {

      Log.d(TAG, "context: " + context)

      val alarmMgr = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

      //Create the time of the first alarm
      val calendar: Calendar = Calendar.getInstance().apply {
        //Add a day
        add(Calendar.DAY_OF_MONTH, 1)
        //Set the hour
        set(Calendar.HOUR_OF_DAY, hour)
        set(Calendar.MINUTE, minute)
      }

      val times = createRepeatingAlarmTimes(calendar)
      val intent = Intent(context, NotificationBroadcastReceiver::class.java)

      for((index, time) in times.withIndex()) {

        //Get the intent with the flag to update
        val pendingIntent = PendingIntent.getBroadcast(context, index, intent, PendingIntent.FLAG_UPDATE_CURRENT)

        if (pendingIntent != null && alarmMgr != null) {
          alarmMgr?.setRepeating(
                  AlarmManager.RTC_WAKEUP,
                  time.timeInMillis,
                  AlarmManager.INTERVAL_DAY,
                  pendingIntent
          )
        }
      }

    }

    @JvmStatic
    private fun cancelNotification(context: Context) {

      Log.d(TAG, "context: " + context)

      val alarmMgr = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

      val intent = Intent(context, NotificationBroadcastReceiver::class.java)

      for(i in 0 until 6) {
        val pendingIntent = PendingIntent.getBroadcast(context, i, intent, PendingIntent.FLAG_CANCEL_CURRENT)

        if (pendingIntent != null && alarmMgr != null) {
          alarmMgr.cancel(pendingIntent)
          pendingIntent.cancel()
        }
      }
    }

    @JvmStatic
    fun scheduleNotification(context: Context,
                             hour: Int,
                             minute : Int) {

      Log.d(TAG, "context: " + context)

      val alarmMgr = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

      //Create the time of the first alarm
      val calendar: Calendar = Calendar.getInstance().apply {
        set(Calendar.HOUR_OF_DAY, hour)
        set(Calendar.MINUTE, minute)
      }

      val times = createRepeatingAlarmTimes(calendar)

      val intent = Intent(context, NotificationBroadcastReceiver::class.java)

      for((index, time) in times.withIndex()) {

        val alarmIntent = PendingIntent.getBroadcast(context, index, intent, 0)

        alarmMgr?.setRepeating(
                AlarmManager.RTC_WAKEUP,
                time.timeInMillis,
                AlarmManager.INTERVAL_DAY,
                alarmIntent
        )
      }
      Log.d(TAG, "Broadcasting notification")
    }

    @JvmStatic
    private fun createRepeatingAlarmTimes(calendar : Calendar) : Collection<Calendar> {

      val times = mutableListOf<Calendar>(calendar)

      for (minute in 5 until 30 step 5) {
        times.add(
                (calendar.clone() as Calendar)
                        .apply{add(Calendar.MINUTE, minute)}
        )
      }

      return times
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    val args = call.arguments<ArrayList<*>>()
    when(call.method) {
      "createAndroidChannel" -> {
        val channelId = args!![0] as String
        val channelName = args!![1] as String
        val channelImportance = args!![2] as Int
        saveChannelPreferences(mContext, channelId, channelName, channelImportance)
        Notification.createNotificationChannel(mContext)
      }
      "scheduleNotification" -> {
        val hour = args!![0] as Int
        val minute = args!![1] as Int
        val title = args!![2] as String
        val text = args!![3] as String

        saveNotificationPreferences(mContext, hour, minute, title, text)
        scheduleNotification(mContext, hour, minute)
      }
      "cancelNotification" -> {
        cancelNotification(mContext)
      }
      "cancelNextNotification" -> {
        val hour = args!![0] as Int
        val minute = args!![1] as Int

        cancelNextNotification(mContext, hour, minute)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
