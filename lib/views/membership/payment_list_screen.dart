import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../myconfig.dart';
import '../shared/mydrawer.dart';
import 'package:mymemberlinks/views/membership/membership_payment.dart';
import 'package:mymemberlinks/model/membership.dart';

class PaymentListScreen extends StatefulWidget {
  const PaymentListScreen({super.key});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> with RouteAware {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  List<Map<String, dynamic>> payments = [];
  String status = "Loading...";
  String? userId;
  String? userEmail;
  String? userName;
  String? userPhone;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Subscribe to route observer
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);

    // Initialize only once
    if (!_isInitialized) {
      _isInitialized = true;
      // Add local history entry
      ModalRoute.of(context)?.addLocalHistoryEntry(
        LocalHistoryEntry(
          onRemove: () {
            loadPayments();
          },
        ),
      );
      // Load payments if userId is already loaded
      if (userId != null) {
        loadPayments();
      }
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    loadPayments();
  }

  Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id');
    });
    // Load payments after userId is loaded
    if (mounted) {
      loadPayments();
    }
  }

  Future<void> loadPayments() async {
    if (userId == null) {
      setState(() {
        status = "Please login to view payments";
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("${MyConfig.servername}/mymemberlink/api/load_payments.php"),
        body: {'user_id': userId},
      );

      print("Load payments response: ${response.body}"); // Debug print

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            payments =
                List<Map<String, dynamic>>.from(data['data']['payments']);
            userEmail = data['data']['user_email'];
            userName = data['data']['user_name'];
            userPhone = data['data']['user_phone'];
          });
        } else {
          setState(() {
            status = "No payments found";
            payments = []; // Clear the payments list
          });
        }
      } else {
        setState(() {
          status = "Failed to load payments";
          payments = []; // Clear the payments list
        });
      }
    } catch (e) {
      setState(() {
        status = "Error: $e";
        payments = []; // Clear the payments list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment History",
          style: GoogleFonts.monoton(color: const Color(0xFFF4F3EE)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF463F3A),
        iconTheme: const IconThemeData(color: Color(0xFFF4F3EE)),
      ),
      body: payments.isEmpty
          ? Center(child: Text(status))
          : RefreshIndicator(
              onRefresh: loadPayments,
              child: ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        payment['membership_name'] ?? 'Unknown Membership',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('dd MMM yyyy').format(
                                  DateTime.parse(payment['purchase_date']),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Expires: ${DateFormat('dd MMM yyyy').format(
                                  DateTime.parse(payment['expiry_date']),
                                )}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'RM ${payment['purchase_amount']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                  fontSize: 16,
                                ),
                              ),
                              _buildStatusChip(payment['payment_status']),
                            ],
                          ),
                        ],
                      ),
                      onTap: () => _showPaymentDetails(payment),
                    ),
                  );
                },
              ),
            ),
      drawer: const MyDrawer(),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'paid':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showPaymentDetails(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Receipt Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF463F3A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'RECEIPT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Receipt Content
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Company Logo and Info
                      Image.asset(
                        'assets/images/logo.png',
                        height: 60,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'MyMemberLink',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '123 Business Street\nCity, State 12345',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 20),
                      _buildDottedLine(),

                      // Add User Details here
                      const SizedBox(height: 20),
                      _buildReceiptRow(
                        'Name',
                        payment['user_name'] ?? 'N/A',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      _buildReceiptRow(
                        'Email',
                        payment['user_email'] ?? 'N/A',
                      ),
                      _buildReceiptRow(
                        'Phone',
                        payment['user_phoneNum'] ??
                            'N/A', // Note: changed to user_phoneNum
                      ),

                      const SizedBox(height: 20),
                      _buildDottedLine(),

                      // Transaction Details
                      const SizedBox(height: 20),
                      _buildReceiptRow(
                        'Transaction ID',
                        payment['transaction_id'],
                        style: const TextStyle(fontFamily: 'Courier'),
                      ),
                      _buildReceiptRow(
                        'Date',
                        DateFormat('dd/MM/yyyy HH:mm').format(
                          DateTime.parse(payment['purchase_date']),
                        ),
                      ),

                      const SizedBox(height: 20),
                      // Dotted Line
                      _buildDottedLine(),

                      // Membership Details
                      const SizedBox(height: 20),
                      _buildReceiptRow(
                        'Membership',
                        payment['membership_name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      _buildReceiptRow(
                        'Valid Until',
                        DateFormat('dd/MM/yyyy').format(
                          DateTime.parse(payment['expiry_date']),
                        ),
                      ),

                      const SizedBox(height: 20),
                      // Dotted Line
                      _buildDottedLine(),

                      // Payment Details
                      const SizedBox(height: 20),
                      _buildReceiptRow(
                        'Payment Method',
                        '${payment['payment_method']} (${payment['payment_provider']})',
                      ),
                      _buildReceiptRow(
                        'Status',
                        payment['payment_status'].toUpperCase(),
                        style: TextStyle(
                          color:
                              payment['payment_status'].toLowerCase() == 'paid'
                                  ? Colors.green
                                  : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),
                      // Total Amount
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'RM ${payment['purchase_amount']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      // Footer
                      const Text(
                        'Thank you for your business!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'For support: help@mymemberlink.com',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),

                      if (payment['payment_status'].toLowerCase() == 'pending')
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Close',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF463F3A),
                                ),
                                onPressed: () {
                                  // Close the current dialog
                                  Navigator.pop(context);
                                  // Navigate to MembershipPaymentScreen with existing payment data
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MembershipPaymentScreen(
                                        membership: Membership(
                                          membershipId: payment['membership_id']
                                              .toString(), // Convert to String
                                          membershipName:
                                              payment['membership_name'],
                                          membershipDesc:
                                              payment['membership_desc'] ?? '',
                                          membershipPrice: payment[
                                                  'purchase_amount']
                                              .toString(), // Convert to String
                                        ),
                                        existingTransactionId:
                                            payment['transaction_id'],
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Continue Payment',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
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
    );
  }

  Future<void> _continuePayment(Map<String, dynamic> payment) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final response = await http.post(
        Uri.parse(
            "${MyConfig.servername}/mymemberlink/api/update_payment_status.php"),
        body: {
          'transaction_id': payment['transaction_id'],
          'status': 'paid',
        },
      );

      // Close loading indicator
      Navigator.pop(context);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // Close the bottom sheet first
          Navigator.pop(context);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment completed successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Reload payments after a short delay
          await Future.delayed(const Duration(seconds: 2));
          await loadPayments();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Failed to complete payment'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Server error. Please try again later.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Close loading indicator if still showing
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildDottedLine() {
    return Row(
      children: List.generate(
        40,
        (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 2,
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String? value, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with fixed width
          SizedBox(
            width: 100, // Adjust this width as needed
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          // Value with remaining space
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: style ?? const TextStyle(),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
