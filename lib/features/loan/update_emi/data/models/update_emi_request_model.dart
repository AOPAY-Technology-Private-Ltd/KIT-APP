import '../../domain/entities/emi_customer_entity.dart';

class UpdateEmiModel extends EmiUpdateEntity {
  const UpdateEmiModel({
    required super.loanId,
    required super.numberOfEmi,
    required super.paymentMode,
    required super.emiAmount,
    super.lateFees,
    super.bounceCharges,
    required super.paymentDate,
    required super.status,
    required super.transactionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'loan_id': loanId,
      'number_of_emi': numberOfEmi,
      'payment_mode': paymentMode,
      'emi_amount': emiAmount,
      'late_fees': lateFees,
      'bounce_charges': bounceCharges,
      'payment_date': paymentDate,
      'status': status,
      'transaction_id': transactionId,
    };
  }

  factory UpdateEmiModel.fromEntity(EmiUpdateEntity entity) {
    return UpdateEmiModel(
      loanId: entity.loanId,
      numberOfEmi: entity.numberOfEmi,
      paymentMode: entity.paymentMode,
      emiAmount: entity.emiAmount,
      lateFees: entity.lateFees,
      bounceCharges: entity.bounceCharges,
      paymentDate: entity.paymentDate,
      status: entity.status,
      transactionId: entity.transactionId,
    );
  }
}