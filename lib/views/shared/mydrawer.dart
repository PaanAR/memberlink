import 'package:flutter/material.dart';
import 'package:mymemberlinks/views/events/event_screen.dart';
import 'package:mymemberlinks/views/membership/membership_screen.dart';
import 'package:mymemberlinks/views/newsletter/news_screen.dart';
import 'package:mymemberlinks/views/product/product_screen.dart';
import '../membership/payment_list_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF4F3EE), // Light Beige
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF463F3A)), // Dark Brown
            child: Text(
              "Drawer Header",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (content) => const MainScreen()));
            },
            leading: const Icon(Icons.article, color: Color(0xFF463F3A)),
            title: const Text("Newsletter",
                style: TextStyle(color: Color(0xFF463F3A))),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (content) => const EventScreen()));
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
                      builder: (content) => const MembershipScreen()));
            },
            leading: const Icon(Icons.group, color: Color(0xFFE0AFA0)),
            title: const Text("Membership",
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
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentListScreen(),
                ),
              );
            },
            leading: const Icon(Icons.payment, color: Color(0xFF8A817C)),
            title: const Text("Payments",
                style: TextStyle(color: Color(0xFF463F3A))),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => const ProductScreen()));
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
        ],
      ),
    );
  }
}
