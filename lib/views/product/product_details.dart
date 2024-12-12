import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymemberlinks/model/MyProduct.dart';
import 'package:mymemberlinks/myconfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailsScreen extends StatefulWidget {
  final MyProduct product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final quantityController = TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    final DateFormat df = DateFormat('dd/MM/yyyy hh:mm a');
    final productDate = widget.product.productDate != null
        ? df.format(
            DateTime.tryParse(widget.product.productDate!) ?? DateTime.now())
        : "N/A";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.productName ?? "Product Details",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF463F3A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: widget.product.productFileName != null
                    ? Image.network(
                        "${MyConfig.servername}/mymemberlink/assets/products/${widget.product.productFileName}",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset("assets/images/na.png",
                                fit: BoxFit.cover),
                      )
                    : Image.asset("assets/images/na.png", fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              // Product Name
              Text(
                widget.product.productName ?? "Unknown Product",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Product Description
              Text(
                widget.product.productDesc ?? "No description available.",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Product Price
              Text(
                "Price: RM ${widget.product.productPrice ?? "N/A"}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Product Quantity Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      int currentQuantity =
                          int.tryParse(quantityController.text) ?? 1;
                      if (currentQuantity > 1) {
                        quantityController.text =
                            (currentQuantity - 1).toString();
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      controller: quantityController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      int currentQuantity =
                          int.tryParse(quantityController.text) ?? 1;
                      quantityController.text =
                          (currentQuantity + 1).toString();
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await addToCart();
                  Navigator.pop(
                      context); // Close the current screen after adding to cart
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE0AFA0)),
                child: const Text("Add to Cart"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addToCart() async {
    final url =
        Uri.parse("${MyConfig.servername}/mymemberlink/api/add_to_cart.php");
    final quantity = int.tryParse(quantityController.text) ?? 1;
    final body = {
      "product_id": widget.product.productId.toString(),
      "quantity": quantity.toString(),
    };

    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Added to Cart!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to Add to Cart.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Unable to Add to Cart.")),
      );
    }
  }
}
