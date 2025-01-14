import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlinks/myconfig.dart';
import 'package:mymemberlinks/model/user.dart';

class NewMembershipScreen extends StatefulWidget {
  final User user;
  const NewMembershipScreen({super.key, required this.user});

  @override
  State<NewMembershipScreen> createState() => _NewMembershipScreenState();
}

class _NewMembershipScreenState extends State<NewMembershipScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController benefitsController = TextEditingController();
  TextEditingController termsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add New Membership",
          style: GoogleFonts.monoton(color: const Color(0xFFF4F3EE)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF463F3A),
        iconTheme: const IconThemeData(color: Color(0xFFF4F3EE)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Membership Name
              TextFormField(
                controller: nameController,
                decoration: _buildInputDecoration("Membership Name"),
                validator: (value) =>
                    value!.isEmpty ? "Enter Membership Name" : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: descriptionController,
                decoration: _buildInputDecoration("Description"),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Description";
                  } else if (value.length < 10) {
                    return "Description must be longer than 10 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price and Duration Row
              Row(
                children: [
                  // Price
                  Expanded(
                    child: TextFormField(
                      controller: priceController,
                      decoration: _buildInputDecoration("Price (RM)"),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter price";
                        }
                        if (double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return "Invalid price";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Duration
                  Expanded(
                    child: TextFormField(
                      controller: durationController,
                      decoration: _buildInputDecoration("Duration (months)"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter duration";
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return "Invalid duration";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Benefits
              TextFormField(
                controller: benefitsController,
                decoration: _buildInputDecoration("Benefits"),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? "Enter Benefits" : null,
              ),
              const SizedBox(height: 16),

              // Terms
              TextFormField(
                controller: termsController,
                decoration: _buildInputDecoration("Terms & Conditions"),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? "Enter Terms" : null,
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      insertMembershipDialog();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF463F3A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Create Membership",
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
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
    );
  }

  void insertMembershipDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Create Membership"),
          content:
              const Text("Are you sure you want to create this membership?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                insertMembership();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void insertMembership() {
    http.post(
      Uri.parse(
          "${MyConfig.servername}/mymemberlink/api/insert_membership.php"),
      body: {
        "name": nameController.text,
        "description": descriptionController.text,
        "price": priceController.text,
        "duration": durationController.text,
        "benefits": benefitsController.text,
        "terms": termsController.text,
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Membership Created Successfully"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (content) => NewMembershipScreen(user: widget.user),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to Create Membership"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
