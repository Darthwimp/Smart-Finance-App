import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

Future<void> initHiveForTests() async {
  final testDir = Directory.current.path + '/test/hive_data';
  Hive.init(testDir);

  if (!Hive.isBoxOpen('transactions')) {
    await Hive.openBox('transactions');
  }
  if (!Hive.isBoxOpen('budgets')) {
    await Hive.openBox('budgets');
  }
}