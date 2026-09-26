import '../../domain/entities/basic_detail_entity.dart';

class BasicDetailModel extends BasicDetailEntity {
  BasicDetailModel({
    super.customerPhoto,
    required super.firstName,
    required super.lastName,
    required super.mobileNumber,
    super.alternateNumber,
    super.emailId,
    super.address,
    required super.acceptTerms,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerPhoto': customerPhoto?.path,
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'alternateNumber': alternateNumber,
      'emailId': emailId,
      'address': address,
      'acceptTerms': acceptTerms,
    };
  }
}