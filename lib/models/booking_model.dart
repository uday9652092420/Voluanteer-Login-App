class Booking {
  final String code;
  final String centreName;
  final String dayCode;
  final String animalType;
  final int hissas;
  final String amount;
  final String status;

  Booking({
    required this.code,
    required this.centreName,
    required this.dayCode,
    required this.animalType,
    required this.hissas,
    required this.amount,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      code: json['code'] ?? '',
      centreName: json['centreName'] ?? '',
      dayCode: json['dayCode'] ?? '',
      animalType: json['animalType'] ?? '',
      hissas: json['hissas'] ?? 0,
      amount: json['amount']?.toString() ?? '0',
      status: json['status'] ?? '',
    );
  }
}
