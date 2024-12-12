import 'package:flutter/material.dart';
import 'package:mymemberlinks/myconfig.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mymemberlinks/model/cartlist.dart';

class CartDetailsScreen extends StatefulWidget {
  const CartDetailsScreen({super.key});

  @override
  _CartDetailsScreenState createState() => _CartDetailsScreenState();
}

class _CartDetailsScreenState extends State<CartDetailsScreen> {
  List<Cart> cartItems = [];
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    loadCartData();
  }

  Future<void> loadCartData() async {
    final url =
        Uri.parse("${MyConfig.servername}/mymemberlink/api/load_cart.php");

    try {
      final response = await http.get(url);

      debugPrint("[log] Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          var items = data['data']['cart'];
          cartItems = items.map<Cart>((item) => Cart.fromJson(item)).toList();

          totalPrice = cartItems.fold(0.0, (sum, item) => sum + item.price);

          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? "Failed to load cart")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Unable to load cart")),
        );
      }
    } catch (error) {
      debugPrint("[log] Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    }
  }

  void deleteCartItem(int index) {
    String productId = cartItems[index].productId.toString();

    // Remove the item before calling setState
    final removedItem = cartItems.removeAt(index);

    setState(() {
      totalPrice = cartItems.fold(0.0, (sum, item) => sum + item.price);
    });

    http.post(
      Uri.parse("${MyConfig.servername}/mymemberlink/api/delete_cart_item.php"),
      body: {'product_id': productId},
    ).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Item '${removedItem.productName}' deleted successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Failed to delete item: ${data['message']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error: Unable to delete item")),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    });
  }

  Future<bool?> confirmDelete(int index) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text(
              "Are you sure you want to remove '${cartItems[index].productName}' from the cart?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return `false` to cancel deletion
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                setState(() {}); // Return `true` to confirm deletion
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart Details"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              loadCartData();
            },
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("No items in the cart."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return Dismissible(
                        key: Key(cartItem.productId.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          final shouldDelete = await confirmDelete(index);
                          if (shouldDelete == true) {
                            // Remove the item from the list immediately
                            final removedItem = cartItems.removeAt(index);

                            setState(() {
                              // Recalculate the total price after item removal
                              totalPrice = cartItems.fold(
                                  0.0, (sum, item) => sum + item.price);
                            });

                            // Proceed with API call for deletion
                            http.post(
                              Uri.parse(
                                  "${MyConfig.servername}/mymemberlink/api/delete_cart_item.php"),
                              body: {'cart_id': removedItem.cartId.toString()},
                            ).then((response) {
                              if (response.statusCode == 200) {
                                final data = jsonDecode(response.body);
                                if (data['status'] == "success") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Item '${removedItem.productName}' deleted successfully"),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Failed to delete item: ${data['message']}")),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Server error: Unable to delete item")),
                                );
                              }
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $error")),
                              );
                            });

                            return true;
                          }
                          return false; // Prevent the dismissal if the user cancels
                        },
                        child: ListTile(
                          leading: SizedBox(
                            width: 60.0,
                            height: 60.0,
                            child: Image.network(
                              "${MyConfig.servername}/mymemberlink/assets/products/${cartItem.productFileName}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                "assets/images/na.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(cartItem.productName),
                          subtitle: Text("Qty: ${cartItem.quantity}"),
                          trailing:
                              Text("RM ${cartItem.price.toStringAsFixed(2)}"),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Total Price: RM $totalPrice",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }
}
