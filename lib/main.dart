import 'package:chatify/constants/config.dart';
import 'package:chatify/models/user.dart';
import 'package:chatify/pages/login/view.dart';
import 'package:chatify/pages/register/view.dart';
import 'package:chatify/pages/welcome/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/contact.dart';
import 'models/message.dart';
import 'models/room.dart';
import 'pages/chat/view.dart';
import 'pages/messages/view.dart';
import 'pages/properties/view.contact.dart';
import 'pages/properties/view.room.dart';
import 'pages/settings/view.dart';
import 'pages/splash/view.dart';

void main() async {
  await GetStorage.init();
  // Hive init & adapters
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(ContactAdapter());
  Hive.registerAdapter(RoomAdapter());
  // Run app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chatify',
        theme: Config.primaryThemeData,
        initialRoute: PageRoutes.splash,
        getPages: [
          GetPage(name: PageRoutes.welcome, page: () => const Welcome()),
          GetPage(name: PageRoutes.register, page: () => Register()),
          GetPage(name: PageRoutes.signIn, page: () => Login()),
          GetPage(name: PageRoutes.messages, page: () => const Messages()),
          GetPage(name: PageRoutes.settings, page: () => Settings()),
          GetPage(name: PageRoutes.splash, page: () => Splash()),
          GetPage(name: PageRoutes.chat, page: () => Chat()),
          GetPage(
              name: PageRoutes.roomProperties, page: () => RoomProperties()),
          GetPage(
              name: PageRoutes.contactProperties,
              page: () => ContactProperties()),
        ],
      ),
    );
  }
}
