import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class VerifyOtpPressed extends OtpEvent {
  final String mobile;
  final String otp;

  const VerifyOtpPressed({
    required this.mobile,
    required this.otp,
  });

  @override
  List<Object?> get props => [
    mobile,
    otp,
  ];
}

class ResendOtpPressed extends OtpEvent {
  final String mobile;

  const ResendOtpPressed({
    required this.mobile,
  });

  @override
  List<Object?> get props => [
    mobile,
  ];
}