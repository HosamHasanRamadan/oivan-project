import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oivan_project/service/local_storage.dart';

Future<ProviderContainer> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await LocalStorage.init();
  final overriddenValue = localStorageProvider.overrideWith(
    (ref) {
      ref.onDispose(() {
        storage.database.close();
      });
      return storage;
    },
  );

  return ProviderContainer(
    overrides: [
      overriddenValue,
    ],
  );
}
