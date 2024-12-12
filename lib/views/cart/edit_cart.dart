import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mymemberlinks/model/cartlist.dart';
import 'package:mymemberlinks/myconfig.dart';

class EditCartScreen extends StatefulWidget {
  final Cart cartItem;

  const EditCartScreen({Key? key, required this.cartItem}) : super(key: key);

  @override
  _EditCartScreenState createState() => _EditCartScreenState();
}

class _EditCartScreenState extends State<EditCartScreen> {
  late TextEditingController _quantityController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantityController =
        TextEditingController(text: widget.cartItem.quantity.toString());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void saveChanges() async {
    final updatedQuantity = int.tryParse(_quantityController.text);
    if (updatedQuantity != null && updatedQuantity > 0) {
      setState(() {
        isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse("${MyConfig.servername}/mymemberlink/api/edit_cart.php"),
          body: {
            'cart_id': widget.cartItem.cartId.toString(),
            'quantity': updatedQuantity.toString(),
          },
        );

        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Quantity updated successfully.")),
            );
            Navigator.pop(context, updatedQuantity);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed: ${responseData['message']}")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Server error: ${response.statusCode}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid quantity.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Quantity"),
        backgroundColor: const Color(0xFF00BFA5),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: isLoading ? null : saveChanges,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Update Quantity",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isLoading ? null : saveChanges,
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
    );
  }
}
