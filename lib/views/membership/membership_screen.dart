import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../model/membership.dart';
import '../../myconfig.dart';
import '../shared/mydrawer.dart';
// import 'package:mymemberlinks/views/membership/new_membership.dart';
import '../payment/billscreen.dart';
import '../../model/user.dart';
import '../payment/payment_history_screen.dart';

class MembershipScreen extends StatefulWidget {
  final User user;
  const MembershipScreen({super.key, required this.user});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  List<Membership> membershipList = [];
  List<Map<String, dynamic>> purchaseHistory = [];
  String status = "Loading...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
// Debug user info when the screen is initialized
    print('User ID: ${widget.user.userId}');
    print('Username: ${widget.user.username}');
    print('Email: ${widget.user.userEmail}');
    print('Phone: ${widget.user.phoneNumber}');

    loadMemberships();
    _loadPurchaseHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Memberships",
          style: GoogleFonts.monoton(color: const Color(0xFFF4F3EE)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF463F3A),
        iconTheme: const IconThemeData(color: Color(0xFFF4F3EE)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                status = "Loading...";
                membershipList.clear();
              });
              loadMemberships();
              _loadPurchaseHistory();
            },
          ),
        ],
      ),
      body: membershipList.isEmpty
          ? Center(
              child: status == "Loading..."
                  ? CircularProgressIndicator() // Show loading spinner while loading data
                  : Text(status),
            )
          : ListView.builder(
              itemCount: membershipList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () => showMembershipDetails(membershipList[index]),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            membershipList[index].membershipName ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            membershipList[index].membershipDesc ??
                                'No Description',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'RM ${membershipList[index].membershipPrice}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              Text(
                                '${membershipList[index].membershipDuration} months',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      drawer: MyDrawer(user: widget.user),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "viewHistory",
            backgroundColor: const Color(0xFF463F3A),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentHistoryScreen(user: widget.user),
              ),
            ),
            child: const Icon(Icons.history),
          ),
          // const SizedBox(width: 16),
          // FloatingActionButton(
          //   heroTag: "addMembership",
          //   backgroundColor: const Color(0xFFE0AFA0),
          //   onPressed: () async {
          //     await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (content) =>
          //               NewMembershipScreen(user: widget.user)),
          //     );
          //     loadMemberships();
          //   },
          //   child: const Icon(Icons.add),
          // ),
        ],
      ),
    );
  }

  void loadMemberships() async {
    try {
      var response = await http.get(
        Uri.parse(
            "${MyConfig.servername}/mymemberlink/api/load_memberships.php"),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            membershipList = List<Membership>.from(
              jsonData['data']['memberships'].map(
                (item) => Membership.fromJson(item),
              ),
            );
          });
        } else {
          setState(() {
            status = "No memberships available";
          });
        }
      } else {
        setState(() {
          status = "Failed to connect to server";
        });
      }
    } catch (e) {
      setState(() {
        status = "Error: $e";
      });
    }
  }

  void showMembershipDetails(Membership membership) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  Text(
                    membership.membershipName ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF463F3A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailSection(
                    'Description',
                    membership.membershipDesc ?? '',
                    icon: Icons.info_outline,
                  ),
                  _buildDetailSection(
                    'Benefits',
                    membership.membershipBenefits ?? '',
                    icon: Icons.star_outline,
                  ),
                  _buildDetailSection(
                    'Terms',
                    membership.membershipTerms ?? '',
                    icon: Icons.gavel_outlined,
                  ),
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Duration',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${membership.membershipDuration} months',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF463F3A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'RM ${membership.membershipPrice}',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF463F3A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _processMembershipPayment(membership);
                      },
                      child: Text(
                        'Subscribe Now',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, {IconData? icon}) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null)
                  Icon(icon, size: 20, color: const Color(0xFF463F3A)),
                if (icon != null) const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF463F3A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processMembershipPayment(Membership membership) async {
    try {
      double? price = double.tryParse(membership.membershipPrice ?? '0');
      if (price == null || price <= 0) {
        throw Exception('Invalid membership price');
      }

      // Create pending purchase first
      final response = await http.post(
        Uri.parse(
            "${MyConfig.servername}/mymemberlink/api/create_pending_purchase.php"),
        body: {
          'user_id': widget.user.userId.toString(),
          'membership_id': membership.membershipId.toString(),
          'amount': price.toString(),
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          // Get the purchase_id and receipt_id from response
          final purchaseId = jsonResponse['data']['purchase_id'];
          final receiptId = jsonResponse['data']['receipt_id'];

          // Navigate to BillScreen with purchase details
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (content) => BillScreen(
                user: widget.user,
                totalprice: price,
                membership: membership,
                purchaseId: purchaseId.toString(),
                receiptId: receiptId,
              ),
            ),
          );

          // Refresh the purchase history after returning
          _loadPurchaseHistory();
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Failed to create pending purchase');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing payment: ${e.toString()}')),
      );
    }
  }

  Future<void> _loadPurchaseHistory() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(
          "${MyConfig.servername}/mymemberlink/api/load_purchase_history.php?userid=${widget.user.userId}",
        ),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            purchaseHistory = List<Map<String, dynamic>>.from(jsonData['data']);
            isLoading = false;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading history: $e')),
      );
    }
    setState(() => isLoading = false);
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'success':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = Icons.check_circle;
        break;
      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        icon = Icons.pending;
        break;
      case 'failed':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Icons.error;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
