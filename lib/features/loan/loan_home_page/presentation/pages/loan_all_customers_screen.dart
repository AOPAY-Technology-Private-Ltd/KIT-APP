import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../../../core/helper/api_client.dart';
import '../../../../../core/services/session_manager.dart';
import '../../../../lockit/create_customer/presentation/widgets/custom_header.dart';

class LoanAllCustomersScreen extends StatefulWidget {
  const LoanAllCustomersScreen({super.key});

  @override
  State<LoanAllCustomersScreen> createState() => _LoanAllCustomersScreenState();
}

class _LoanAllCustomersScreenState extends State<LoanAllCustomersScreen> {
  late Future<List<dynamic>> _futureCustomers;
  List<dynamic> _allCustomers = [];
  List<dynamic> _filteredCustomers = [];
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  void _loadCustomers() {
    setState(() {
      _futureCustomers = _fetchAllCustomers();
    });
  }

  Future<List<dynamic>> _fetchAllCustomers() async {
    try {
      final clientCode = await SessionManager.getClientCode() ?? "CMP0005";
      final retailerCode = await SessionManager.getRetailerCode();

      const urlString = 'https://uatapi.aopay.co.in/api/V1/AopayFinance/AppLoan/GetRetailerDashboard';
      final uri = Uri.parse(urlString);

      final requestBody = jsonEncode({
        "ClientCode": clientCode,
        "RetailerCode": retailerCode ?? "",
        "RecentCount": 0
      });

      final response = await ApiClient.post(
        uri,
        headers: {'accept': '*/*', 'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final rawStatus = decoded['success'] ?? decoded['status'];
        bool isSuccess = rawStatus == true || rawStatus.toString().toLowerCase() == 'true';

        if (isSuccess || decoded['code'] == 200) {
          final data = decoded['data'];
          final Map<String, dynamic> dataMap = data is Map<String, dynamic> ? data : {};

          final rawCustomers = dataMap['recentCustomers'];
          if (rawCustomers is List) {
            _allCustomers = rawCustomers;
            _filteredCustomers = _allCustomers;
            return _allCustomers;
          }
        }
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching all customers: $e");
      rethrow;
    }
  }

  void _filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCustomers = _allCustomers;
      } else {
        _filteredCustomers = _allCustomers.where((c) {
          final name = (c['customerName'] ?? '').toString().toLowerCase();
          final mobile = (c['primaryMobileNumber'] ?? c['mobileNo'] ?? '').toString().toLowerCase();
          final code = (c['customerCode'] ?? '').toString().toLowerCase();
          final loanCode = (c['loanCode'] ?? '').toString().toLowerCase();

          return name.contains(query.toLowerCase()) ||
              mobile.contains(query.toLowerCase()) ||
              code.contains(query.toLowerCase()) ||
              loanCode.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomHeader(
                title: 'All Customers',
                showSearch: true,
                showNotification: false,
                onSearchTap: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchController.clear();
                      _filterSearch('');
                    }
                  });
                },
              ),
            ),
            if (_isSearching)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: _filterSearch,
                  decoration: InputDecoration(
                    hintText: 'Search by Name, Mobile, Code or Loan ID...',
                    hintStyle: const TextStyle(fontSize: 13, color: Colors.grey, fontFamily: 'Inter'),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF2563EB)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _filterSearch('');
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _futureCustomers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                    );
                  } else if (snapshot.hasError) {
                    final errorMessage = snapshot.error.toString().replaceAll("Exception: ", "");
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.redAccent),
                            const SizedBox(height: 12),
                            Text(
                              errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _loadCustomers,
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Retry', style: TextStyle(fontFamily: 'Inter')),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (_filteredCustomers.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No Customers Found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? 'No results match "${_searchController.text}". Try searching with a different keyword.'
                                  : 'There are no customers registered yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            if (_searchController.text.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _filterSearch('');
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(Icons.refresh, size: 16),
                                label: const Text(
                                  'Clear Search',
                                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = _filteredCustomers[index];
                      final customerName = (customer['customerName'] ?? '').toString().trim();
                      final displayName = customerName.isEmpty ? 'Unknown Customer' : customerName;
                      final mobileNo = customer['primaryMobileNumber'] ?? customer['mobileNo'] ?? '';
                      final customerCode = customer['customerCode'] ?? '';
                      final loanCode = customer['loanCode'] ?? '';
                      final loanAmount = customer['loanAmount']?.toString() ?? '0';
                      final activityDate = customer['activityDate'] ?? customer['createdDate'] ?? '';

                      String initials = "C";
                      final nameParts = displayName.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
                      if (nameParts.isNotEmpty) {
                        initials = nameParts.first[0].toUpperCase();
                        if (nameParts.length > 1) {
                          initials += nameParts[1][0].toUpperCase();
                        }
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: const Color(0xFF133682),
                                  child: Text(
                                    initials,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        mobileNo.isNotEmpty ? "Mobile: $mobileNo" : "Customer ID: $customerCode",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    loanCode.isNotEmpty ? loanCode : customerCode,
                                    style: const TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20, thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Loan Amount: ₹$loanAmount",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                Text(
                                  activityDate.toString().isNotEmpty
                                      ? activityDate.toString().split('T').first
                                      : '',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 11,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}