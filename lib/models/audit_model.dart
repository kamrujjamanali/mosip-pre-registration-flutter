import 'package:intl/intl.dart';

class AuditModel {
  String? actionTimeStamp;
  String moduleName;
  String moduleId;
  String eventName;
  String description;
  String actionUserId;

  AuditModel({
    String? actionTimeStamp,
    this.moduleName = "PREREGISTRATION_UI",
    this.moduleId = "PREREG_UI",
    required this.eventName,
    required this.description,
    required this.actionUserId,
  }) {
    this.actionTimeStamp = actionTimeStamp ?? _getCurrentFormattedTimestamp();
  }

  /// Generates current timestamp in format: yyyy-MM-ddTHH:mm:ss.SSS±HH:mm
  /// Uses device's local timezone (equivalent to jstz.determine().name() in JS)
  String _getCurrentFormattedTimestamp() {
    final DateTime now = DateTime.now();
    final String formatted = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").format(now);

    // Get timezone offset
    final Duration offset = now.timeZoneOffset;
    final String sign = offset.isNegative ? '-' : '+';
    final String hours = offset.inHours.abs().toString().padLeft(2, '0');
    final String minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');

    return '$formatted$sign$hours:$minutes';
  }

  Map<String, dynamic> toJson() {
    return {
      'actionTimeStamp': actionTimeStamp,
      'moduleName': moduleName,
      'moduleId': moduleId,
      'eventName': eventName,
      'description': description,
      'actionUserId': actionUserId,
    };
  }
}