import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasource/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';

import '../../features/auth/domain/usecases/send_otp_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';

import '../../features/auth/presentation/Login/bloc/login_bloc.dart';
import '../../features/auth/presentation/signup/bloc/signup_bloc.dart';

import '../../features/splash/presentation/bloc/splash_bloc.dart';

import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_data_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerFactory(
        () => SplashBloc(),
  );

  sl.registerLazySingleton<AuthRemoteDatasource>(
        () => AuthRemoteDatasourceImpl(),
  );

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      datasource: sl(),
    ),
  );


  sl.registerLazySingleton<SendOtpUseCase>(
        () => SendOtpUseCase(
      sl(),
    ),
  );

  sl.registerLazySingleton<SignupUseCase>(
        () => SignupUseCase(
      sl(),
    ),
  );

  sl.registerFactory(
        () => LoginBloc(
      sendOtpUseCase: sl(),
    ),
  );

  sl.registerFactory(
        () => SignupBloc(
      signupUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(
      sl(),
    ),
  );

  sl.registerLazySingleton<GetHomeDataUseCase>(
        () => GetHomeDataUseCase(
      sl(),
    ),
  );

  sl.registerFactory(
        () => HomeBloc(
      getHomeDataUseCase: sl(),
    ),
  );

}