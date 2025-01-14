import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mymemberlinks/model/MyProduct.dart';
import 'package:mymemberlinks/myconfig.dart';
import 'package:mymemberlinks/views/cart/cartdetailscreen.dart';
import 'package:mymemberlinks/views/product/new_product.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlinks/views/product/product_details.dart';
import '../shared/mydrawer.dart';
import '../../model/user.dart';

class ProductScreen extends StatefulWidget {
  final User user;
  const ProductScreen({super.key, required this.user});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<MyProduct> productsList = [];
  late double screenWidth, screenHeight;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  int numofpage = 1;
  int currpage = 1;
  int numofresult = 0;
  var color;
  int cartItemCount = 0;
  String status = "Loading...";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProductsData();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {}
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product",
          style: GoogleFonts.monoton(color: const Color(0xFFF4F3EE)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF463F3A),
        iconTheme: const IconThemeData(
          color: Color(0xFFF4F3EE), // Light Beige for the hamburger icon
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartDetailsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart, color: Color(0xFFF4F3EE)),
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: () {
              loadProductsData();
            },
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFFF4F3EE)),
          ),
        ],
      ),
      body: productsList.isEmpty
          ? Center(
              child: Column(
                children: [
                  Lottie.asset(
                    "assets/animations/Animation_4.json",
                    fit: BoxFit.contain,
                    width: 300,
                    height: 300, // Set your desired width
                    // Set your desired height
                  ),
                  const SizedBox(height: 20),
                  // Custom message
                  const Text(
                    "No Products Available",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Try refreshing or check back later.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Page $currpage of $numofpage | Total Results: $numofresult",
                      style: const TextStyle(fontSize: 16)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: productsList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: InkWell(
                          onTap: () async {
                            showProductsDetailsDialog(index);
                            loadProductsData(); // Reload products if needed
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // Product Image with SizedBox
                                SizedBox(
                                  width: screenWidth *
                                      0.2, // Adjust size as needed
                                  height: screenWidth * 0.2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Show product details dialog
                                        showProductsDetailsDialog(index);
                                      },
                                      child: Image.network(
                                        "${MyConfig.servername}/mymemberlink/assets/products/${productsList[index].productFileName}",
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            Image.asset("assets/images/na.png",
                                                fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        10), // Spacing between image and details
                                // Product Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product Name
                                      Text(
                                        productsList[index]
                                            .productName
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      // Product Description
                                      Text(
                                        productsList[index]
                                            .productDesc
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 5),
                                      // Product Price and Quantity
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Price: RM ${productsList[index].productPrice}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.teal,
                                            ),
                                          ),
                                          Text(
                                            "Qty: ${productsList[index].productQty}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      // Product Date
                                      Text(
                                        "Date: ${df.format(DateTime.parse(productsList[index].productDate.toString()))}",
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      const SizedBox(height: 10),
                                      // Button to navigate to ProductDetailsScreen
                                      ElevatedButton(
                                        onPressed: () async {
                                          MyProduct product =
                                              MyProduct.fromJson(
                                                  productsList[index].toJson());
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (content) =>
                                                  ProductDetailsScreen(
                                                      product: product),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.teal, // Button color
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: const Text(
                                          "Add To Cart",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.08, // Compact height
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Left Arrow
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: currpage > 1 ? Colors.black : Colors.grey),
                        onPressed: currpage > 1
                            ? () {
                                setState(() {
                                  currpage--;
                                });
                                loadProductsData();
                              }
                            : null,
                      ),
                      // Page Numbers (Centered Logic)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          3,
                          (index) {
                            int pageIndex = currpage - 2 + index;
                            if (pageIndex < 1 || pageIndex > numofpage) {
                              // Skip invalid pages
                              return const SizedBox(width: 0);
                            }
                            bool isSelected = pageIndex == currpage;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  currpage = pageIndex;
                                });
                                loadProductsData();
                              },
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: isSelected ? 1.0 : 0.6,
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? const Color(0xFF463F3A)
                                        : const Color(0xFFE0AFA0),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      pageIndex.toString(),
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Right Arrow
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios,
                            color: currpage < numofpage
                                ? Colors.black
                                : Colors.grey),
                        onPressed: currpage < numofpage
                            ? () {
                                setState(() {
                                  currpage++;
                                });
                                loadProductsData();
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
      drawer: MyDrawer(user: widget.user),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE0AFA0), // Soft Peach
        onPressed: () async {
          // loadNewsData();
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => NewProcuctScreen(user: widget.user)));
          loadProductsData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void loadProductsData() {
    final productUrl = Uri.parse(
        "${MyConfig.servername}/mymemberlink/api/load_products.php?pageno=$currpage");

    final cartUrl = Uri.parse(
        "${MyConfig.servername}/mymemberlink/api/load_cart_count.php");

    // Fetch products
    http.get(productUrl).then((response) {
      log("Product Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          var result = data['data']['products'];
          productsList.clear();

          for (var item in result) {
            MyProduct product = MyProduct.fromJson(item);
            productsList.add(product);
          }

          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());

          setState(() {});
        } else {
          log("Failed to load product: ${data['message'] ?? 'Unknown error'}");
          setState(() {
            status = "Failed to load products.";
          });
        }
      } else {
        log("HTTP Error: ${response.statusCode}, ${response.reasonPhrase}");
        setState(() {
          status = "Error: Unable to fetch products.";
        });
      }
    }).catchError((error) {
      log("Error occurred: $error");
      setState(() {
        status = "Error: Unable to fetch products.";
      });
    });

    // Fetch cart count
    http.get(cartUrl).then((response) {
      log("Cart Count Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          setState(() {
            cartItemCount = data['cart_count'];
          });
        }
      }
    }).catchError((error) {
      log("Error fetching cart count: $error");
    });
  }

  void showProductsDetailsDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(productsList[index].productName.toString()),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    "assets/images/na.png",
                  ),
                  width: screenWidth,
                  height: screenHeight / 4,
                  fit: BoxFit.cover,
                  scale: 4,
                  "${MyConfig.servername}/mymemberlink/assets/products/${productsList[index].productFileName}",
                ),
                Text(df.format(DateTime.parse(
                    productsList[index].productDate.toString()))),
                const SizedBox(height: 10),
                Text(
                  productsList[index].productDesc.toString(),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price: RM ${productsList[index].productPrice}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    Text(
                      "Qty: ${productsList[index].productQty}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  String truncateString(String str, int length) {
    if (str.length > length) {
      str = str.substring(0, length);
      return "$str...";
    } else {
      return str;
    }
  }
}
