import '../../domain/entities/loan_customer_entity.dart';
import 'package:intl/intl.dart';

class LoanCustomerModel extends LoanCustomerEntity {
  const LoanCustomerModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.email,
    required super.profileImage,
    required super.loanId,
    required super.principal,
    required super.monthlyEmi,
    required super.nextPaymentDate,
    required super.emIsRemaining,
    required super.status,
    required super.customerCode,
    required super.currentStep,
  });

  factory LoanCustomerModel.fromJson(Map<String, dynamic> json) {
    String displayStatus = json['displayStatus']?.toString() ?? 'Upcoming';

    String formattedDate = 'Pending';
    if (json['dueDate'] != null) {
      try {
        DateTime parsedDate = DateTime.parse(json['dueDate']);
        formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
      } catch (_) {
        formattedDate = json['dueDate'].toString();
      }
    }

    double principalVal = (json['principal'] as num?)?.toDouble() ?? 0.0;
    String formattedPrincipal = principalVal > 0
        ? '₹${NumberFormat('#,##,###', 'en_IN').format(principalVal)}'
        : 'Not Assigned';

    double emiVal = (json['monthlyEMI'] as num?)?.toDouble() ?? 0.0;
    String formattedEmi = emiVal > 0
        ? '₹${NumberFormat('#,##,###.##', 'en_IN').format(emiVal)}'
        : 'Not Assigned';

    var remaining = json['emIsRemaining'];
    String emIsRemainingStr = remaining != null ? '$remaining of 12' : 'Not Available';

    String loanIdStr = json['loanID']?.toString() ?? '';
    if (loanIdStr.isEmpty || loanIdStr == 'null') {
      loanIdStr = 'Pending Approval';
    }

    return LoanCustomerModel(
      id: json['customerCode']?.toString() ?? '',
      name: json['fullName']?.toString().replaceAll(RegExp(r'\s+'), ' ').trim() ?? 'Unknown',
      phone: json['mobileNumber']?.toString() ?? '',
      email: '',
      profileImage: json['customerImage']?.toString() ?? '',
      loanId: loanIdStr,
      principal: formattedPrincipal,
      monthlyEmi: formattedEmi,
      nextPaymentDate: formattedDate,
      emIsRemaining: emIsRemainingStr,
      status: displayStatus,
      customerCode: json['customerCode']?.toString() ?? '',
      currentStep: json['currentStep']?.toString() ?? '',
    );
  }
}