package br.com.dias.dremfoo

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;


class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
//        FlutterFirebaseMessagingService.setPluginRegistrant(this)
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
    }

//    override fun registerWith(registry: PluginRegistry?) {
//        GeneratedPluginRegistrant.registerWith(registry)
//    }

    override fun registerWith(registry: PluginRegistry?) {
        registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin");
    }
}
