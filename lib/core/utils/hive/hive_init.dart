import 'package:hive/hive.dart';

initHiveAdapters() {}

initHiveBoxes() async {
  await Hive.openBox("tokens");

  await Hive.openBox("id");
}
