class Booking {
  final String code;
  final String centreName;
  final String dayCode;
  final String animalType;
  final int hissas;
  final String amount;
  final String status;

  // NEW
  final int receivedAmount;
  final String reason;

  Booking({
    required this.code,
    required this.centreName,
    required this.dayCode,
    required this.animalType,
    required this.hissas,
    required this.amount,
    required this.status,

    // NEW
    required this.receivedAmount,
    required this.reason,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      code: json['code'] ?? '',
      centreName: json['centreName'] ?? '',
      dayCode: json['dayCode'] ?? '',
      animalType: json['animalType'] ?? '',
      hissas: int.tryParse(json['hissas'].toString()) ?? 0,
      amount: json['amount']?.toString() ?? '0',
      status: json['status'] ?? '',

      // NEW
      receivedAmount:
          int.tryParse(json['receivedAmount']?.toString() ?? '0') ?? 0,

      reason: json['reason'] ?? '',
    );
  }
}
