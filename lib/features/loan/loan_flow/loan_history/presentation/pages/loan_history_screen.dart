import 'package:flutter/material.dart';
import '../widgtes/LoanHistoryCard.dart';

class LoanHistoryScreen extends StatefulWidget {
  const LoanHistoryScreen({super.key});

  @override
  State<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends State<LoanHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String selectedStatus = 'All';
  String selectedSort = 'Newest First';

  final List<Map<String, String>> _allLoans = [
    {'name': 'Aarav Sharma', 'status': 'Active', 'amount': '₹1,20,000', 'tenure': '12 Months', 'date': '12 Oct 2023'},
    {'name': 'Priya Patel', 'status': 'Active', 'amount': '₹85,000', 'tenure': '9 Months', 'date': '05 Nov 2023'},
    {'name': 'Rajesh Kumar', 'status': 'Closed', 'amount': '₹1,50,000', 'tenure': '18 Months', 'date': '20 Jan 2023'},
    {'name': 'Ananya Iyer', 'status': 'Closed', 'amount': '₹50,000', 'tenure': '6 Months', 'date': '15 May 2023'},
    {'name': 'Vikram Singh', 'status': 'Disbursed', 'amount': '₹95,000', 'tenure': '12 Months', 'date': '01 Dec 2023'},
    {'name': 'Meera Nair', 'status': 'Active', 'amount': '₹2,00,000', 'tenure': '24 Months', 'date': '18 Aug 2023'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _getFilteredAndSortedLoans() {
    List<Map<String, String>> filtered = _allLoans.where((loan) {
      final matchesStatus = selectedStatus == 'All' ||
          loan['status']!.toLowerCase() == selectedStatus.toLowerCase();

      final matchesSearch = _searchQuery.isEmpty ||
          loan['name']!.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesStatus && matchesSearch;
    }).toList();

    filtered.sort((a, b) {
      if (selectedSort == 'Newest First') {
        return b['date']!.compareTo(a['date']!);
      } else {
        return a['date']!.compareTo(b['date']!);
      }
    });

    return filtered;
  }

  void _showEcommerceFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                constraints: const BoxConstraints(maxHeight: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Filters',
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20, color: Color(0xFF6B7280)),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),

                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'LOAN STATUS',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 11,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...['All', 'Active', 'Closed', 'Disbursed'].map((status) {
                              return InkWell(
                                onTap: () {
                                  setDialogState(() {
                                    selectedStatus = status;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Radio<String>(
                                          value: status,
                                          groupValue: selectedStatus,
                                          activeColor: const Color(0xFF2563EB),
                                          onChanged: (value) {
                                            setDialogState(() {
                                              selectedStatus = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        status,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          color: Color(0xFF374151),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 16),
                            const Divider(color: Color(0xFFE5E7EB)),
                            const SizedBox(height: 16),

                            const Text(
                              'SORT BY',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 11,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...['Newest First', 'Oldest First'].map((sort) {
                              return InkWell(
                                onTap: () {
                                  setDialogState(() {
                                    selectedSort = sort;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Radio<String>(
                                          value: sort,
                                          groupValue: selectedSort,
                                          activeColor: const Color(0xFF2563EB),
                                          onChanged: (value) {
                                            setDialogState(() {
                                              selectedSort = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        sort,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          color: Color(0xFF374151),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFD1D5DB)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () {
                                setDialogState(() {
                                  selectedStatus = 'All';
                                  selectedSort = 'Newest First';
                                });
                              },
                              child: const Text(
                                'Clear All',
                                style: TextStyle(
                                  color: Color(0xFF374151),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                              ),
                              onPressed: () {
                                setState(() {
                                });
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Apply',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loanList = _getFilteredAndSortedLoans();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.50, -0.00),
                end: Alignment(0.50, 1.00),
                colors: [Color(0xFF2563EB), Color(0xFF002576)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 13, 16, 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, size: 12, color: Color(0xFF2563EB)),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(0.00, 0.00),
                          end: Alignment(1.00, 1.00),
                          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Disbursed Portfolio',
                                style: TextStyle(
                                  color: Color(0xFFE0F2FE),
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${loanList.length} Loans',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '₹7,00,000',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Disbursed to date across 30 entries',
                            style: TextStyle(
                              color: Color(0xFF93C5FD),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search payments...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: Color(0xFF9CA3AF)),
                          onPressed: () => _searchController.clear(),
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.white, size: 20),
                    onPressed: () => _showEcommerceFilterDialog(context),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: loanList.isEmpty
                ? const Center(
              child: Text(
                'No loan history found',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
              ),
            )
                : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              children: [
                const Text(
                  'RECENT DISBURSALS',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                ...loanList.map((loan) => LoanHistoryCard(
                  name: loan['name']!,
                  status: loan['status']!,
                  disbursedAmount: loan['amount']!,
                  tenure: loan['tenure']!,
                  disbursalDate: loan['date']!,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}