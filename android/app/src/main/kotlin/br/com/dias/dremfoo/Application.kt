package br.com.dias.dremfoo

import io.flutter.app.FlutterApplication;


class Application : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
//        FlutterFirebaseMessagingService.setPluginRegistrant(this)
//        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
    }

//    override fun registerWith(registry: PluginRegistry?) {
//        GeneratedPluginRegistrant.registerWith(registry)
//    }

//    override fun registerWith(registry: PluginRegistry?) {
//        registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin");
//    }
}
