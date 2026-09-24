class SavePurchaseHistoryRequestModel {
  final String companyCode;
  final String purchaseCode;
  final String retailerCode;
  final String mappingCode;
  final String planCode;
  final double planAmount;
  final double discountAmount;
  final double gstAmount;
  final double netAmount;
  final String paymentMode;
  final String transactionNo;
  final String paymentReferenceNo;
  final String paymentStatus;
  final String purchaseDate;
  final String planStartDate;
  final String planEndDate;
  final String invoiceNo;
  final String remarks;
  final bool isActive;
  final String createdBy;

  SavePurchaseHistoryRequestModel({
    required this.companyCode,
    required this.purchaseCode,
    required this.retailerCode,
    required this.mappingCode,
    required this.planCode,
    required this.planAmount,
    required this.discountAmount,
    required this.gstAmount,
    required this.netAmount,
    required this.paymentMode,
    required this.transactionNo,
    required this.paymentReferenceNo,
    required this.paymentStatus,
    required this.purchaseDate,
    required this.planStartDate,
    required this.planEndDate,
    required this.invoiceNo,
    required this.remarks,
    required this.isActive,
    required this.createdBy,
  });

  SavePurchaseHistoryRequestModel copyWith({
    String? companyCode,
    String? purchaseCode,
    String? retailerCode,
    String? mappingCode,
    String? planCode,
    double? planAmount,
    double? discountAmount,
    double? gstAmount,
    double? netAmount,
    String? paymentMode,
    String? transactionNo,
    String? paymentReferenceNo,
    String? paymentStatus,
    String? purchaseDate,
    String? planStartDate,
    String? planEndDate,
    String? invoiceNo,
    String? remarks,
    bool? isActive,
    String? createdBy,
  }) {
    return SavePurchaseHistoryRequestModel(
      companyCode: companyCode ?? this.companyCode,
      purchaseCode: purchaseCode ?? this.purchaseCode,
      retailerCode: retailerCode ?? this.retailerCode,
      mappingCode: mappingCode ?? this.mappingCode,
      planCode: planCode ?? this.planCode,
      planAmount: planAmount ?? this.planAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      gstAmount: gstAmount ?? this.gstAmount,
      netAmount: netAmount ?? this.netAmount,
      paymentMode: paymentMode ?? this.paymentMode,
      transactionNo: transactionNo ?? this.transactionNo,
      paymentReferenceNo: paymentReferenceNo ?? this.paymentReferenceNo,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      planStartDate: planStartDate ?? this.planStartDate,
      planEndDate: planEndDate ?? this.planEndDate,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      remarks: remarks ?? this.remarks,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "companyCode": companyCode,
      "purchaseCode": purchaseCode,
      "retailerCode": retailerCode,
      "mappingCode": mappingCode,
      "planCode": planCode,
      "planAmount": planAmount,
      "discountAmount": discountAmount,
      "gstAmount": gstAmount,
      "netAmount": netAmount,
      "paymentMode": paymentMode,
      "transactionNo": transactionNo,
      "paymentReferenceNo": paymentReferenceNo,
      "paymentStatus": paymentStatus,
      "purchaseDate": purchaseDate,
      "planStartDate": planStartDate,
      "planEndDate": planEndDate,
      "invoiceNo": invoiceNo,
      "remarks": remarks,
      "isActive": isActive,
      "createdBy": createdBy,
    };
  }

  factory SavePurchaseHistoryRequestModel.fromJson(Map<String, dynamic> json) {
    return SavePurchaseHistoryRequestModel(
      companyCode: json['companyCode'] ?? '',
      purchaseCode: json['purchaseCode'] ?? '',
      retailerCode: json['retailerCode'] ?? '',
      mappingCode: json['mappingCode'] ?? '',
      planCode: json['planCode'] ?? '',
      planAmount: (json['planAmount'] ?? 0.0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0.0).toDouble(),
      gstAmount: (json['gstAmount'] ?? 0.0).toDouble(),
      netAmount: (json['netAmount'] ?? 0.0).toDouble(),
      paymentMode: json['paymentMode'] ?? '',
      transactionNo: json['transactionNo'] ?? '',
      paymentReferenceNo: json['paymentReferenceNo'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      purchaseDate: json['purchaseDate'] ?? '',
      planStartDate: json['planStartDate'] ?? '',
      planEndDate: json['planEndDate'] ?? '',
      invoiceNo: json['invoiceNo'] ?? '',
      remarks: json['remarks'] ?? '',
      isActive: json['isActive'] ?? true,
      createdBy: json['createdBy'] ?? '',
    );
  }
}