import '../../domain/entities/emandate_entity.dart';

class EmandateModel extends EmandateEntity {
  const EmandateModel({required super.isAccepted});

  factory EmandateModel.fromEntity(EmandateEntity entity) {
    return EmandateModel(isAccepted: entity.isAccepted);
  }

  Map<String, dynamic> toJson() {
    return {
      'is_accepted': isAccepted,
    };
  }
}