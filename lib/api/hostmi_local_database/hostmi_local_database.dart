import 'package:hive/hive.dart';

import '../constants/roles.dart';

var hostmiBox = Hive.box("hostmiLocalDatabase");

String keyRole = "role";

void setInt(String key, int value) => hostmiBox.put(key, value);
void setString(String key, String value) => hostmiBox.put(key, value);
void setData(String key, dynamic value) => hostmiBox.put(key, value);

int? getInt(String key) => hostmiBox.get(key);
String? getString(String key) => hostmiBox.get(key);
dynamic getData(String key) => hostmiBox.get(key);

//Setters
void setRole(Role role) => setData(keyRole, role);

//Getters
Role getRole() => getData(keyRole) ?? Role.UNKNOWN;
