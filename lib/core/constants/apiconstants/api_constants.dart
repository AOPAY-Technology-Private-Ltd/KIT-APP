class ApiConstants {
  static const String mainBaseUrl = 'https://uatapi.aopay.co.in';
  static const String smsBaseUrl = 'http://web.adcruxmedia.in';


  static const String kitRetailerLogin = '$mainBaseUrl/api/V1/AopayFinance/KitRetailerLogin';
  static const String sendOtp = '$mainBaseUrl/api/V1/AopayFinance/SendOTP';

  static const String verifyOtp = '$mainBaseUrl/api/V1/AopayFinance/VerifyOTP';
  static const String kitVerifyOtp = '$mainBaseUrl/api/V1/AopayFinance/KitVerifyOTP';


  static const String signup = '$mainBaseUrl/api/V1/AopayFinance/RetailerOnboardingKit';


  static const String verifyCustomerKit = '$mainBaseUrl/api/V1/AopayFinance/KitVerifyCustomer';

  static const String manageCustomer = '$mainBaseUrl/api/V1/AopayFinance/KitManageCustomer';


  static const String fetchHomeData = '$mainBaseUrl/api/V1/AopayFinance/GetRetailerKitReport';

  static const String getCustomerList = '$mainBaseUrl/api/V1/AopayFinance/KitManageCustomer';





  static const String sendSms = '$smsBaseUrl/vb/apikey.php';
}