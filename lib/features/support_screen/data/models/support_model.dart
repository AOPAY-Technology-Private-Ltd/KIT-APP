import '../../domain/entities/support_entity.dart';

class FaqModel extends FaqEntity {
  const FaqModel({
    required super.id,
    required super.question,
    required super.answer,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id']?.toString() ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
    };
  }
}

class SupportInfoModel extends SupportInfoEntity {
  const SupportInfoModel({
    required super.phone,
    required super.whatsapp,
    required super.email,
  });

  factory SupportInfoModel.fromJson(Map<String, dynamic> json) {
    return SupportInfoModel(
      phone: json['phone'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'whatsapp': whatsapp,
      'email': email,
    };
  }
}