import 'features/settings/presentation/bloc/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app/app.dart';
import 'core/di/injection.dart';
import 'core/platform/google_maps_ios_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await GoogleMapsIosHelper.configure(dotenv.env['GOOGLE_MAPS_API_KEY'] ?? 'DUMMY_GOOGLE_MAPS_API_KEY');
  await _requestInitialPermissions();
  await configureDependencies();
  await sl<SettingsCubit>().init();
  runApp(const MovieApp());
}

Future<void> _requestInitialPermissions() async {
  await [
    Permission.camera,
    Permission.locationWhenInUse,
  ].request();
}
