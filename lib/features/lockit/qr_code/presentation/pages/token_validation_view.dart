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

class TokenValidationView extends StatelessWidget {
  const TokenValidationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      QrBloc(getQrDataUseCase: sl())..add(LoadQrDataEvent()),
      child: const _TokenValidationViewContent(),
    );
  }
}

class _TokenValidationViewContent extends StatefulWidget {
  const _TokenValidationViewContent();

  @override
  State<_TokenValidationViewContent> createState() =>
      _TokenValidationViewContentState();
}

class _TokenValidationViewContentState
    extends State<_TokenValidationViewContent> {
  final TextEditingController _tokenController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QrBloc, QrState>(
      listener: (context, state) {

        if (state is QrLoadedState &&
            _tokenController.text.trim().isNotEmpty) {
          context.go(RouteNames.installSuccess);
        }


        if (state is QrErrorState) {
          setState(() {
            _errorMessage = state.message;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: CustomHeader(
                  title: 'QR Code',
                  onNotificationTap: () {},
                  onSearchTap: () {},
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<QrBloc, QrState>(
                        builder: (context, state) {
                          if (state is QrLoadingState) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 40.0,
                                ),
                                child: CircularProgressIndicator(
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            );
                          } else if (state is QrLoadedState) {
                            return QrCardWidget(
                              userName: state.user.userName,
                              qrData: state.user.qrData,
                              onNextQrTap: () {
                                context.read<QrBloc>().add(
                                  NextQrTappedEvent(),
                                );
                              },
                            );
                          } else if (state is QrErrorState) {
                            return Center(
                              child: Text(
                                state.message,
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Enter Customer Access Token',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 48,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: _errorMessage != null
                                  ? Colors.red
                                  : Colors.black.withValues(alpha: 0.20),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: TextField(
                          controller: _tokenController,
                          onChanged: (value) {
                            if (_errorMessage != null &&
                                value.trim().isNotEmpty) {
                              setState(() {
                                _errorMessage = null;
                              });
                            }
                          },
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter access Token Key',
                            hintStyle: TextStyle(
                              color: Colors.black.withValues(alpha: 0.30),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
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
                        colors: [
                          Color(0xFF022062),
                          Color(0xFF008EFD),
                        ],
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
                        setState(() {
                          if (_tokenController.text.trim().isEmpty) {
                            _errorMessage =
                            'Access token key is required';
                          } else {
                            _errorMessage = null;

                            context.read<QrBloc>().add(
                              ValidateApiKeyEvent(
                                apiKey: _tokenController.text.trim(),
                              ),
                            );
                          }
                        });
                      },
                      child: const Text(
                        'Validate',
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