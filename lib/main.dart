import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:travel_pack/view/authentication/login_view.dart';
import 'package:travel_pack/view/onboarding_view.dart';
import 'package:travel_pack/view/splash_view.dart';

import 'package:travel_pack/view_models/auth_view_model.dart';
import 'package:travel_pack/view_models/cloudinary_view_model.dart';
import 'package:travel_pack/view_models/trip_view_model.dart';

import 'data/services/nottification_services.dart';
import 'firebase_options.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  await NotificationService.init();

  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => TripViewModel()),
        ChangeNotifierProvider(create: (context) => CloudinaryViewModel()),
      ],

      child: MaterialApp(
        title: 'Trip Pack',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: SplashView(),
      ),
    );
  }
}
