import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:juru_stay/app.dart';
import 'package:juru_stay/features/places/presentation/places_page.dart';
import 'firebase_options.dart'; // You’ll generate this below

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}
