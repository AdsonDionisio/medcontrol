package com.example.medcontrol_frontend

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.Handler
import android.os.Looper
import android.content.Context
import android.net.Uri

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.medcontrol_frontend/alarm"
    private val handler = Handler(Looper.getMainLooper())
    private var mediaPlayer: MediaPlayer? = null
    private var vibrationRunnable: Runnable? = null
    private var vibrator: Vibrator? = null
    private var isAlarmPlaying = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "playAlarm" -> {
                    playAlarmContinuously()
                    result.success(null)
                }
                "stopAlarm" -> {
                    stopAlarmContinuously()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun playAlarmContinuously() {
        if (isAlarmPlaying) return

        isAlarmPlaying = true

        try {
            // Obtém o som de notificação padrão do sistema
            val notificationUri: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            
            mediaPlayer = MediaPlayer()
            mediaPlayer?.apply {
                setDataSource(this@MainActivity, notificationUri)
                isLooping = true // Loop infinito
                setVolume(1.0f, 1.0f)
                prepare()
                start()
            }

            // Inicia vibração contínua
            startVibration()

        } catch (e: Exception) {
            e.printStackTrace()
            isAlarmPlaying = false
        }
    }

    private fun startVibration() {
        if (vibrationRunnable != null) return

        vibrationRunnable = object : Runnable {
            override fun run() {
                if (isAlarmPlaying) {
                    vibrateOnce()
                    handler.postDelayed(this, 1000) // Vibra a cada 1 segundo
                }
            }
        }

        handler.post(vibrationRunnable!!)
    }

    private fun vibrateOnce() {
        try {
            val pattern = longArrayOf(0, 200, 100)
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                vibrator?.vibrate(VibrationEffect.createWaveform(pattern, -1))
            } else {
                @Suppress("DEPRECATION")
                vibrator?.vibrate(pattern, -1)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun stopAlarmContinuously() {
        isAlarmPlaying = false

        try {
            if (mediaPlayer != null && mediaPlayer!!.isPlaying) {
                mediaPlayer!!.stop()
            }
            mediaPlayer?.release()
            mediaPlayer = null
        } catch (e: Exception) {
            e.printStackTrace()
        }

        if (vibrationRunnable != null) {
            handler.removeCallbacks(vibrationRunnable!!)
            vibrationRunnable = null
        }

        try {
            vibrator?.cancel()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
