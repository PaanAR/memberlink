import 'package:flutter/material.dart';
import 'package:mymemberlinks/views/events/event_screen.dart';
import 'package:mymemberlinks/views/membership/membership_screen.dart';
//import 'package:mymemberlinks/views/membership/membership_screen.dart';
import 'package:mymemberlinks/views/newsletter/news_screen.dart';
import 'package:mymemberlinks/views/product/product_screen.dart';
import '../../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mymemberlinks/views/auth/login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mymemberlinks/myconfig.dart';

class MyDrawer extends StatefulWidget {
  final User user;
  const MyDrawer({super.key, required this.user});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? latestMembership;
  String? expiryDate;

  @override
  void initState() {
    super.initState();
    loadLatestMembership();
  }

  Future<void> loadLatestMembership() async {
    try {
      print('Loading membership for user ID: ${widget.user.userId}');

      final response = await http.get(
        Uri.parse(
          "${MyConfig.servername}/mymemberlink/api/get_latest_membership.php?userid=${widget.user.userId}",
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('Decoded data: $data');

        if (data['status'] == 'success') {
          setState(() {
            latestMembership = data['membership_name'];
            expiryDate = data['expiry_date'];
            print('Latest Membership: $latestMembership');
            print('Expiry Date: $expiryDate');
          });
        } else {
          print('API returned non-success status: ${data['status']}');
        }
      }
    } catch (e) {
      print("Error loading membership: $e");
      print("Stack trace: ${StackTrace.current}");
    }
  }

  @override
  Widget build(BuildContext context) {
    print('User ID: ${widget.user.userId}');
    print('Username: ${widget.user.username}');
    print('Email: ${widget.user.userEmail}');
    print('Phone: ${widget.user.phoneNumber}');
    return Drawer(
      backgroundColor: const Color(0xFFF4F3EE), // Light Beige
      child: ListView(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF463F3A),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE0AFA0),
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundColor: Color(0xFFF4F3EE),
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Color(0xFF8A817C),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.user.username ?? "User",
                  style: const TextStyle(
                    color: Color(0xFFF4F3EE),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.user.userEmail ?? "Email",
                  style: TextStyle(
                    color: const Color(0xFFF4F3EE).withOpacity(0.7),
                    fontSize: 13,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (latestMembership != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0AFA0).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE0AFA0).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Color(0xFFE0AFA0),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              latestMembership!,
                              style: const TextStyle(
                                color: Color(0xFFE0AFA0),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        if (expiryDate != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            "Valid until $expiryDate",
                            style: TextStyle(
                              color: const Color(0xFFF4F3EE).withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(
                            user: widget.user,
                          )));
            },
            leading: const Icon(Icons.article, color: Color(0xFF463F3A)),
            title: const Text("Newsletter",
                style: TextStyle(color: Color(0xFF463F3A))),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => EventScreen(
                            user: widget.user,
                          )));
            },
            leading: const Icon(Icons.event, color: Color(0xFF8A817C)),
            title: const Text("Events",
                style: TextStyle(color: Color(0xFF463F3A))),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (content) =>
                      MembershipScreen(user: widget.user), // Pass user here
                ),
              );
            },
            leading: const Icon(Icons.group, color: Color(0xFFE0AFA0)),
            title: const Text("Members",
                style: TextStyle(color: Color(0xFF463F3A))),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.check_circle, color: Color(0xFFBCB8B1)),
            title: const Text("Vetting",
                style: TextStyle(color: Color(0xFF463F3A))),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.book, color: Color(0xFFE0AFA0)),
            title: const Text("Resources",
                style: TextStyle(color: Color(0xFF463F3A))),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.payment, color: Color(0xFF8A817C)),
            title: const Text("Payments",
                style: TextStyle(color: Color(0xFF463F3A))),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => ProductScreen(user: widget.user)));
            },
            leading: const Icon(Icons.shopping_cart, color: Color(0xFF463F3A)),
            title: const Text("Products",
                style: TextStyle(color: Color(0xFF463F3A))),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.mail, color: Color(0xFFE0AFA0)),
            title: const Text("Mailings",
                style: TextStyle(color: Color(0xFF463F3A))),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.people, color: Color(0xFFBCB8B1)),
            title: const Text("Committee",
                style: TextStyle(color: Color(0xFF463F3A))),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.settings, color: Color(0xFF8A817C)),
            title: const Text("Settings",
                style: TextStyle(color: Color(0xFF463F3A))),
          ),
          ListTile(
            onTap: () {
              logout(context);
            },
            leading: const Icon(Icons.logout, color: Color(0xFF8A817C)),
            title: const Text("Logout",
                style: TextStyle(color: Color(0xFF463F3A))),
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context) async {
    // Clear shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to the LoginScreen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
