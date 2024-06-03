package save_us.galaxy

import android.content.Context
import android.content.Intent
import android.net.Uri

import android.os.Handler
import android.os.Looper

import io.flutter.embedding.engine.plugins.FlutterPlugin

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import androidx.health.connect.client.HealthConnectClient

class GalaxyPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "galaxy")

        channel.setMethodCallHandler(this)

        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getSdkStatus" -> result.success(getSdkStatus())

            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")

            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getSdkStatus(): Int {
        return HealthConnectClient.getSdkStatus(context)
    }
}