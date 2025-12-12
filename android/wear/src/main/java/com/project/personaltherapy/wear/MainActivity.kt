package com.project.personaltherapy.wear

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat

class MainActivity : AppCompatActivity() {

    private lateinit var statusText: TextView
    private lateinit var startButton: Button
    private lateinit var stopButton: Button
    private lateinit var sensorTestButton: Button

    private val permissionsLauncher = registerForActivityResult(
        ActivityResultContracts.RequestMultiplePermissions()
    ) { permissions ->
        val allGranted = permissions.values.all { it }
        if (allGranted) {
            statusText.text = "✅ 권한 허용됨\n서비스를 시작할 수 있습니다"
            startButton.isEnabled = true
        } else {
            statusText.text = "❌ 권한이 필요합니다\n설정에서 권한을 허용해주세요"
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 간단한 UI 생성
        val layout = android.widget.LinearLayout(this).apply {
            orientation = android.widget.LinearLayout.VERTICAL
            setPadding(16, 16, 16, 16)
        }

        statusText = TextView(this).apply {
            text = "HRV Monitor\n\n권한을 확인 중..."
            textSize = 14f
            setPadding(0, 0, 0, 32)
        }

        startButton = Button(this).apply {
            text = "측정 시작"
            isEnabled = false
            setOnClickListener {
                startHrvService()
            }
        }

        stopButton = Button(this).apply {
            text = "측정 중지"
            setOnClickListener {
                stopHrvService()
            }
        }

        sensorTestButton = Button(this).apply {
            text = "센서 테스트"
            setOnClickListener {
                val intent = Intent(this@MainActivity, SensorTestActivity::class.java)
                startActivity(intent)
            }
        }

        layout.addView(statusText)
        layout.addView(startButton)
        layout.addView(stopButton)
        layout.addView(sensorTestButton)

        setContentView(layout)

        // 권한 확인 및 요청
        checkAndRequestPermissions()
    }

    private fun checkAndRequestPermissions() {
        val requiredPermissions = mutableListOf(
            Manifest.permission.BODY_SENSORS,
        )

        // Android 13+ (API 33)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            requiredPermissions.add(Manifest.permission.POST_NOTIFICATIONS)
        }

        val permissionsToRequest = requiredPermissions.filter {
            ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }

        if (permissionsToRequest.isEmpty()) {
            statusText.text = "✅ 모든 권한 허용됨\n서비스를 시작할 수 있습니다"
            startButton.isEnabled = true
        } else {
            statusText.text = "권한 요청 중..."
            permissionsLauncher.launch(permissionsToRequest.toTypedArray())
        }
    }

    private fun startHrvService() {
        val intent = Intent(this, HrvMonitorService::class.java)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }

        statusText.text = """
            ✅ HRV 측정 시작

            5분마다 자동으로 측정합니다.
            - 1분간 심박수 측정
            - HRV(RMSSD) 계산
            - 폰 앱으로 전송
            - 4분 대기

            워치를 착용한 상태에서
            움직임을 최소화하세요.
        """.trimIndent()

        startButton.isEnabled = false
        stopButton.isEnabled = true
    }

    private fun stopHrvService() {
        val intent = Intent(this, HrvMonitorService::class.java)
        stopService(intent)

        statusText.text = "⏹️ HRV 측정 중지됨"
        startButton.isEnabled = true
        stopButton.isEnabled = false
    }
}
