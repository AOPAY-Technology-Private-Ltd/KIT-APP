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
}