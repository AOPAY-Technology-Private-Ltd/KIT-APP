import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/support_bloc.dart';
import '../bloc/support_event.dart';
import '../bloc/support_state.dart';
import '../widgets/support_widgets.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<SupportBloc>().add(LoadSupportDataEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanPhone');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch WhatsApp');
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Inquiry&body=Hi Support Team,',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Help & FAQs',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<SupportBloc, SupportState>(
        builder: (context, state) {
          if (state is SupportLoading || state is SupportInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            );
          } else if (state is SupportError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          } else if (state is SupportLoaded) {
            final supportInfo = state.supportInfo;
            final allFaqs = state.faqs;

            final filteredFaqs = allFaqs.where((faq) {
              final query = _searchQuery.toLowerCase();
              return faq.question.toLowerCase().contains(query) ||
                  faq.answer.toLowerCase().contains(query);
            }).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'What can we help you with?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Search our FAQs or get in touch with support instantly.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          style: const TextStyle(fontSize: 13, fontFamily: 'Inter', color: Colors.black87),
                          decoration: InputDecoration(
                            hintText: 'Search for questions (e.g., login, password...)',
                            hintStyle: const TextStyle(fontSize: 12, color: Colors.black45),
                            prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                              icon: const Icon(Icons.clear, size: 18, color: Colors.black54),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                                : null,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Contact Support',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SupportCard(
                          icon: Icons.phone_in_talk_rounded,
                          title: 'Call Support',
                          subtitle: supportInfo.phone,
                          color: Colors.green,
                          onTap: () => _makePhoneCall(supportInfo.phone),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SupportCard(
                          icon: Icons.chat_bubble_rounded,
                          title: 'WhatsApp',
                          subtitle: supportInfo.whatsapp,
                          color: Colors.teal,
                          onTap: () => _openWhatsApp(supportInfo.whatsapp),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SupportCard(
                    icon: Icons.email_rounded,
                    title: 'Email Support',
                    subtitle: supportInfo.email,
                    color: const Color(0xFF2563EB),
                    onTap: () => _sendEmail(supportInfo.email),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Frequently Asked Questions',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        Text(
                          '${filteredFaqs.length} found',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontFamily: 'Inter',
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  filteredFaqs.isEmpty
                      ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'No matching questions found.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredFaqs.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF1F5F9),
                        ),
                        itemBuilder: (context, index) {
                          final faq = filteredFaqs[index];
                          return FaqItem(
                            question: faq.question,
                            answer: faq.answer,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}