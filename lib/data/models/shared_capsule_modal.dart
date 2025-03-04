
class SharedCapsule {
  final String sharedId;
  final String capsuleId;
  final String senderId;
  final String recipientId;
  final String status;
  final DateTime shareDate;


  SharedCapsule({
    required this.sharedId,
    required this.capsuleId,
    required this.senderId,
    required this.recipientId,
    required this.status,
    required this.shareDate,

  });

  factory SharedCapsule.fromJson(Map<String, dynamic> json) {
    return SharedCapsule(
      sharedId: json['sharedId'],
      capsuleId: json['capsuleId'],
      senderId: json['senderId'],
      recipientId: json['recipientId'],
      status: json['status'],
      shareDate:  DateTime.parse(json['shareDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sharedId': sharedId,
      'capsuleId': capsuleId,
      'senderId': senderId,
      'recipientId': recipientId,
      'status': status,
      'shareDate': shareDate.toIso8601String(),

    };
  }
}
