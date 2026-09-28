import '../../domain/entities/reference_entity.dart';

class ReferenceModel extends ReferenceEntity {
  const ReferenceModel({
    required super.firstName,
    required super.lastName,
    super.relationship,
    super.mobileNumber,
    super.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'relationship': relationship,
      'mobile_number': mobileNumber,
      'address': address,
    };
  }
}