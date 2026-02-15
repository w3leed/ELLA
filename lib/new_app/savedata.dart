import 'package:hive_flutter/hive_flutter.dart';

void saveData(String key, dynamic value) {
  var box = Hive.box(key);
  box.put(key, value);
}
