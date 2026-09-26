import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF022062),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome to Our Loan Services',
              style: TextStyle(
                color: Color(0xFF022062),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Please read these terms and conditions carefully before proceeding with your loan application. By using our services, you agree to comply with and be bound by the following terms.',
              style: TextStyle(color: Colors.black87, fontSize: 13, fontFamily: 'Inter', height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              '1. Information Accuracy',
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 6),
            Text(
              'All information provided by you during the loan application process must be accurate, complete, and up-to-date. Providing false information may lead to the rejection of your application or legal action.',
              style: TextStyle(color: Colors.black87, fontSize: 13, fontFamily: 'Inter', height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              '2. Privacy and Data Security',
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 6),
            Text(
              'We respect your privacy and protect your personal data in accordance with applicable data protection laws. Your information is used strictly for loan processing and verification purposes.',
              style: TextStyle(color: Colors.black87, fontSize: 13, fontFamily: 'Inter', height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              '3. Credit Assessment',
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 6),
            Text(
              'By accepting these terms, you authorize us and our lending partners to check your credit history, verify your documents, and conduct necessary background checks.',
              style: TextStyle(color: Colors.black87, fontSize: 13, fontFamily: 'Inter', height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}