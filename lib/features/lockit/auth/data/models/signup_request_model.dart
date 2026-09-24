class SignupRequestModel {
  final String businessName;
  final String businessType;
  final String? gstNumber;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String emailID;

  final String? profilePhotoFileName;
  final String? adhaarFrontPhotoFileName;
  final String? adhaarBackPhotoFileName;
  final String? panCardFrontPhotoFileName;
  final String? cancleChequePhotoFileName;
  final String? storefrontPhotoFileName;
  final String? companyDocPhotoFileName;

  SignupRequestModel({
    required this.businessName,
    required this.businessType,
    this.gstNumber,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.emailID,
    this.profilePhotoFileName,
    this.adhaarFrontPhotoFileName,
    this.adhaarBackPhotoFileName,
    this.panCardFrontPhotoFileName,
    this.cancleChequePhotoFileName,
    this.storefrontPhotoFileName,
    this.companyDocPhotoFileName,
  });

  Map<String, dynamic> toJson() {
    return {
      "BussinessName": businessName,
      "BussinessType": businessType,
      "GSTNumber": gstNumber ?? "",
      "FirstName": firstName,
      "LastName": lastName,
      "MobileNumber": mobileNumber,
      "EmailID": emailID,
    };
  }
}