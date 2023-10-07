import 'package:flutter/material.dart';
import 'package:home_rent/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:home_rent/loginRegister/loginOrRegister.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HomeRent App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade300),
        useMaterial3: true,
      ),
      home: const LoginOrRegister(),
    );
  }
}
