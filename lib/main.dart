import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_coco_dataset/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}
