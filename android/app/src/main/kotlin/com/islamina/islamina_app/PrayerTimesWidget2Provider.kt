package com.islamina.islamina_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.os.SystemClock
import android.widget.RemoteViews
import com.islamina.islamina_app.R
import es.antonborri.home_widget.HomeWidgetPlugin

class PrayerTimesWidget2Provider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)

        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            

            val countdown = widgetData.getInt("nextPrayerCountdown2", 0) // Countdown in seconds
            val nextPrayer = widgetData.getString("nextPrayer", "Next Prayer")
            val nextPrayerTime = widgetData.getString("nextPrayerTime", "00:00")
            val todayDate= widgetData.getString("todayDate", null)
            val widgetMeladyDate= widgetData.getString("meladyDate", null)
            val secondPrayerName=widgetData.getString("secondPrayerName", "Next Prayer")
            val secondPrayerTime=widgetData.getString("secondPrayerTime", "Next Prayer")
            val thirdprayerName=widgetData.getString("thirdPrayerName", "Next Prayer")
            val thirdprayerTime=widgetData.getString("thirdPrayerTime", "Next Prayer")

              val combinedDate = if (todayDate != null && widgetMeladyDate != null) {
    "$todayDate - $widgetMeladyDate"
} else if (todayDate != null) {
    todayDate
} else if (widgetMeladyDate != null) {
    widgetMeladyDate
} else {
    "No Date Found For Now"
}

            val views = RemoteViews(context.packageName, R.layout.widget2_layout)

            // Set prayer name and time
            views.setTextViewText(R.id.next_prayer_name, nextPrayer)
            views.setTextViewText(R.id.next_prayer_time, nextPrayerTime)
            views.setTextViewText(R.id.date_text_View2, combinedDate ?: "No Date Found For Now")
            views.setTextViewText(R.id.next_next_prayer_name_tv, secondPrayerName ?: "No Date Found For Now")
            views.setTextViewText(R.id.next_next_prayer_timing_tv, secondPrayerTime ?: "No Date Found For Now")
            views.setTextViewText(R.id.next_next_next_prayer_name_tv, thirdprayerName ?: "No Date Found For Now")
            views.setTextViewText(R.id.next_next_next_prayer_timing_tv, thirdprayerTime ?: "No Date Found For Now")




            // Set Chronometer to countdown
            val baseTime = SystemClock.elapsedRealtime() + countdown * 1000L
            views.setChronometer(
                R.id.countdown_chronometer,
                baseTime,
                null,
                true // Automatically start countdown
            )

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
