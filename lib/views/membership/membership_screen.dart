import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../model/membership.dart';
import '../../myconfig.dart';
import '../shared/mydrawer.dart';
import 'package:mymemberlinks/views/membership/new_membership.dart';
import 'package:mymemberlinks/views/membership/membership_payment.dart';

class MembershipScreen extends StatefulWidget {
  static const routeName = '/membership';

  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  List<Membership> membershipList = [];
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    loadMemberships();
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
      ),
      body: membershipList.isEmpty
          ? Center(
              child: Text(status),
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
                            membershipList[index].membershipName ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            membershipList[index].membershipDesc ?? '',
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
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE0AFA0),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => const NewMembershipScreen()),
          );
          loadMemberships(); // Reload memberships after returning
        },
        child: const Icon(Icons.add),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                Text(
                  membership.membershipName ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailSection(
                  'Description',
                  membership.membershipDesc ?? '',
                ),
                _buildDetailSection(
                  'Benefits',
                  membership.membershipBenefits ?? '',
                ),
                _buildDetailSection(
                  'Terms',
                  membership.membershipTerms ?? '',
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Duration: ${membership.membershipDuration} months',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'RM ${membership.membershipPrice}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF463F3A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to payment screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MembershipPaymentScreen(
                            membership: membership,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Subscribe Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
