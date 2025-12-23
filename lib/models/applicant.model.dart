class Applicant {
  final String applicationID;
  final String name;
  final String appointmentDateTime;
  final String appointmentDate;
  final String appointmentTime;
  final String status;
  final dynamic regDto;
  final String postalCode;
  final List<String> dataCaptureLangs;

  Applicant({
    required this.applicationID,
    required this.name,
    required this.appointmentDateTime,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.regDto,
    required this.postalCode,
    required this.dataCaptureLangs,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      applicationID: json['applicationID'] ?? '',
      name: json['name'] ?? '',
      appointmentDateTime: json['appointmentDateTime'] ?? '',
      appointmentDate: json['appointmentDate'] ?? '',
      appointmentTime: json['appointmentTime'] ?? '',
      status: json['status'] ?? '',
      regDto: json['regDto'],
      postalCode: json['postalCode'] ?? '',
      dataCaptureLangs: List<String>.from(json['dataCaptureLangs'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applicationID': applicationID,
      'name': name,
      'appointmentDateTime': appointmentDateTime,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'status': status,
      'regDto': regDto,
      'postalCode': postalCode,
      'dataCaptureLangs': dataCaptureLangs,
    };
  }
}