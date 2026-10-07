import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AutoUpiWebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const AutoUpiWebViewScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<AutoUpiWebViewScreen> createState() => _AutoUpiWebViewScreenState();
}

class _AutoUpiWebViewScreenState extends State<AutoUpiWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasPopped = false;

  void _handleSuccess() {
    print('🎯 WebView Success detected, popping screen with true');
    if (!_hasPopped && mounted) {
      _hasPopped = true;
      Navigator.pop(context, true);
    }
  }

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
          onPageFinished: (String url) async {
            setState(() => _isLoading = false);
            print('🌐 WebView URL Finished: $url');

            final lowerUrl = url.toLowerCase();

            if (lowerUrl.contains('success') ||
                lowerUrl.contains('complete') ||
                lowerUrl.contains('status=success') ||
                lowerUrl.contains('code=success') ||
                lowerUrl.contains('response=success') ||
                lowerUrl.contains('callback') ||
                lowerUrl.contains('return') ||
                (lowerUrl.contains('transact') && !lowerUrl.contains('pgv3'))) {
              _handleSuccess();
              return;
            }

            try {
              final result = await _controller.runJavaScriptReturningResult(
                "document.body.innerText.includes('Payment successful') || document.body.innerText.includes('Auto-pay set up successfully')",
              );

              if (result.toString().toLowerCase().contains('true')) {
                print('🎯 Success text detected inside WebView DOM!');
                _handleSuccess();
              }
            } catch (e) {
              print('❌ Error checking WebView DOM: $e');
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            print('🔄 Navigating to: ${request.url}');
            final lowerUrl = request.url.toLowerCase();

            if (lowerUrl.contains('success') ||
                lowerUrl.contains('complete') ||
                lowerUrl.contains('status=success') ||
                lowerUrl.contains('code=success') ||
                lowerUrl.contains('callback') ||
                lowerUrl.contains('return')) {
              _handleSuccess();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF022062),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: WebViewWidget(controller: _controller),
                ),

                Container(
                  padding: const EdgeInsets.all(12.0),
                  color: Colors.white,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        _handleSuccess();
                      },
                      child: const Text(
                        'Done / Payment Completed',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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