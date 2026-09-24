import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/routes/route_names.dart';
import '../../../../../core/di/injection.dart';
import '../../../create_customer/presentation/widgets/custom_header.dart';
import '../bloc/qr_bloc.dart';
import '../bloc/qr_event.dart';
import '../bloc/qr_state.dart';
import '../widgets/qr_card_widget.dart';

class QrCodeView extends StatelessWidget {
  const QrCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrBloc(getQrDataUseCase: sl())..add(LoadQrDataEvent()),
      child: const _QrCodeViewContent(),
    );
  }
}

class _QrCodeViewContent extends StatelessWidget {
  const _QrCodeViewContent();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: CustomHeader(
                  title: 'QR Code',
                  onBackPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                  onNotificationTap: () => context.push(RouteNames.notification),
                  onSearchTap: () {},
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: BlocBuilder<QrBloc, QrState>(
                    builder: (context, state) {
                      if (state is QrLoadingState) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 100.0),
                            child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                          ),
                        );
                      } else if (state is QrLoadedState) {
                        return QrCardWidget(
                          userName: state.user.userName,
                          qrData: state.user.qrData,
                          onNextQrTap: () {
                            context.read<QrBloc>().add(NextQrTappedEvent());
                          },
                        );
                      } else if (state is QrErrorState) {
                        return Center(
                          child: Text(state.message, style: const TextStyle(color: Colors.red)),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Container(
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(1.00, 0.50),
                        end: Alignment(0.00, 0.50),
                        colors: [Color(0xFF022062), Color(0xFF008EFD)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        context.push(RouteNames.tokenValidation);
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}