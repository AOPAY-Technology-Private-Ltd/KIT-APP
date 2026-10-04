import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../../core/di/injection.dart';
import '../../data/datasources/create_loan_remote_data_source.dart';

class AadhaarWebViewScreen extends StatefulWidget {
  final String kycUrl;
  final String? transactionId;

  const AadhaarWebViewScreen({
    super.key,
    required this.kycUrl,
    this.transactionId,
  });

  @override
  State<AadhaarWebViewScreen> createState() => _AadhaarWebViewScreenState();
}

class _AadhaarWebViewScreenState extends State<AadhaarWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            print('Current WebView URL: $url');
          },
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url.toLowerCase();

            if (url.contains('success') || url.contains('close') || url.contains('complete') || url.contains('code=')) {

              if (widget.transactionId != null && widget.transactionId!.isNotEmpty) {
                try {
                  print('=== Fetching Aadhaar Transaction Details ===');
                  final remoteDataSource = sl<CreateLoanRemoteDataSource>();
                  final response = await remoteDataSource.fetchAadhaarTransaction(widget.transactionId!);
                  print('Transaction API Response: $response');
                } catch (e) {
                  print('Error fetching transaction: $e');
                }
              }

              if (mounted) {
                Navigator.pop(context, true);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.kycUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF022062),
        title: const Text(
          'Aadhaar KYC Verification',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF022062),
                ),
              ),
          ],
        ),
      ),
    );
  }
}