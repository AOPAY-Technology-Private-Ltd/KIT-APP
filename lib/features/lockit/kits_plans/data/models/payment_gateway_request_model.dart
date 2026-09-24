class PaymentGatewayRequestModel {
  final String payCustomerPhoneNo;
  final String customerEmailID;
  final String registrationID;
  final String payCartAmount;
  final String eMINumbers;
  final String customerCode;
  final String payCustomerName;
  final String loanCode;
  final String retailerCode;

  PaymentGatewayRequestModel({
    required this.payCustomerPhoneNo,
    required this.customerEmailID,
    required this.registrationID,
    required this.payCartAmount,
    required this.eMINumbers,
    required this.customerCode,
    required this.payCustomerName,
    required this.loanCode,
    required this.retailerCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "PayCustomerPhoneNo": payCustomerPhoneNo,
      "CustomerEmailID": customerEmailID,
      "RegistrationID": registrationID,
      "PayCartAmount": payCartAmount,
      "EMINumbers": eMINumbers,
      "customerCode": customerCode,
      "PayCustomerName": payCustomerName,
      "LoanCode": loanCode,
      "RetailerCode": retailerCode,
    };
  }
}