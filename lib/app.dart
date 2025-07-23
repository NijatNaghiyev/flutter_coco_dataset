import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coco_dataset/cubits/coco/coco_cubit.dart';
import 'package:flutter_coco_dataset/features/data/data_sources/remote/coco_dataset_service.dart';
import 'package:flutter_coco_dataset/features/data/repositories/coco_dataset_repository.dart';
import 'package:flutter_coco_dataset/presentation/screens/home/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'Flutter COCO Dataset',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: BlocProvider(
          create: (context) => CocoCubit(
            CocoDatasetRepositoryImple(
              cocoDatasetService: CocoDatasetService(),
            ),
          ),
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
