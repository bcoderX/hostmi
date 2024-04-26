String version = "1.0.0+3";
List<int> parseVersion(String version) {
  final firstSplit = version.split(RegExp("[.|+]"));
  return firstSplit.map((e) => int.parse(e)).toList();
}

bool isCurrentVersionSmaller(String databaseVersion, String appVersion) {
  List<int> currentVersion = parseVersion(appVersion);
  List<int> dbVersion = parseVersion(databaseVersion);

  return currentVersion[0] < dbVersion[0] ||
      currentVersion[1] < dbVersion[1] ||
      currentVersion[2] < dbVersion[2] ||
      currentVersion[3] < dbVersion[3];
}
