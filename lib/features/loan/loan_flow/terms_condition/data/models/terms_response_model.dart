import '../../domain/entities/terms_entity.dart';

class TermsResponseModel extends TermsEntity {
  TermsResponseModel({
    required bool isAccepted,
    required String message,
  }) : super(isAccepted: isAccepted, message: message);

  factory TermsResponseModel.fromJson(Map<String, dynamic> json) {
    return TermsResponseModel(
      isAccepted: json['is_accepted'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_accepted': isAccepted,
      'message': message,
    };
  }
}