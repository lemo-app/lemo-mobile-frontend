class SchoolModel {
  final String id;
  final String schoolName;
  final String address;
  final String contactNumber;
  final String startTime;
  final String endTime;
  final String vpnUrl;
  final String logoUrl;
  final String createdAt;
  final String updatedAt;
  final String qrUrl;

  SchoolModel({
    this.id = '',
    this.schoolName = '',
    this.address = '',
    this.contactNumber = '',
    this.startTime = '',
    this.endTime = '',
    this.vpnUrl = '',
    this.logoUrl = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.qrUrl = '',
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: json['_id'] ?? '',
      schoolName: json['school_name'] ?? '',
      address: json['address'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      vpnUrl: json['vpn_config_url'] ?? ' ',
      logoUrl: json['logo_url'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      qrUrl: json['qr_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'school_name': schoolName,
      'address': address,
      'contact_number': contactNumber,
      'start_time': startTime,
      'end_time': endTime,
      'vpn_config_url':vpnUrl,
      'logo_url': logoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'qr_url': qrUrl,
    };
  }
}
