import 'package:GUConnect/src/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  late String id;
  late String reportedContentId;
  late CustomUser reportedUser;
  late String reportedContent;
  late String reportType; // comment / post / confession
  late DateTime createdAt;
  late String? image;

  Report(
      {required this.reportedContentId,
      required this.reportedUser,
      required this.reportedContent,
      required this.reportType,
      required this.createdAt,
      this.image}) {
    id = createdAt.toString() + reportedContentId;
  }

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reportedContentId = json['reportedContentId'];
    reportedUser =
        CustomUser.fromJson((json['reportedUser'] as Map<String, dynamic>));
    reportedContent = json['reportedContent'];
    reportType = json['reportType'];
    createdAt = DateTime.parse(json['createdAt']);
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reportedContentId'] = reportedContentId;
    data['reportedUser'] = reportedUser.toJson();
    data['reportedContent'] = reportedContent;
    data['reportType'] = reportType;
    data['createdAt'] = createdAt.toString();
    data['image'] = image;
    return data;
  }

  @override
  String toString() {
    return 'Report{id: $id, reportedContentId: $reportedContentId, reportType: $reportType, createdAt: $createdAt}';
  }
}
