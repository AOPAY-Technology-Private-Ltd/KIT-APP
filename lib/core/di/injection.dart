import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../features/loan/customer_detail/data/datasources/customer_remote_data_source.dart' as new_datasource;
import '../../features/loan/customer_detail/data/repositories/customer_repository_impl.dart' as new_repo;
import '../../features/loan/customer_detail/domain/repositories/customer_repository.dart' as new_repo_interface;
import '../../features/loan/customer_detail/domain/usecases/get_customer_detail_usecase.dart' as new_usecase;
import '../../features/loan/customer_detail/presentation/bloc/customer_bloc.dart' as new_bloc;

import '../../features/loan/customer_list/data/datasources/loan_customer_remote_data_source.dart';
import '../../features/loan/customer_list/data/repositories/loan_customer_repository_impl.dart';
import '../../features/loan/customer_list/domain/repositories/loan_customer_repository.dart';
import '../../features/loan/customer_list/domain/usecases/get_loan_customers_usecase.dart';
import '../../features/loan/customer_list/presentation/bloc/loan_customer_bloc.dart';
import '../../features/loan/enach_request/data/datasources/enach_request_local_data_source.dart';
import '../../features/loan/enach_request/data/repositories/enach_request_repository_impl.dart';
import '../../features/loan/enach_request/domain/repositories/enach_request_repository.dart';
import '../../features/loan/enach_request/domain/usecases/get_enach_requests_usecase.dart';
import '../../features/loan/enach_request/presentation/bloc/enach_request_bloc.dart';
import '../../features/loan/enach_review/data/datasources/enach_review_remote_datasource.dart';
import '../../features/loan/enach_review/data/repositories/enach_review_repository_impl.dart';
import '../../features/loan/enach_review/domain/repositories/enach_review_repository.dart';
import '../../features/loan/enach_review/domain/usecases/update_enach_status_usecase.dart';
import '../../features/loan/enach_review/presentation/bloc/enach_review_bloc.dart';
import '../../features/loan/loan_flow/bank_detail/data/datasources/bank_detail_remote_data_source.dart';
import '../../features/loan/loan_flow/bank_detail/data/repositories/bank_detail_repository_impl.dart';
import '../../features/loan/loan_flow/bank_detail/domain/repositories/bank_detail_repository.dart';
import '../../features/loan/loan_flow/bank_detail/domain/usecases/get_bank_list_usecase.dart';
import '../../features/loan/loan_flow/bank_detail/domain/usecases/submit_bank_detail_usecase.dart';
import '../../features/loan/loan_flow/bank_detail/domain/usecases/setup_auto_upi_usecase.dart';
import '../../features/loan/loan_flow/bank_detail/presentation/bloc/bank_detail_bloc.dart';
import '../../features/loan/loan_flow/basic_detail/data/datasources/basic_details_remote_data_source.dart';
import '../../features/loan/loan_flow/basic_detail/data/repositories/basic_details_repository_impl.dart';
import '../../features/loan/loan_flow/basic_detail/domain/repositories/basic_loan_repository.dart';
import '../../features/loan/loan_flow/basic_detail/domain/usecases/submit_basic_details_usecase.dart';
import '../../features/loan/loan_flow/basic_detail/presentation/bloc/basic_details_bloc.dart';
import '../../features/loan/loan_flow/create_loan/data/datasources/create_loan_remote_data_source.dart';
import '../../features/loan/loan_flow/create_loan/data/repositories/create_loan_repository_impl.dart';
import '../../features/loan/loan_flow/create_loan/domain/repositories/create_loan_repository.dart';
import '../../features/loan/loan_flow/create_loan/domain/usecases/get_credit_report_usecase.dart';
import '../../features/loan/loan_flow/create_loan/domain/usecases/submit_documents_usecase.dart';
import '../../features/loan/loan_flow/create_loan/domain/usecases/verify_aadhaar_usecase.dart';
import '../../features/loan/loan_flow/create_loan/domain/usecases/verify_pan_usecase.dart';
import '../../features/loan/loan_flow/create_loan/domain/usecases/check_loan_reapply_eligibility_usecase.dart';
import '../../features/loan/loan_flow/create_loan/presentation/bloc/create_loan_bloc.dart';
import '../../features/loan/loan_flow/emandate/data/datasources/emandate_remote_datasource.dart';
import '../../features/loan/loan_flow/emandate/data/repositories/emandate_repository_impl.dart';
import '../../features/loan/loan_flow/emandate/domain/repositories/emandate_repository.dart';
import '../../features/loan/loan_flow/emandate/domain/usecases/submit_emandate_usecase.dart';
import '../../features/loan/loan_flow/emandate/presentation/bloc/emandate_bloc.dart';
import '../../features/loan/loan_flow/loan_detail/data/datasources/loan_detail_remote_datasource.dart';
import '../../features/loan/loan_flow/loan_detail/data/loan_detail_repository_impl/loan_detail_repository_impl.dart';
import '../../features/loan/loan_flow/loan_detail/domain/repositories/loan_detail_repository.dart';
import '../../features/loan/loan_flow/loan_detail/domain/usecases/submit_loan_detail_usecase.dart';
import '../../features/loan/loan_flow/loan_detail/presentation/bloc/loan_detail_bloc.dart';
import '../../features/loan/loan_flow/loan_history/data/datasources/loan_history_remote_datasource.dart';
import '../../features/loan/loan_flow/loan_history/data/repositories/loan_history_repository_impl.dart';
import '../../features/loan/loan_flow/loan_history/domain/repositories/loan_repository.dart';
import '../../features/loan/loan_flow/loan_history/domain/usecases/get_loan_portfolio_usecase.dart';
import '../../features/loan/loan_flow/loan_history/presentation/bloc/loan_history_bloc.dart';
import '../../features/loan/loan_flow/reference_deatils/data/datasources/reference_remote_data_source.dart';
import '../../features/loan/loan_flow/reference_deatils/data/repositories/loan_disbursed_repository.dart';
import '../../features/loan/loan_flow/reference_deatils/data/repositories/reference_repository_impl.dart';
import '../../features/loan/loan_flow/reference_deatils/domain/repositories/reference_repository.dart';
import '../../features/loan/loan_flow/reference_deatils/domain/usecases/submit_reference_usecase.dart';
import '../../features/loan/loan_flow/reference_deatils/presentation/bloc/reference_bloc.dart';

import '../../features/loan/loan_flow/reference_deatils/data/datasources/loan_disbursed_remote_data_source.dart';
import '../../features/loan/loan_flow/reference_deatils/domain/usecases/update_loan_disbursed_usecase.dart';
import '../../features/loan/loan_flow/reference_deatils/presentation/bloc/loan_disbursed_bloc.dart';

import '../../features/loan/loan_flow/terms_condition/data/datasources/terms_condition_remote_datasource.dart';
import '../../features/loan/loan_flow/terms_condition/data/repositories/terms_condition_repository_impl.dart';
import '../../features/loan/loan_flow/terms_condition/domain/repositories/terms_condition_repository.dart';
import '../../features/loan/loan_flow/terms_condition/domain/usecases/accept_terms_usecase.dart';
import '../../features/loan/loan_flow/terms_condition/presentation/bloc/terms_bloc.dart';
import '../../features/loan/loan_reports/data/datasources/loan_report_remote_data_source.dart';
import '../../features/loan/loan_reports/data/repositories/loan_report_repository_impl.dart';
import '../../features/loan/loan_reports/domain/repositories/loan_report_repository.dart';
import '../../features/loan/loan_reports/domain/usecases/get_loan_reports_usecase.dart';
import '../../features/loan/loan_reports/presentation/bloc/loan_report_bloc.dart';
import '../../features/loan/update_emi/data/datasources/update_emi_remote_datasource.dart';
import '../../features/loan/update_emi/data/repositories/update_emi_repository_impl.dart';
import '../../features/loan/update_emi/domain/repositories/update_emi_repository.dart';
import '../../features/loan/update_emi/domain/usecases/submit_emi_update_usecase.dart';
import '../../features/loan/update_emi/presentation/bloc/update_emi_bloc.dart';
import '../../features/lockit/auth/data/datasource/auth_remote_datasource.dart';
import '../../features/lockit/auth/data/repositories/auth_repository_impl.dart';
import '../../features/lockit/auth/domain/repositories/auth_repository.dart';
import '../../features/lockit/auth/domain/usecases/kit_verify_otp_usecase.dart';
import '../../features/lockit/auth/domain/usecases/login_usecase.dart';
import '../../features/lockit/auth/domain/usecases/send_otp_usecase.dart';
import '../../features/lockit/auth/domain/usecases/signup_usecase.dart';
import '../../features/lockit/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/lockit/auth/presentation/Login/bloc/login_bloc.dart';
import '../../features/lockit/auth/presentation/signup/bloc/signup_bloc.dart';
import '../../features/lockit/auth/presentation/verifyotp/bloc/otp_bloc.dart';
import '../../features/lockit/create_customer/data/datasources/customer_remote_datasource.dart';
import '../../features/lockit/create_customer/data/repositories/customer_repository_impl.dart';
import '../../features/lockit/create_customer/domain/repositories/customer_repository.dart';
import '../../features/lockit/create_customer/domain/usecases/manage_customer_usecase.dart';
import '../../features/lockit/create_customer/domain/usecases/verify_customer_usecase.dart';
import '../../features/lockit/create_customer/presentation/bloc/customer_bloc.dart';
import '../../features/lockit/customer_detail/data/datasources/customer_detail_remote_data_source.dart';
import '../../features/lockit/customer_detail/data/repositories/customer_detail_repository_impl.dart';
import '../../features/lockit/customer_detail/domain/repositories/customer_detail_repository.dart';
import '../../features/lockit/customer_detail/domain/usecases/get_app_master_usecase.dart';
import '../../features/lockit/customer_detail/domain/usecases/get_customer_detail_usecase.dart';
import '../../features/lockit/customer_detail/presentation/bloc/customer_detail_bloc.dart';
import '../../features/lockit/customer_list/data/datasources/customer_list_remote_data_source.dart';
import '../../features/lockit/customer_list/data/repositories/customer_list_repository_impl.dart';
import '../../features/lockit/customer_list/domain/repositories/customer_list_repository.dart';
import '../../features/lockit/customer_list/domain/usecases/get_customer_list_usecase.dart';
import '../../features/lockit/customer_list/presentation/bloc/customer_list_bloc.dart';
import '../../features/lockit/device_list/data/datasources/device_remote_datasource.dart';
import '../../features/lockit/device_list/data/repositories/device_repository_impl.dart';
import '../../features/lockit/device_list/domain/repositories/device_repository.dart';
import '../../features/lockit/device_list/domain/usecases/get_devices_usecase.dart';
import '../../features/lockit/device_list/presentation/bloc/device_bloc.dart';
import '../../features/lockit/history/data/datasources/history_local_data_source.dart';
import '../../features/lockit/history/data/repositories/history_repository_impl.dart';
import '../../features/lockit/history/domain/repositories/history_repository.dart';
import '../../features/lockit/history/domain/usecases/get_history_invoices.dart';
import '../../features/lockit/history/presentation/bloc/history_bloc.dart';
import '../../features/lockit/home/data/datasources/home_remote_datasource.dart';
import '../../features/lockit/home/data/repositories/home_repository_impl.dart';
import '../../features/lockit/home/domain/repositories/home_repository.dart';
import '../../features/lockit/home/domain/usecases/get_home_data_usecase.dart';
import '../../features/lockit/home/presentation/bloc/home_bloc.dart';
import '../../features/lockit/inventory/data/datasources/inventory_data_source.dart';
import '../../features/lockit/inventory/data/repositories/inventory_repository_impl.dart';
import '../../features/lockit/inventory/domain/repositories/inventory_repository.dart';
import '../../features/lockit/inventory/domain/usecaes/get_inventory_usecase.dart';
import '../../features/lockit/inventory/presentation/bloc/inventory_bloc.dart';
import '../../features/lockit/notification/data/datasources/notification_remote_data_source.dart';
import '../../features/lockit/notification/data/repositories/notification_repository_impl.dart';
import '../../features/lockit/notification/domain/repositories/notification_repository.dart';
import '../../features/lockit/notification/domain/usecaes/get_notifications_usecase.dart';
import '../../features/lockit/notification/presentation/bloc/notification_bloc.dart';
import '../../features/lockit/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/lockit/profile/data/repositories/profile_repository_impl.dart';
import '../../features/lockit/profile/domain/repositories/profile_repository.dart';
import '../../features/lockit/profile/domain/usecaes/get_profile_usecase.dart';
import '../../features/lockit/profile/presentation/bloc/profile_bloc.dart';
import '../../features/lockit/qr_code/data/datasources/qr_remote_data_source.dart';
import '../../features/lockit/qr_code/data/repositories/qr_repository_impl.dart';
import '../../features/lockit/qr_code/domain/repositories/qr_repository.dart';
import '../../features/lockit/qr_code/domain/usecases/get_qr_data_usecase.dart';
import '../../features/lockit/qr_code/presentation/bloc/qr_bloc.dart';
import '../../features/lockit/splash/presentation/bloc/splash_bloc.dart';
import '../../features/lockit/support_screen/data/datasources/support_remote_data_source.dart';
import '../../features/lockit/support_screen/data/repositories/support_repository_impl.dart';
import '../../features/lockit/support_screen/domain/repositories/support_repository.dart';
import '../../features/lockit/support_screen/domain/usecaes/get_support_data.dart';
import '../../features/lockit/support_screen/presentation/bloc/support_bloc.dart';

import '../../features/loan/loan_home_page/data/datasources/loan_home_remote_datasource.dart';
import '../../features/loan/loan_home_page/data/repositories/loan_home_repository_impl.dart';
import '../../features/loan/loan_home_page/domain/repositories/loan_home_repository.dart';
import '../../features/loan/loan_home_page/domain/usecases/loan_get_home_data_usecase.dart';
import '../../features/loan/loan_home_page/presentation/bloc/loan_home_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton<http.Client>(() => http.Client());
  }

  sl.registerFactory(() => SplashBloc());

  sl.registerLazySingleton<AuthRemoteDatasource>(() =>
      AuthRemoteDatasourceImpl());
  sl.registerLazySingleton<AuthRepository>(() =>
      AuthRepositoryImpl(datasource: sl()));

  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<SendOtpUseCase>(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton<SignupUseCase>(() => SignupUseCase(sl()));
  sl.registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton<KitVerifyOtpUseCase>(() => KitVerifyOtpUseCase(sl()));

  sl.registerFactory(() => LoginBloc(loginUseCase: sl(), sendOtpUseCase: sl()));
  sl.registerFactory(() =>
      SignupBloc(signupUseCase: sl(),
          sendOtpUseCase: sl(),
          authRemoteDatasource: sl()));

  sl.registerFactory(() =>
      OtpBloc(
        verifyOtpUseCase: sl(),
        kitVerifyOtpUseCase: sl(),
        sendOtpUseCase: sl(),
      ));

  sl.registerLazySingleton<HomeRemoteDataSource>(() =>
      HomeRemoteDataSourceImpl());

  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton<GetHomeDataUseCase>(() => GetHomeDataUseCase(sl()));
  sl.registerFactory(() => HomeBloc(getHomeDataUseCase: sl()));

  sl.registerLazySingleton<CustomerRemoteDataSource>(
        () => CustomerRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<CustomerRepository>(
        () => CustomerRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<VerifyCustomerUseCase>(
        () => VerifyCustomerUseCase(sl()),
  );
  sl.registerLazySingleton<ManageCustomerUseCase>(
        () => ManageCustomerUseCase(sl()),
  );
  sl.registerFactory(
        () => CustomerBloc(
      verifyCustomerUseCase: sl(),
      manageCustomerUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<CustomerListRemoteDataSource>(
        () => CustomerListRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<CustomerListRepository>(
        () => CustomerListRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GetCustomerListUseCase>(
        () => GetCustomerListUseCase(sl()),
  );
  sl.registerFactory(
        () => CustomerListBloc(
      getCustomerListUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<CustomerDetailRemoteDataSource>(
        () => CustomerDetailRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<CustomerDetailRepository>(
        () => CustomerDetailRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GetCustomerDetailUseCase>(
        () => GetCustomerDetailUseCase(sl()),
  );
  sl.registerLazySingleton<GetAppMasterUseCase>(
        () => GetAppMasterUseCase(sl()),
  );

  sl.registerFactory(
        () => CustomerDetailBloc(
      getCustomerDetailUseCase: sl(),
      getAppMasterUseCase: sl(),
      remoteDataSource: sl<CustomerDetailRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<DeviceRemoteDataSource>(
        () => DeviceRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<DeviceRepository>(
        () => DeviceRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GetDevicesUseCase>(
        () => GetDevicesUseCase(sl()),
  );
  sl.registerFactory(
        () => DeviceBloc(
      getDevicesUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<HistoryLocalDataSource>(
        () => HistoryLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<HistoryRepository>(
        () => HistoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetHistoryInvoices>(
        () => GetHistoryInvoices(sl()),
  );
  sl.registerFactory(
        () => HistoryBloc(
      getHistoryInvoices: sl(),
    ),
  );

  sl.registerLazySingleton<InventoryDataSource>(
        () => InventoryRemoteDataSource(client: sl()),
  );
  sl.registerLazySingleton<InventoryRepository>(
        () => InventoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetInventoryUseCase>(
        () => GetInventoryUseCase(sl()),
  );

  sl.registerFactory(
        () => InventoryBloc(
      sl(),
    ),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GetProfileUseCase>(
        () => GetProfileUseCase(sl()),
  );
  sl.registerFactory(
        () => ProfileBloc(
      getProfileUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<NotificationRemoteDataSource>(
        () => NotificationRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<NotificationRepository>(
        () => NotificationRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GetNotificationsUseCase>(
        () => GetNotificationsUseCase(sl()),
  );
  sl.registerFactory(
        () => NotificationBloc(
      getNotificationsUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<QrRemoteDataSource>(
        () => QrRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<QrRepository>(
        () => QrRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<GetQrDataUseCase>(
        () => GetQrDataUseCase(sl()),
  );

  sl.registerFactory(
        () => QrBloc(
      getQrDataUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<SupportRemoteDataSource>(
        () => SupportRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<SupportRepository>(
        () => SupportRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetSupportData>(
        () => GetSupportData(sl()),
  );
  sl.registerFactory<SupportBloc>(
        () => SupportBloc(getSupportData: sl()),
  );

  sl.registerLazySingleton<LoanHomeRemoteDataSource>(
        () => LoanHomeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<LoanHomeRepository>(
        () => LoanHomeRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetLoanHomeDataUseCase>(
        () => GetLoanHomeDataUseCase(sl()),
  );
  sl.registerFactory(
        () => LoanHomeBloc(getHomeDataUseCase: sl()),
  );

  sl.registerLazySingleton<LoanCustomerRemoteDataSource>(
        () => LoanCustomerRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<LoanCustomerRepository>(
        () => LoanCustomerRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetLoanCustomersUseCase>(
        () => GetLoanCustomersUseCase(sl()),
  );
  sl.registerFactory(
        () => LoanCustomerBloc(sl()),
  );

  sl.registerLazySingleton<LoanReportRemoteDataSource>(
        () => LoanReportRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<LoanReportRepository>(
        () => LoanReportRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetLoanReportsUseCase>(
        () => GetLoanReportsUseCase(sl()),
  );
  sl.registerFactory(
        () => LoanReportBloc(sl()),
  );


  sl.registerLazySingleton<new_datasource.CustomerRemoteDataSource>(
        () => new_datasource.CustomerRemoteDataSourceImpl(
      client: sl<http.Client>(),
    ),
  );

  sl.registerLazySingleton<new_repo_interface.CustomerRepository>(
        () => new_repo.CustomerRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<new_usecase.GetCustomerDetailUseCase>(
        () => new_usecase.GetCustomerDetailUseCase(sl()),
  );
  sl.registerFactory(
        () => new_bloc.CustomerBloc(getCustomerDetailUseCase: sl()),
  );

  sl.registerLazySingleton<UpdateEmiRemoteDataSource>(
        () => UpdateEmiRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<UpdateEmiRepository>(
        () => UpdateEmiRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<UpdateEmiUseCase>(
        () => UpdateEmiUseCase(sl()),
  );
  sl.registerFactory(
        () => UpdateEmiBloc(sl()),
  );


  sl.registerLazySingleton<CreateLoanRemoteDataSource>(
        () => CreateLoanRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<CreateLoanRepository>(
        () => CreateLoanRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<SubmitDocumentsUseCase>(
        () => SubmitDocumentsUseCase(sl()),
  );

  sl.registerLazySingleton<VerifyPanUseCase>(
        () => VerifyPanUseCase(sl()),
  );

  sl.registerLazySingleton<VerifyAadhaarUseCase>(
        () => VerifyAadhaarUseCase(sl()),
  );

  sl.registerLazySingleton<GetCreditReportUseCase>(
        () => GetCreditReportUseCase(sl()),
  );

  sl.registerLazySingleton(
        () => CheckLoanReapplyEligibilityUseCase(sl()),
  );

  sl.registerFactory(
        () => CreateLoanBloc(
      submitDocumentsUseCase: sl(),
      verifyPanUseCase: sl(),
      verifyAadhaarUseCase: sl(),
      getCreditReportUseCase: sl(),
      checkLoanReapplyEligibilityUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<BasicDetailsRemoteDataSource>(
        () => BasicDetailsRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<BasicDetailsRepository>(
        () => BasicDetailsRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<SubmitBasicDetailsUseCase>(
        () => SubmitBasicDetailsUseCase(sl()),
  );

  sl.registerFactory(
        () => BasicDetailsBloc(
      submitBasicDetailsUseCase: sl(),
      repository: sl(),
    ),
  );


  sl.registerLazySingleton<LoanDetailRemoteDataSource>(
        () => LoanDetailRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<LoanDetailRepository>(
        () => LoanDetailRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<SubmitLoanDetailUseCase>(
        () => SubmitLoanDetailUseCase(sl()),
  );

  sl.registerFactory(
        () => LoanDetailBloc(
      sl(),
    ),
  );

  sl.registerLazySingleton<BankDetailRemoteDataSource>(
        () => BankDetailRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<BankDetailRepository>(
        () => BankDetailRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<SubmitBankDetailUseCase>(
        () => SubmitBankDetailUseCase(sl()),
  );

  sl.registerLazySingleton<GetBankListUseCase>(
        () => GetBankListUseCase(sl()),
  );

  sl.registerLazySingleton<SetupAutoUpiUseCase>(
        () => SetupAutoUpiUseCase(sl()),
  );

  sl.registerFactory(
        () => BankDetailBloc(
      submitBankDetailUseCase: sl(),
      getBankListUseCase: sl(),
      setupAutoUpiUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<EmandateRemoteDataSource>(
        () => EmandateRemoteDataSourceImpl(client: sl<http.Client>()),
  );

  sl.registerLazySingleton<EmandateRepository>(
        () => EmandateRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<SubmitEmandateUseCase>(
        () => SubmitEmandateUseCase(sl()),
  );

  sl.registerFactory(
        () => EmandateBloc(sl()),
  );

  sl.registerLazySingleton<ReferenceRemoteDataSource>(
        () => ReferenceRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ReferenceRepository>(
        () => ReferenceRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<SubmitReferenceUseCase>(
        () => SubmitReferenceUseCase(sl()),
  );

  sl.registerFactory(
        () => ReferenceBloc(sl()),
  );

  sl.registerLazySingleton<LoanDisbursedRemoteDataSource>(
        () => LoanDisbursedRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<LoanDisbursedRepository>(
        () => LoanDisbursedRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<UpdateLoanDisbursedUseCase>(
        () => UpdateLoanDisbursedUseCase(sl()),
  );

  sl.registerFactory(
        () => LoanDisbursedBloc(sl()),
  );

  sl.registerLazySingleton<TermsConditionRemoteDatasource>(
        () => TermsConditionRemoteDatasourceImpl(),
  );

  sl.registerLazySingleton<TermsConditionRepository>(
        () => TermsConditionRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<AcceptTermsUsecase>(
        () => AcceptTermsUsecase(sl()),
  );

  sl.registerFactory(
        () => TermsBloc(sl()),
  );

  sl.registerLazySingleton<LoanHistoryRemoteDatasource>(
        () => LoanHistoryRemoteDatasourceImpl(client: sl()),
  );
  sl.registerLazySingleton<LoanHistoryRepository>(
        () => LoanHistoryRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<GetLoanPortfolioUsecase>(
        () => GetLoanPortfolioUsecase(sl()),
  );
  sl.registerFactory(
        () => LoanHistoryBloc(getLoanPortfolioUsecase: sl()),
  );

  sl.registerLazySingleton<EnachRequestLocalDataSource>(
        () => EnachRequestLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<EnachRequestRepository>(
        () => EnachRequestRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<GetEnachRequestsUsecase>(
        () => GetEnachRequestsUsecase(sl()),
  );

  sl.registerFactory(
        () => EnachRequestBloc(sl()),
  );

  sl.registerLazySingleton<EnachReviewRemoteDataSource>(
        () => EnachReviewRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<EnachReviewRepository>(
        () => EnachReviewRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<UpdateEnachStatusUsecase>(
        () => UpdateEnachStatusUsecase(sl()),
  );

  sl.registerFactory(
        () => EnachReviewBloc(updateEnachStatusUsecase: sl()),
  );
}