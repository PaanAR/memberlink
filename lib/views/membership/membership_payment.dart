import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlinks/model/membership.dart';
import 'package:mymemberlinks/myconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../membership/payment_list_screen.dart';

class MembershipPaymentScreen extends StatefulWidget {
  final Membership membership;
  final String? existingTransactionId;

  const MembershipPaymentScreen(
      {Key? key, required this.membership, this.existingTransactionId})
      : super(key: key);

  @override
  State<MembershipPaymentScreen> createState() =>
      _MembershipPaymentScreenState();
}

class _MembershipPaymentScreenState extends State<MembershipPaymentScreen> {
  String selectedPaymentMethod = 'credit_card';
  String? selectedBank;
  bool isProcessing = false;
  String? userId;

  // List of Malaysian banks with their logos
  final List<Map<String, dynamic>> malaysianBanks = [
    {
      'name': 'Maybank',
      'value': 'maybank',
      'logo': 'assets/images/banks/maybank.png',
    },
    {
      'name': 'CIMB Bank',
      'value': 'cimb',
      'logo': 'assets/images/banks/cimb.png',
    },
    {
      'name': 'Bank Islam',
      'value': 'bank_islam',
      'logo': 'assets/images/banks/bank_islam.png',
    },
    {
      'name': 'Bank Rakyat',
      'value': 'bank_rakyat',
      'logo': 'assets/images/banks/bank_rakyat.png',
    },
    {
      'name': 'Public Bank',
      'value': 'public_bank',
      'logo': 'assets/images/banks/public_bank.png',
    },
    {
      'name': 'RHB Bank',
      'value': 'rhb',
      'logo': 'assets/images/banks/rhb.png',
    },
    {
      'name': 'Hong Leong Bank',
      'value': 'hong_leong',
      'logo': 'assets/images/banks/hong_leong.png',
    },
    {
      'name': 'AmBank',
      'value': 'ambank',
      'logo': 'assets/images/banks/ambank.png',
    },
  ];

  // List of e-wallets
  final List<Map<String, dynamic>> eWallets = [
    {
      'name': 'Touch n Go eWallet',
      'value': 'tng',
      'logo': 'assets/images/ewallets/tng.png',
    },
    {
      'name': 'GrabPay',
      'value': 'grabpay',
      'logo': 'assets/images/ewallets/grabpay.png',
    },
    {
      'name': 'Boost',
      'value': 'boost',
      'logo': 'assets/images/ewallets/boost.png',
    },
    {
      'name': 'ShopeePay',
      'value': 'shopeepay',
      'logo': 'assets/images/ewallets/shopeepay.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('user_id');
    print("Loaded user ID: $id"); // Debug print
    setState(() {
      userId = id;
    });

    // Show message if no user ID found
    if (userId == null) {
      if (mounted) {
        // Check if widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login first to purchase membership'),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.of(context).pop(); // Return to previous screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment",
          style: GoogleFonts.monoton(color: const Color(0xFFF4F3EE)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF463F3A),
        iconTheme: const IconThemeData(color: Color(0xFFF4F3EE)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Membership Summary Card
            _buildMembershipSummary(),
            const SizedBox(height: 24),

            // Payment Method Selection
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Payment Methods Card
            Card(
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Credit/Debit Card'),
                    value: 'credit_card',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                        selectedBank = null;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Online Banking (FPX)'),
                    value: 'online_banking',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                        selectedBank = null;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('E-Wallet'),
                    value: 'e_wallet',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                        selectedBank = null;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Show bank selection if online banking is selected
            if (selectedPaymentMethod == 'online_banking')
              _buildBankSelection(),

            // Show e-wallet selection if e-wallet is selected
            if (selectedPaymentMethod == 'e_wallet') _buildEWalletSelection(),

            // Show credit card form if credit card is selected
            if (selectedPaymentMethod == 'credit_card') _buildCreditCardForm(),

            const SizedBox(height: 24),

            // Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canProceed()
                    ? (isProcessing ? null : processPurchase)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF463F3A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Proceed to Payment',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.membership.membershipName ?? '',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.membership.membershipDesc ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Amount:'),
                Text(
                  'RM ${widget.membership.membershipPrice}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Bank',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: malaysianBanks.length,
          itemBuilder: (context, index) {
            final bank = malaysianBanks[index];
            final isSelected = selectedBank == bank['value'];

            return InkWell(
              onTap: () {
                setState(() {
                  selectedBank = bank['value'];
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.teal : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected ? Colors.teal.shade50 : Colors.white,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        bank['logo'],
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.account_balance, size: 40),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        bank['name'],
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEWalletSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select E-Wallet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: eWallets.length,
          itemBuilder: (context, index) {
            final wallet = eWallets[index];
            final isSelected = selectedBank == wallet['value'];

            return InkWell(
              onTap: () {
                setState(() {
                  selectedBank = wallet['value'];
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.teal : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected ? Colors.teal.shade50 : Colors.white,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        wallet['logo'],
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.account_balance_wallet, size: 40),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        wallet['name'],
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCreditCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Card Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Card Number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Expiry Date',
                  border: OutlineInputBorder(),
                  hintText: 'MM/YY',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool canProceed() {
    if (selectedPaymentMethod == 'online_banking' ||
        selectedPaymentMethod == 'e_wallet') {
      return selectedBank != null;
    }
    return true; // For credit card, we'll validate the form fields later
  }

  Future<void> processPurchase() async {
    // Add debug print
    print("Processing purchase with user ID: $userId");

    if (userId == null || userId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to continue')),
      );
      Navigator.of(context).pop(); // Return to previous screen
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      // Simulate payment processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Debug print the request data
      print("Sending payment request with data:");
      print({
        'user_id': userId,
        'membership_id': widget.membership.membershipId,
        'amount': widget.membership.membershipPrice,
        'payment_method': selectedPaymentMethod,
        'payment_provider': selectedBank ?? '',
      });

      final response = await http.post(
        Uri.parse(
            "${MyConfig.servername}/mymemberlink/api/process_payment.php"),
        body: {
          'user_id': userId,
          'membership_id': widget.membership.membershipId,
          'amount': widget.membership.membershipPrice,
          'payment_method': selectedPaymentMethod,
          'payment_provider': selectedBank ?? '',
          // Add existing transaction ID if it exists
          if (widget.existingTransactionId != null)
            'transaction_id': widget.existingTransactionId,
        },
      );

      // Debug print the response
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Decoded response data: $data"); // Debug print
        if (data['status'] == 'success') {
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Payment Processing'),
                  content: const Text(
                    'Your payment is being processed. You can check the status in your payment history.',
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.of(context)
                            .pop(); // Return to previous screen
                      },
                    ),
                    TextButton(
                      child: const Text('View Payment History'),
                      onPressed: () {
                        // Pop all the way back to membership screen first
                        Navigator.of(context).popUntil(
                          (route) =>
                              route.isFirst ||
                              route.settings.name == '/membership',
                        );
                        // Then push the payment list screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentListScreen(),
                          ),
                        );
                      },
                    ),
                    TextButton(
                      child: const Text('Continue Payment'),
                      onPressed: () async {
                        // Update payment status to 'paid'
                        await updatePaymentStatus(
                            data['data']['transaction_id'], 'paid');

                        // Close all dialogs and screens up to membership screen
                        if (mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/membership',
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          throw Exception(data['message'] ?? 'Payment failed');
        }
      } else {
        throw Exception('Server error');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Future<void> updatePaymentStatus(String transactionId, String status) async {
    try {
      final response = await http.post(
        Uri.parse(
            "${MyConfig.servername}/mymemberlink/api/update_payment_status.php"),
        body: {
          'transaction_id': transactionId,
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment completed successfully')),
            );
          }
        }
      }
    } catch (e) {
      print("Error updating payment status: $e");
    }
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: const Text('Your payment has been processed successfully!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).popUntil(
                  (route) =>
                      route.isFirst || route.settings.name == '/membership',
                );
              },
            ),
          ],
        );
      },
    );
  }
}
