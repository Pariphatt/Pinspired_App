import 'package:cnc_shop/route.dart';
import 'package:cnc_shop/screens/homepage_screen.dart';
import 'package:cnc_shop/screens/request_screen.dart';
import 'package:cnc_shop/service/auth_service.dart';
import 'package:cnc_shop/service/database_service.dart';
import 'package:cnc_shop/service/storage_service.dart';
import 'package:cnc_shop/themes/style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Error : ${details.exception}',
        style: const TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
    );
  };

  runApp(const MyApp());
}

final messageKey = GlobalKey<ScaffoldMessengerState>();


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        Provider<StorageService>(create: (_) => StorageService()),
        ProxyProvider<DatabaseService, AuthService>(
            update: (_, dbService, __) => AuthService(dbService: dbService))
      ],
      child: MaterialApp(
        scaffoldMessengerKey: messageKey,
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        initialRoute: '/login',
        routes: routes,
      ),
    );
  }
}
