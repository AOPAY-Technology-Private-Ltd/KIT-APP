import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/auth/data/datasource/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/send_otp_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';

import '../../features/auth/presentation/Login/bloc/login_bloc.dart';
import '../../features/auth/presentation/signup/bloc/signup_bloc.dart';
import '../../features/auth/presentation/verifyotp/bloc/otp_bloc.dart';

import '../../features/device_list/data/datasources/device_remote_datasource.dart';
import '../../features/device_list/data/repositories/device_repository_impl.dart';
import '../../features/device_list/domain/repositories/device_repository.dart';
import '../../features/device_list/domain/usecases/get_devices_usecase.dart';
import '../../features/device_list/presentation/bloc/device_bloc.dart';
import '../../features/splash/presentation/bloc/splash_bloc.dart';

import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_data_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

import '../../features/create_customer/data/datasources/customer_remote_datasource.dart';
import '../../features/create_customer/data/repositories/customer_repository_impl.dart';
import '../../features/create_customer/domain/repositories/customer_repository.dart';
import '../../features/create_customer/domain/usecases/verify_customer_usecase.dart';
import '../../features/create_customer/domain/usecases/manage_customer_usecase.dart';
import '../../features/create_customer/presentation/bloc/customer_bloc.dart';

import '../../features/customer_list/data/datasources/customer_list_remote_data_source.dart';
import '../../features/customer_list/data/repositories/customer_list_repository_impl.dart';
import '../../features/customer_list/domain/repositories/customer_list_repository.dart';
import '../../features/customer_list/domain/usecases/get_customer_list_usecase.dart';
import '../../features/customer_list/presentation/bloc/customer_list_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton<http.Client>(() => http.Client());
  }

  sl.registerFactory(() => SplashBloc());

  sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(datasource: sl()));
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<SendOtpUseCase>(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton<SignupUseCase>(() => SignupUseCase(sl()));
  sl.registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(sl()));

  sl.registerFactory(() => LoginBloc(loginUseCase: sl(), sendOtpUseCase: sl()));
  sl.registerFactory(() => SignupBloc(signupUseCase: sl(), sendOtpUseCase: sl(), authRemoteDatasource: sl()));
  sl.registerFactory(() => OtpBloc(verifyOtpUseCase: sl(), sendOtpUseCase: sl()));

  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl());
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
}