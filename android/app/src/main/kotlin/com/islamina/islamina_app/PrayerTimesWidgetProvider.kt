package com.islamina.islamina_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import com.islamina.islamina_app.R
import es.antonborri.home_widget.HomeWidgetPlugin
import android.os.SystemClock
import android.app.PendingIntent
import android.content.Intent


class PrayerTimesWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)
        for (appWidgetId in appWidgetIds) {
             // Access the SharedPreferences where data is stored by HomeWidget
        val widgetData = HomeWidgetPlugin.getData(context)


  val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
      /////////////////////////////////
      val todayDate= widgetData.getString("todayDate1", null)
      val widgetMeladyDate= widgetData.getString("meladyDate1", null)
        val combinedDate = if (todayDate != null && widgetMeladyDate != null) {
    "$todayDate - $widgetMeladyDate"
} else if (todayDate != null) {
    todayDate
} else if (widgetMeladyDate != null) {
    widgetMeladyDate
} else {
    "No Date Found For Now"
}

      setTextViewText(R.id.date_text_View, combinedDate ?: "No Date Found For Now")
      ////////////////////////////////////////////
               val fajrTime = widgetData.getString("fajrTime", null)
                setTextViewText(R.id.fajr_text_View, fajrTime ?: "No time set")
      val shroukTime = widgetData.getString("shroukTime", null)
      setTextViewText(R.id.chourouk_text_View, shroukTime ?: "No time set")
      val duhrTime = widgetData.getString("duhrTime", null)
      setTextViewText(R.id.dohr_text_View, duhrTime ?: "No time set")
      val asrTime = widgetData.getString("asrTime", null)
      setTextViewText(R.id.asr_text_View, asrTime ?: "No time set")
      val maghribTime = widgetData.getString("maghribTime", null)
      setTextViewText(R.id.maghrib_text_View, maghribTime ?: "No time set")
      val ishaTime = widgetData.getString("ishaTime", null)
      setTextViewText(R.id.ichaa_text_View, ishaTime ?: "No time set")
      ///////////////////////////////////////////////////////////////////////
      val currentPrayer = widgetData.getString("currentPrayer", null)
      val nextprayer= widgetData.getString("nextPrayer", null)
      val defaultColor = context.getColor(R.color.white)
   //  val defaultTint = context.getColor(R.color.default_image_tint)
setTextColor(R.id.fajr_text_View, defaultColor)
setTextColor(R.id.fajr_title_text_View, defaultColor)


setTextColor(R.id.chourouk_text_View, defaultColor)
setTextColor(R.id.chourouk_title_text_View, defaultColor)


setTextColor(R.id.dohr_text_View, defaultColor)
setTextColor(R.id.dohr_title_text_View, defaultColor)


setTextColor(R.id.asr_text_View, defaultColor)
setTextColor(R.id.asr_title_text_View, defaultColor)


setTextColor(R.id.maghrib_text_View, defaultColor)
setTextColor(R.id.maghrib_title_text_View, defaultColor)


setTextColor(R.id.ichaa_text_View, defaultColor)
setTextColor(R.id.ichaa_title_text_View, defaultColor)


      // Highlight color for the current prayer
      val highlightColor = context.getColor(R.color.sunrise)

     when (nextprayer) {
    "الفجر" -> {
        setTextColor(R.id.fajr_text_View, highlightColor)
        setTextColor(R.id.fajr_title_text_View, highlightColor)
    }
    "الشروق" -> {
        setTextColor(R.id.chourouk_text_View, highlightColor)
        setTextColor(R.id.chourouk_title_text_View, highlightColor)
    }
    "الظهر" -> {
        setTextColor(R.id.dohr_text_View, highlightColor)
        setTextColor(R.id.dohr_title_text_View, highlightColor)
    }
    "العصر" -> {
        setTextColor(R.id.asr_text_View, highlightColor)
        setTextColor(R.id.asr_title_text_View, highlightColor)
    }
    "المغرب" -> {
        setTextColor(R.id.maghrib_text_View, highlightColor)
        setTextColor(R.id.maghrib_title_text_View, highlightColor)
    }
    "العشاء" -> {
        setTextColor(R.id.ichaa_text_View, highlightColor)
        setTextColor(R.id.ichaa_title_text_View, highlightColor)
    }
}
      ///////////////////////////////////////////////////////////
   //   val nextprayer= widgetData.getString("nextPrayer", null)
    //  setTextViewText(R.id.next_prayer_name, nextprayer ?: "No countdown set")
   //   val countdown = widgetData.getString("nextPrayerCountdown",null)
   //   setTextViewText(R.id.next_prayer_time, countdown ?: "No countdown set")

   //   if (countdown > 0) {
    //      val countdownEnd = SystemClock.elapsedRealtime() + countdown
      //    setLong(R.id.next_prayer_time, "setBase", countdownEnd)
        //  setBoolean(R.id.next_prayer_time, "start", true)
     // }

            val intent = Intent(context, MainActivity::class.java)
                val pendingIntent = PendingIntent.getActivity(
                    context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

                // Set the PendingIntent to the root layout of the widget
                setOnClickPendingIntent(R.id.widget_root_layout, pendingIntent)
            }
            

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
     

          
        
}}
