abstract class CreateLoanState {
  const CreateLoanState();
}



class CreateLoanInitialState extends CreateLoanState {
  const CreateLoanInitialState();
}



class CreateLoanLoadingState extends CreateLoanState {
  const CreateLoanLoadingState();
}



class PanVerifiedState extends CreateLoanState {
  const PanVerifiedState();
}



class AadhaarVerificationUrlReceivedState
    extends CreateLoanState {
  final String kycUrl;
  final String? transactionId;

  const AadhaarVerificationUrlReceivedState({
    required this.kycUrl,
    this.transactionId,
  });
}



class DocumentsSubmittedSuccessState
    extends CreateLoanState {
  const DocumentsSubmittedSuccessState();
}



class CreateLoanErrorState
    extends CreateLoanState {
  final String message;

  const CreateLoanErrorState(
      this.message,
      );
}