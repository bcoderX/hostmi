class DatabaseResponse {
  const DatabaseResponse({
    this.isSuccess = false,
    this.list,
    this.count = 0,
    this.hasConnectionIssue = false,
    this.isTrue = false,
  });
  final int count;
  final bool isTrue;
  final bool isSuccess;
  final bool hasConnectionIssue;
  final List<Map<String, dynamic>>? list;
}

class DatabaseDynamicResponse {
  const DatabaseDynamicResponse({
    this.isSuccess = false,
    this.list,
    this.count = 0,
    this.hasConnectionIssue = false,
  });
  final int count;
  final bool isSuccess;
  final bool hasConnectionIssue;
  final List<dynamic>? list;
}
