class DemoIdentityModel {
  final Map<String, dynamic> identity;

  DemoIdentityModel(this.identity);

  factory DemoIdentityModel.fromJson(Map<String, dynamic> json) {
    return DemoIdentityModel(Map<String, dynamic>.from(json['identity'] ?? {}));
  }

  Map<String, dynamic> toJson() {
    return {'identity': identity};
  }
}