import 'package:hostmi/api/utils/parse_string_to_bool.dart';

class HostmiUpdate {
  final DateTime? createdAt;
  final String? version;
  final String? androidLink;
  final String? iosLink;
  final bool? isRequired;
  final int? id;

  const HostmiUpdate({
    this.createdAt,
    this.version,
    this.androidLink,
    this.iosLink,
    this.id,
    this.isRequired,
  });

  factory HostmiUpdate.fromMap({required Map<dynamic, dynamic> data}) {
    return HostmiUpdate(
      createdAt: DateTime.tryParse(data["created_at"].toString()),
      version: data["version"],
      androidLink: data["android_link"],
      iosLink: data["ios_link"],
      id: int.parse(data["id"].toString()),
      isRequired: parseToBool(data["is_required"].toString()),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HostmiUpdate &&
        other.runtimeType == runtimeType &&
        other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
