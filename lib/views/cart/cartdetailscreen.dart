import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymemberlinks/myconfig.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mymemberlinks/model/cartlist.dart';
import 'package:mymemberlinks/views/cart/edit_cart.dart';

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
        title: Text(
          "CART",
          style: GoogleFonts.monoton(color: const Color(0xFFF4F3EE)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF463F3A),
        iconTheme: const IconThemeData(
          color: Color(0xFFF4F3EE),
        ),
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
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Dismissible(
                          key: Key(cartItem.productId.toString()),
                          direction: DismissDirection.horizontal,
                          background: Container(
                            color: Colors.green,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.edit, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditCartScreen(cartItem: cartItem),
                                ),
                              ).then((updatedCartItem) {
                                if (updatedCartItem != null) {
                                  setState(() {
                                    cartItems[index] = updatedCartItem;
                                    totalPrice = cartItems.fold(
                                        0.0, (sum, item) => sum + item.price);
                                  });
                                }
                              });

                              return false;
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              final shouldDelete = await confirmDelete(index);
                              if (shouldDelete == true) {
                                final removedItem = cartItems.removeAt(index);

                                setState(() {
                                  totalPrice = cartItems.fold(
                                      0.0, (sum, item) => sum + item.price);
                                });

                                http.post(
                                  Uri.parse(
                                      "${MyConfig.servername}/mymemberlink/api/delete_cart_item.php"),
                                  body: {
                                    'cart_id': removedItem.cartId.toString()
                                  },
                                ).then((response) {
                                  if (response.statusCode == 200) {
                                    final data = jsonDecode(response.body);
                                    if (data['status'] == "success") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Item '${removedItem.productName}' deleted successfully"),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                              return false;
                            }
                            return false;
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
                            title: Text(cartItem.productName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text("Qty: ${cartItem.quantity}",
                                style: const TextStyle(color: Colors.grey)),
                            trailing: Text(
                                "RM ${cartItem.price.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    color: Colors.teal, fontSize: 16)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  color: const Color(0xFFF1F8E9),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Price:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("RM $totalPrice",
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
