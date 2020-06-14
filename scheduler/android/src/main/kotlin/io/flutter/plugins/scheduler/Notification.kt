package io.flutter.plugins.scheduler

import android.R.drawable
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.graphics.drawable.Drawable
import android.graphics.drawable.Icon
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.content.SharedPreferences

class Notification {

  companion object {
    private const val TAG = "Notification"

    const val TITLE = "title"
    const val TEXT = "text"
    const val CHANNEL_ID = "channel_id"
    const val CHANNEL_NAME = "channel_name"
    const val CHANNEL_IMPORTANCE = "channel_importance"

    @JvmStatic
    fun sendNotification(context: Context) {

      val sharedPref = context.getSharedPreferences(SchedulerPlugin.SHARED_PREF_FILE, Context.MODE_PRIVATE)
      val title =  sharedPref.getString(TITLE, "")
      val text =  sharedPref.getString(TEXT, "")

      val nManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

      val defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
      val openApp = PendingIntent.getActivity(context, 0, getOpenAppIntent(context), PendingIntent.FLAG_UPDATE_CURRENT)

      val manager = context.getPackageManager()
      val resources = manager.getResourcesForApplication("com.example.pill_reminder")
      val resId = resources.getIdentifier("ic_launcher", "mipmap", "com.example.pill_reminder")


      val mNotification = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        Notification.Builder(context, sharedPref.getString(CHANNEL_ID, ""))
      } 
      else {
        Notification.Builder(context)
      }.apply {
        setSound(defaultSoundUri)
        setContentIntent(openApp)
        setSmallIcon(resId)
        setAutoCancel(false)
        setContentTitle(title)
        setContentText(text)
      }.build()
    
      nManager.notify(1000, mNotification)
    }

    @JvmStatic 
    private fun getOpenAppIntent(context : Context) : Intent {
      val mainActivity:Class<*>

      val packageName = context.getPackageName()
      val launchIntent = context.getPackageManager().getLaunchIntentForPackage(packageName)
      val className = launchIntent.getComponent().getClassName()

      //Load the main class, since we cannot import it into the plugin
      mainActivity = Class.forName(className)
      return Intent(context, mainActivity)
    }
    
    @JvmStatic
    public fun createNotificationChannel(context: Context) {

      val sharedPref = context.getSharedPreferences(SchedulerPlugin.SHARED_PREF_FILE, Context.MODE_PRIVATE)
      val channelId =  sharedPref.getString(CHANNEL_ID, "io.flutter.plugins.scheduler")
      val channelName =  sharedPref.getString(CHANNEL_NAME, "Scheduler")
      val channelImportance =  sharedPref.getInt(CHANNEL_IMPORTANCE, NotificationManager.IMPORTANCE_HIGH)

      // Create the NotificationChannel, but only on API 26+ because
      // the NotificationChannel class is new and not in the support library
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) { 

        val notificationManager: NotificationManager = 
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        val audioAttributes = AudioAttributes.Builder()
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .setUsage(AudioAttributes.USAGE_NOTIFICATION)
            .build()
    
        val channel = NotificationChannel(channelId, channelName, channelImportance)
        channel.enableLights(true);
        channel.setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION), audioAttributes);
    
        notificationManager.createNotificationChannel(channel)
      }
    }
  }// compation object
}