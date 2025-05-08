// class StudentDashboard {
//   final String id;
//   final String email;
//   final String accessToken;
//   final String refreshToken;
//   final int age;
//   final String gender;
//   final String section;
//   final String rollNo;
//   final String studentId;
//   final String type;
//   final bool emailVerified;
//   final String createdAt;
//   final String updatedAt;
//   final String school;
//
//   StudentDashboard({
//     required this.id,
//     required this.email,
//     required this.accessToken,
//     required this.refreshToken,
//     required this.age,
//     required this.gender,
//     required this.section,
//     required this.rollNo,
//     required this.studentId,
//     required this.type,
//     required this.emailVerified,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.school,
//   });
//
//   factory StudentDashboard.fromJson(Map<String, dynamic> json) {
//     return StudentDashboard(
//       id: json['_id'],
//       email: json['email'],
//       accessToken: json['accessToken'] ?? '',
//       refreshToken: json['refreshToken'] ?? '',
//       age: json['age'] ?? 0,
//       gender: json['gender'] ?? '',
//       section: json['section'] ?? '',
//       rollNo: json['roll_no'] ?? '',
//       studentId: json['student_id'] ?? '',
//       type: json['type'] ?? '',
//       emailVerified: json['email_verified'] ?? false,
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//       school: json['school'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'email': email,
//       'accessToken': accessToken,
//       'refreshToken': refreshToken,
//       'age': age,
//       'gender': gender,
//       'section': section,
//       'roll_no': rollNo,
//       'student_id': studentId,
//       'type': type,
//       'email_verified': emailVerified,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       'school': school,
//     };
//   }
// }

class StudentDashboard {
  String id;
  String email;
  String? accessToken;
  String? refreshToken;
  int? age;
  String? gender;
  String? section;
  String? rollNo;
  String? studentId;
  String? type;
  bool emailVerified;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  Schools school;
  // String fullName;
  // String? avatarUrl;

  StudentDashboard({
    required this.id,
    required this.email,
    this.accessToken,
    this.refreshToken,
    this.age,
    this.gender,
    this.section,
    this.rollNo,
    this.studentId,
    this.type,
    required this.emailVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.school,
    // required this.fullName,
    // this.avatarUrl,
  });

  factory StudentDashboard.fromJson(Map<String, dynamic> json) {
    return StudentDashboard(
      id: json['_id'] as String,
      email: json['email'] as String,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      section: json['section'] as String?,
      rollNo: json['roll_no'] as String?,
      studentId: json['student_id'] as String?,
      type: json['type'] as String?,
      emailVerified: json['email_verified'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
      school: Schools.fromJson(json['school'] as Map<String, dynamic>),
      // fullName: json['full_name'] as String,
      // avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'age': age,
      'gender': gender,
      'section': section,
      'roll_no': rollNo,
      'student_id': studentId,
      'type': type,
      'email_verified': emailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'school': school.toJson(),
      // 'full_name': fullName,
      // 'avatar_url': avatarUrl,
    };
  }
}

class Schools {
  String id;
  String schoolName;
  String address;
  String description;
  DateTime startTime;
  DateTime endTime;
  String vpnConfigUrl;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String qrUrl;

  Schools({
    required this.id,
    required this.schoolName,
    required this.address,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.vpnConfigUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.qrUrl,
  });

  factory Schools.fromJson(Map<String, dynamic> json) {
    return Schools(
      id: json['_id'] as String,
      schoolName: json['school_name'] as String,
      address: json['address'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      vpnConfigUrl: json['vpn_config_url'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
      qrUrl: json['qr_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'school_name': schoolName,
      'address': address,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'vpn_config_url': vpnConfigUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'qr_url': qrUrl,
    };
  }
}