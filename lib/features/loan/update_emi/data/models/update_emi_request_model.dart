class EmiPaymentDetailModel {
  final String customerName;
  final String customerCode;
  final String customerMobile;
  final String loanCode;
  final double loanAmount;
  final double totalPaid;
  final double emiAmount;
  final double outstandingAmount;
  final String nextDueDate;
  final String customerStatus;
  final String? profileImage;
  final double lateFees;
  final double bounceCharges;
  final String paymentMode;
  final String transactionId;
  final String status;
  final int totalEmiCount;
  final int paidEmiCount;
  final int nextEmiNumber;
  final String loanStatus;
  final String loanMessage;

  const EmiPaymentDetailModel({
    required this.customerName,
    required this.customerCode,
    required this.customerMobile,
    required this.loanCode,
    required this.loanAmount,
    required this.totalPaid,
    required this.emiAmount,
    required this.outstandingAmount,
    required this.nextDueDate,
    required this.customerStatus,
    this.profileImage,
    required this.lateFees,
    required this.bounceCharges,
    required this.paymentMode,
    required this.transactionId,
    required this.status,
    required this.totalEmiCount,
    required this.paidEmiCount,
    required this.nextEmiNumber,
    required this.loanStatus,
    required this.loanMessage,
  });

  factory EmiPaymentDetailModel.fromJson(Map<String, dynamic> json) {
    int totalCount = int.tryParse(json['totalEmiCount']?.toString() ?? '6') ?? 6;
    int paidCount = int.tryParse(json['paidEmiCount']?.toString() ?? '0') ?? 0;

    int nextEmi = paidCount + 1;
    var payableEmisList = json['payableEmis'] as List?;
    if (payableEmisList != null && payableEmisList.isNotEmpty) {
      nextEmi = int.tryParse(payableEmisList[0]['numberOfEmi']?.toString() ?? '') ?? (paidCount + 1);
    }

    return EmiPaymentDetailModel(
      customerName: json['customerName']?.toString() ?? 'N/A',
      customerCode: json['customerCode']?.toString() ?? '',
      customerMobile: json['customerMobile']?.toString() ?? '',
      loanCode: json['loanCode']?.toString() ?? '',
      loanAmount: double.tryParse(json['loanAmount']?.toString() ?? '0') ?? 0.0,
      totalPaid: double.tryParse(json['totalPaid']?.toString() ?? '0') ?? 0.0,
      emiAmount: double.tryParse(json['currentEmiAmount']?.toString() ?? json['monthlyEmi']?.toString() ?? '0') ?? 0.0,
      outstandingAmount: double.tryParse(json['outstandingAmount']?.toString() ?? '0') ?? 0.0,
      nextDueDate: json['nextDueDate']?.toString() ?? json['dueDate']?.toString() ?? '',
      customerStatus: json['customerStatus']?.toString() ?? 'Active',
      profileImage: json['customerImage']?.toString() ?? json['avatarUrl']?.toString(),
      lateFees: double.tryParse(json['lateFees']?.toString() ?? '0') ?? 0.0,
      bounceCharges: double.tryParse(json['bounceCharges']?.toString() ?? '0') ?? 0.0,
      paymentMode: json['paymentMode']?.toString() ?? 'Cash',
      transactionId: json['transactionId']?.toString() ?? json['paymentReference']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Paid',
      totalEmiCount: totalCount,
      paidEmiCount: paidCount,
      nextEmiNumber: nextEmi,
      loanStatus: json['loanStatus']?.toString() ?? 'Close',
      loanMessage: json['loanMessage']?.toString() ?? 'All payable EMIs are completed. Loan is ready to close.',
    );
  }
}