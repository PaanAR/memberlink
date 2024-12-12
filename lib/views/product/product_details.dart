import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product",
          //widget.product.productName ?? "Product Details",
          style: GoogleFonts.monoton(
            color: const Color(0xFFF4F3EE),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF463F3A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Container(
                width: screenWidth * 0.8,
                height: screenWidth * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: widget.product.productFileName != null
                      ? DecorationImage(
                          image: NetworkImage(
                            "${MyConfig.servername}/mymemberlink/assets/products/${widget.product.productFileName}",
                          ),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage("assets/images/na.png"),
                          fit: BoxFit.cover,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Product Name
            Center(
              child: Text(
                widget.product.productName ?? "Unknown Product",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Product Description
            Text(
              widget.product.productDesc ?? "No description available.",
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            Text(
              "Quantity Avalaible : ${widget.product.productQty ?? "N/A"}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 13, 45, 226),
              ),
            ),
            const SizedBox(height: 20),
            // Product Price
            Text(
              "Price: RM ${widget.product.productPrice ?? "N/A"}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 20),
            // Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.red),
                ),
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    controller: quantityController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    int currentQuantity =
                        int.tryParse(quantityController.text) ?? 1;
                    quantityController.text = (currentQuantity + 1).toString();
                  },
                  icon:
                      const Icon(Icons.add_circle_outline, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Add to Cart Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await addToCart();
                  Navigator.pop(context); // Close the current screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0AFA0), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 40,
                  ),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
