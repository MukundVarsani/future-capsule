import 'package:uuid/uuid.dart';

class CapsuleModel {
  final String capsuleId;
  final String creatorId;
  final String title;
  final String? description;
  final List<Media> media;
  final DateTime openingDate;
   final List<Recipient> recipients; 
  final Privacy privacy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final int likes;

  CapsuleModel(
      {required this.capsuleId,
      required this.creatorId,
      required this.title,
      required this.description,
      required this.media,
      required this.openingDate,
       required this.recipients,
      required this.privacy,
      required this.createdAt,
      required this.updatedAt,
      required this.status,
      this.likes = 0});

  factory CapsuleModel.fromJson(Map<String, dynamic> json) {
    return CapsuleModel(
      capsuleId: json['capsuleId'] ?? const Uuid().v4(),
      creatorId: json['creatorId'],
      title: json['title'],
      description: json['description'],
      media:
          (json['media'] as List).map((item) => Media.fromJson(item)).toList(),
      openingDate: DateTime.parse(json['openingDate']),
      recipients: (json['testRecipients'] as List<dynamic>?) // Nullable conversion
          ?.map((item) => Recipient.fromJson(item))
          .toList() ?? [],
      privacy: Privacy.fromJson(json['privacy']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      status: json['status'],
      likes: json['likes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'capsuleId': capsuleId,
      'creatorId': creatorId,
      'title': title,
      'description': description,
      'media': media.map((item) => item.toJson()).toList(),
      'openingDate': openingDate.toIso8601String(),
      'testRecipients': recipients.map((item) => item.toJson()).toList(),
      'privacy': privacy.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': createdAt.toIso8601String(),
      'status': status,
      "likes": likes,
    };
  }
}

class Media {
  final String mediaId;
  final String type;
  final String url;
  final String? thumbnail;

  Media({
    required this.mediaId,
    required this.thumbnail,
    required this.type,
    required this.url,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      mediaId: json['mediaId'] ?? const Uuid().v4(),
      type: json['type'],
      url: json['url'],
      thumbnail: json['thumbnail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mediaId': mediaId,
      'type': type,
      'url': url,
      'thumbnail': thumbnail,
    };
  }
}

class Recipient {
  final String recipientId;
  final String status;
  final DateTime createdAt;

  Recipient({
    required this.createdAt,
    required this.recipientId,
    required this.status,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      recipientId: json['recipientId'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipientId': recipientId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Privacy {
  final bool isTimePrivate;
  final bool isCapsulePrivate;
  final List<String?> sharedWith;

  Privacy({
    required this.isTimePrivate,
    required this.isCapsulePrivate,
    required this.sharedWith,
  });

  factory Privacy.fromJson(Map<String, dynamic> json) {
    return Privacy(
      isTimePrivate: json['isTimePrivate'],
      isCapsulePrivate: json['isCapsulePrivate'],
      sharedWith: List<String>.from(json['sharedWith']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isTimePrivate': isTimePrivate,
      'isCapsulePrivate': isCapsulePrivate,
      'sharedWith': sharedWith,
    };
  }
}
