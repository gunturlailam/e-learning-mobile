class PaymentModel {
  final int id;
  final int userId;
  final int? packageId;
  final String menuName;
  final String amount;
  final String method;
  final String? proof;
  final String? proofUrl;
  final String status;
  final String? rejectReason;
  final String? bankAccountInfo;
  final String? qrCodeUrl;
  final String? createdAt;
  final String? updatedAt;

  PaymentModel({
    required this.id,
    required this.userId,
    this.packageId,
    required this.menuName,
    required this.amount,
    required this.method,
    this.proof,
    this.proofUrl,
    required this.status,
    this.rejectReason,
    this.bankAccountInfo,
    this.qrCodeUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      userId: json['user_id'] is int ? json['user_id'] : int.parse(json['user_id'].toString()),
      packageId: json['package_id'] != null ? (json['package_id'] is int ? json['package_id'] : int.parse(json['package_id'].toString())) : null,
      menuName: json['menu_name'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      method: json['method'] ?? '',
      proof: json['proof'],
      proofUrl: json['proof_url'],
      status: json['status'] ?? 'pending',
      rejectReason: json['reject_reason'] ?? json['note'],
      bankAccountInfo: json['bank_account_info'],
      qrCodeUrl: json['qr_code_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'package_id': packageId,
      'menu_name': menuName,
      'amount': amount,
      'method': method,
      'proof': proof,
      'proof_url': proofUrl,
      'status': status,
      'reject_reason': rejectReason,
      'bank_account_info': bankAccountInfo,
      'qr_code_url': qrCodeUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
