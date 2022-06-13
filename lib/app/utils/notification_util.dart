import 'dart:io';

import 'package:dremfoo/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationUtil {

  static final String ID_NOTIFICATION_REVO = 'br.com.dias.dremfoo.revo';

  static final String ID_NOTIFICATION_DAILY = 'br.com.dias.dremfoo.NOTIFICATION_DAILY';
  static final String CHANNEL_NOTIFICATION_DAILY = 'DAILY';
  static final String DESCRIPTION_NOTIFICATION_DAILY = 'Notication user daily';

  static final String ID_NOTIFICATION_WEEKLY = 'br.com.dias.dremfoo.NOTIFICATION_WEEKLY';
  static final String CHANNEL_NOTIFICATION_WEEKLY = 'WEEKLY';
  static final String DESCRIPTION_NOTIFICATION_WEEKLY = 'Notication user weekly';

  static final String CHANNEL_NOTIFICATION_PUSH = 'PUSH';
  static final String DESCRIPTION_NOTIFICATION_PUSH = 'Push notification';


  static void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }


  static Future<void> showNotification(String? title, String? textBody, {String? paylod}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        ID_NOTIFICATION_REVO, CHANNEL_NOTIFICATION_PUSH, channelDescription: DESCRIPTION_NOTIFICATION_PUSH,
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, textBody, platformChannelSpecifics,
        payload: paylod);
  }

  static Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  static Future<void> showBigPictureNotification() async {
    var largeIconPath = await _downloadAndSaveFile(
        'http://via.placeholder.com/48x48', 'largeIcon');
    var bigPicturePath = await _downloadAndSaveFile(
        'http://via.placeholder.com/400x800', 'bigPicture');
    var bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        channelDescription: 'big text channel description',
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  static Future<void> showBigPictureNotificationHideExpandedLargeIcon() async {
    var largeIconPath = await _downloadAndSaveFile(
        'http://via.placeholder.com/48x48', 'largeIcon');
    var bigPicturePath = await _downloadAndSaveFile(
        'http://via.placeholder.com/400x800', 'bigPicture');
    var bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        hideExpandedLargeIcon: true,
        contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        channelDescription: 'big text channel description',
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(Uri(host: url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static Future<void> showNotificationMediaStyle() async {
    var largeIconPath = await _downloadAndSaveFile(
        'http://via.placeholder.com/128x128/00FF00/000000', 'largeIcon');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      channelDescription: 'media channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: MediaStyleInformation(),
    );
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'notification title', 'notification body', platformChannelSpecifics);
  }

  static Future<void> showBigTextNotification() async {
    var bigTextStyleInformation = BigTextStyleInformation(
        'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        htmlFormatBigText: true,
        contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        channelDescription: 'big text channel description',
        styleInformation: bigTextStyleInformation);
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  static Future<void> showInboxNotification() async {
    var lines = <String>[];
    lines.add('line <b>1</b>');
    lines.add('line <i>2</i>');
    var inboxStyleInformation = InboxStyleInformation(lines,
        htmlFormatLines: true,
        contentTitle: 'overridden <b>inbox</b> context title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'inbox channel id', 'inboxchannel name', channelDescription: 'inbox channel description',
        styleInformation: inboxStyleInformation);
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'inbox title', 'inbox body', platformChannelSpecifics);
  }

  static Future<void> showGroupedNotifications() async {
    var groupKey = 'com.android.example.WORK_EMAIL';
    var groupChannelId = 'grouped channel id';
    var groupChannelName = 'grouped channel name';
    var groupChannelDescription = 'grouped channel description';
    // example based on https://developer.android.com/training/notify-user/group.html
    var firstNotificationAndroidSpecifics = AndroidNotificationDetails(
        groupChannelId, groupChannelName, channelDescription: groupChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: groupKey);
    var firstNotificationPlatformSpecifics =
    NotificationDetails(android: firstNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(1, 'Alex Faarborg',
        'You will not believe...', firstNotificationPlatformSpecifics);
    var secondNotificationAndroidSpecifics = AndroidNotificationDetails(
        groupChannelId, groupChannelName, channelDescription: groupChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: groupKey);
    var secondNotificationPlatformSpecifics =
    NotificationDetails(android: secondNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(
        2,
        'Jeff Chang',
        'Please join us to celebrate the...',
        secondNotificationPlatformSpecifics);

    // create the summary notification to support older devices that pre-date Android 7.0 (API level 24).
    // this is required is regardless of which versions of Android your application is going to support
    var lines = <String>[];
    lines.add('Alex Faarborg  Check this out');
    lines.add('Jeff Chang    Launch Party');
    var inboxStyleInformation = InboxStyleInformation(lines,
        contentTitle: '2 messages', summaryText: 'janedoe@example.com');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        groupChannelId, groupChannelName, channelDescription: groupChannelDescription,
        styleInformation: inboxStyleInformation,
        groupKey: groupKey,
        setAsGroupSummary: true);
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        3, 'Attention', 'Two messages', platformChannelSpecifics);
  }

  static Future<void> checkPendingNotificationRequests() async {
    var pendingNotificationRequests =
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print('${pendingNotificationRequests.length} pending notification requests');
  }

  static Future<void> cancelAllNotifications() async {
   return  await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    return await flutterLocalNotificationsPlugin.cancel(id);
  }



  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  static Future<tz.TZDateTime> _nextInstanceOfTime(Time time, {Duration duration = const Duration(days: 1)}) async {
    await _configureLocalTimeZone();
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(duration);
    }
    return scheduledDate;
  }

  static Future<tz.TZDateTime> _nextInstanceOfDateTime(DateTime time) async {
    await _configureLocalTimeZone();
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, time.year, time.month, time.day, time.hour, time.minute);
    return scheduledDate;
  }

  static Future<void> showDailyAtTime(int id, String? title, String? body, Time time,
      String idChannel,
      String channelName,
      String channelDescription,
      {Duration duration = const Duration(days: 1), DateTimeComponents matchTime = DateTimeComponents.time}) async {

    AndroidNotificationDetails specifics = AndroidNotificationDetails(idChannel, channelName, channelDescription: channelDescription);

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: specifics);

    tz.TZDateTime tzDateTime = await _nextInstanceOfTime(time, duration: duration);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static Future<void> showDailyAtDateTime(int id, String? title, String? body, DateTime dateTime,
      String idChannel,
      String channelName,
      String channelDescription,
      {DateTimeComponents matchTime = DateTimeComponents.time}) async {

    AndroidNotificationDetails specifics = AndroidNotificationDetails(idChannel, channelName, channelDescription: channelDescription);

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: specifics);

    tz.TZDateTime tzDateTime = await _nextInstanceOfDateTime(dateTime);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: matchTime);
  }

  static Future<void> showProgressNotification() async {
    var maxProgress = 5;
    for (var i = 0; i <= maxProgress; i++) {
      await Future.delayed(Duration(seconds: 1), () async {
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'progress channel',
            'progress channel',
            channelDescription: 'progress channel description',
            channelShowBadge: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: maxProgress,
            progress: i);
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            'progress notification title',
            'progress notification body',
            platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }

  static Future<void> _showIndeterminateProgressNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'indeterminate progress channel',
        'indeterminate progress channel',
       channelDescription:  'indeterminate progress channel description',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        indeterminate: true);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'indeterminate progress notification title',
        'indeterminate progress notification body',
        platformChannelSpecifics,
        payload: 'item x');
  }

  static Future<void> _showNotificationWithIconBadge() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'icon badge channel', 'icon badge name', channelDescription: 'icon badge description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(badgeNumber: 1);
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'icon badge title', 'icon badge body', platformChannelSpecifics,
        payload: 'item x');
  }

  static Future<void> _showNotificationWithCustomTimestamp() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      ID_NOTIFICATION_REVO,
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch - 120 * 1000,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  static Future<void> _showNotificationWithAttachment() async {
    var bigPicturePath = await _downloadAndSaveFile(
        'http://via.placeholder.com/600x200', 'bigPicture.jpg');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        attachments: [IOSNotificationAttachment(bigPicturePath)]);
    var bigPictureAndroidStyle =
    BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        ID_NOTIFICATION_REVO, 'your channel name', channelDescription: 'your channel description',
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: bigPictureAndroidStyle);
    var notificationDetails = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'notification with attachment title',
        'notification with attachment body',
        notificationDetails);
  }

  static  Future<void> deleteNotificationChannel(String channelId) async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(channelId);
  }


}