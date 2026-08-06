import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../data/models/save_purchase_history_request_model.dart';
import '../../domain/usecaes/save_purchase_history_usecase.dart';
import '../pages/payment_success_screen.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String htmlFormContent;
  final SavePurchaseHistoryUseCase savePurchaseHistoryUseCase;
  final SavePurchaseHistoryRequestModel requestModel;

  const PaymentWebViewScreen({
    super.key,
    required this.htmlFormContent,
    required this.savePurchaseHistoryUseCase,
    required this.requestModel,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isSavingHistory = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);

            if (url.contains('PayUCallbk') && !_isSavingHistory) {
              _handlePaymentSuccess(url);
            }
          },
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url;

            if (!url.startsWith('http://') && !url.startsWith('https://')) {
              try {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                  return NavigationDecision.prevent;
                }
              } catch (e) {
                print('Could not launch external app: $e');
              }
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(widget.htmlFormContent);
  }

  Future<void> _handlePaymentSuccess(String callbackUrl) async {
    setState(() {
      _isSavingHistory = true;
    });

    try {
      print('--- TRIGGERING SAVE PURCHASE HISTORY (POST) ---');
      final response = await widget.savePurchaseHistoryUseCase.execute(widget.requestModel);
      print('Save Purchase History Response: $response');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessScreen(
              orderId: widget.requestModel.invoiceNo,
              kitsCount: 50,
              totalPaid: widget.requestModel.netAmount,
              paymentMethod: widget.requestModel.paymentMode,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error saving purchase history: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save history: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSavingHistory = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading || _isSavingHistory)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF008EFD),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}