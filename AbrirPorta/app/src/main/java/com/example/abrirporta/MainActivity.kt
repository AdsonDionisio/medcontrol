package com.example.abrirporta

import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import com.example.abrirporta.ui.theme.AbrirPortaTheme
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.eclipse.paho.client.mqttv3.MqttClient
import org.eclipse.paho.client.mqttv3.MqttConnectOptions
import org.eclipse.paho.client.mqttv3.MqttMessage
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence
import java.util.UUID

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            AbrirPortaTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    Box(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(innerPadding),
                        contentAlignment = Alignment.Center
                    ) {
                        OpenDoorButton()
                    }
                }
            }
        }
    }
}

@Composable
fun OpenDoorButton() {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()

    Button(onClick = {
        scope.launch {
            val result = withContext(Dispatchers.IO) {
                publishMqttMessage()
            }
            if (result) {
                Toast.makeText(context, "Porta aberta com sucesso!", Toast.LENGTH_SHORT).show()
            } else {
                Toast.makeText(context, "Falha ao abrir a porta.", Toast.LENGTH_SHORT).show()
            }
        }
    }) {
        Text(text = "Abrir porta")
    }
}

private fun publishMqttMessage(): Boolean {
    val brokerUrl = "tcp://200.129.71.149:1883"
    val clientId = UUID.randomUUID().toString()
    val topic = "Sede/Integra/porta"
    val content = "1"
    val user = "iotsousa"
    val pass = "!IntegraMaker2025"

    return try {
        val persistence = MemoryPersistence()
        val client = MqttClient(brokerUrl, clientId, persistence)
        val connOpts = MqttConnectOptions().apply {
            isCleanSession = true
            userName = user
            password = pass.toCharArray()
        }

        Log.d("MQTT", "Connecting to broker: $brokerUrl")
        client.connect(connOpts)
        
        Log.d("MQTT", "Publishing message: $content")
        val message = MqttMessage(content.toByteArray())
        message.qos = 1
        client.publish(topic, message)
        
        Log.d("MQTT", "Message published")
        client.disconnect()
        true
    } catch (e: Exception) {
        Log.e("MQTT", "Error publishing message: ${e.message}", e)
        false
    }
}
