class Student {
  String id;
  String email;
  String password;
  String accessToken;
  String refreshToken;
  int age;
  String gender;
  String section;
  String rollNo;
  String studentId;
  String type;
  bool emailVerified;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Student({
    this.id = '',
    this.email = '',
    this.password = '',
    this.accessToken = '',
    this.refreshToken = '',
    this.age = 0,
    this.gender = '',
    this.section = '',
    this.rollNo = '',
    this.studentId = '',
    this.type = 'student',
    this.emailVerified = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.v = 0,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert JSON to Student object
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      section: json['section'] ?? '',
      rollNo: json['roll_no'] ?? '',
      studentId: json['student_id'] ?? '',
      type: json['type'] ?? 'student',
      emailVerified: json['email_verified'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      v: json['__v'] ?? 0,
    );
  }

  // Convert Student object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'password': password,
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
    };
  }

  // Parse JSON list into a list of Student objects
  static List<Student> parseData(List<dynamic> jsonList) {
    return jsonList.map((json) => Student.fromJson(json)).toList();
  }
}
