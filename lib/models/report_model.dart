import 'package:cloud_firestore/cloud_firestore.dart';

/// ReportModel represents a user report in ItoBound.
class ReportModel {
  final String reportId;
  final String reporterId;
  final String reportedUserId;
  final String reason;
  final String? details;
  final Timestamp reportedAt;

  ReportModel({
    required this.reportId,
    required this.reporterId,
    required this.reportedUserId,
    required this.reason,
    this.details,
    required this.reportedAt,
  });

  /// Converts Firestore document to ReportModel
  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    reportId: json['reportId'] as String,
    reporterId: json['reporterId'] as String,
    reportedUserId: json['reportedUserId'] as String,
    reason: json['reason'] as String,
    details: json['details'] as String?,
    reportedAt: json['reportedAt'] as Timestamp,
  );

  /// Converts ReportModel to JSON for Firestore
  Map<String, dynamic> toJson() => {
    'reportId': reportId,
    'reporterId': reporterId,
    'reportedUserId': reportedUserId,
    'reason': reason,
    'details': details,
    'reportedAt': reportedAt,
  };
}
