package com.project.personaltherapy

import android.util.Log
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.WearableListenerService
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

/**
 * Wear OS 앱으로부터 HRV 데이터를 수신하는 서비스
 */
class WearDataListenerService : WearableListenerService() {

    companion object {
        private const val TAG = "WearDataListener"
        private const val CHANNEL = "com.project.personaltherapy/samsung_health"

        // 최근 수신한 HRV 데이터 (정적 저장)
        var latestHrvData: Map<String, Any>? = null
    }

    override fun onDataChanged(dataEvents: DataEventBuffer) {
        for (event in dataEvents) {
            if (event.type == DataEvent.TYPE_CHANGED) {
                val item = event.dataItem

                if (item.uri.path == "/hrv_data") {
                    try {
                        val dataMap = DataMapItem.fromDataItem(item).dataMap

                        val rmssd = dataMap.getDouble("rmssd")
                        val avgHeartRate = dataMap.getInt("avgHeartRate")
                        val timestamp = dataMap.getLong("timestamp")
                        val formattedTime = dataMap.getString("formattedTime") ?: ""

                        Log.d(TAG, "=== HRV Data Received from Watch ===")
                        Log.d(TAG, "RMSSD: ${rmssd.toInt()} ms")
                        Log.d(TAG, "Avg Heart Rate: $avgHeartRate bpm")
                        Log.d(TAG, "Timestamp: $formattedTime")

                        // HRV 데이터 저장
                        latestHrvData = mapOf(
                            "rmssd" to rmssd,
                            "avgHeartRate" to avgHeartRate,
                            "timestamp" to timestamp,
                            "formattedTime" to formattedTime
                        )

                        // Flutter에 즉시 전달 시도 (앱이 실행 중인 경우)
                        notifyFlutterApp(latestHrvData!!)

                    } catch (e: Exception) {
                        Log.e(TAG, "Error processing HRV data: ${e.message}", e)
                    }
                }
            }
        }
    }

    /**
     * Flutter 앱이 실행 중이면 MethodChannel로 데이터 전달
     */
    private fun notifyFlutterApp(data: Map<String, Any>) {
        try {
            // MainActivity의 MethodChannel을 통해 Flutter에 전달
            MainActivity.instance?.let { activity ->
                activity.runOnUiThread {
                    val channel = MethodChannel(
                        activity.flutterEngine?.dartExecutor?.binaryMessenger ?: return@runOnUiThread,
                        CHANNEL
                    )
                    channel.invokeMethod("onHrvDataReceived", data)
                    Log.d(TAG, "✅ HRV data sent to Flutter app")
                }
            } ?: run {
                Log.d(TAG, "⚠️ MainActivity not available, data saved for later retrieval")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error notifying Flutter: ${e.message}", e)
        }
    }
}
