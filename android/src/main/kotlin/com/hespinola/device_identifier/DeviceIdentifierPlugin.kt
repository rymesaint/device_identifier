package com.hespinola.device_identifier

import android.annotation.SuppressLint
import android.app.Activity
import android.provider.Settings.Secure

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class DeviceIdentifierPlugin(activity: Activity): MethodCallHandler {
  private var activity: Activity? = null

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "device_identifier")
      channel.setMethodCallHandler(DeviceIdentifierPlugin(registrar.activity()))
    }
  }

  init {
      this.activity = activity
  }

  @SuppressLint("NewApi", "HardwareIds")
  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "id") {
      result.success(Secure.getString(activity?.contentResolver, Secure.ANDROID_ID))
    } else {
      result.notImplemented()
    }
  }
}
