import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlinks/myconfig.dart';
import 'package:mymemberlinks/views/product/product_screen.dart';

class NewProcuctScreen extends StatefulWidget {
  const NewProcuctScreen({super.key});

  @override
  State<NewProcuctScreen> createState() => _NewProcuctScreenState();
}

class _NewProcuctScreenState extends State<NewProcuctScreen> {
  late double screenWidth, screenHeight;

  File? _image;
  int quantity = 1;
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  @override
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add New Product",
          style: GoogleFonts.monoton(color: const Color(0xFFF4F3EE)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF463F3A),
        iconTheme: const IconThemeData(
          color: Color(0xFFF4F3EE),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // Image Picker Section
            GestureDetector(
              onTap: () {
                showSelectionDialog();
              },
              child: Container(
                height: screenHeight * 0.3,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                  image: _image == null
                      ? null
                      : DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        ),
                ),
                child: _image == null
                    ? const Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? "Enter Product Name" : null,
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Product Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Product Description
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Product Description";
                      } else if (value.length < 10) {
                        return "Product description must be longer than 10 characters";
                      }
                      return null;
                    },
                    controller: descriptionController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: "Product Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Quantity and Price Row
                  Row(
                    children: [
                      // Quantity decrement button
                      IconButton(
                        onPressed: () {
                          setState(() {
                            int currentQuantity =
                                int.tryParse(quantityController.text) ?? 1;
                            if (currentQuantity > 1) {
                              quantityController.text =
                                  (currentQuantity - 1).toString();
                            }
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.red),
                      ),

                      // Quantity input field
                      SizedBox(
                        width: 60,
                        child: TextFormField(
                          controller: quantityController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter quantity";
                            }
                            if (int.tryParse(value) == null ||
                                int.parse(value) <= 0) {
                              return "Enter a valid number";
                            }
                            return null;
                          },
                        ),
                      ),

                      // Quantity increment button
                      IconButton(
                        onPressed: () {
                          setState(() {
                            int currentQuantity =
                                int.tryParse(quantityController.text) ?? 1;
                            quantityController.text =
                                (currentQuantity + 1).toString();
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline,
                            color: Colors.green),
                      ),
                      const SizedBox(width: 16),
                      // Price
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: InputDecoration(
                            labelText: "Price (RM)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            prefixIcon: const Icon(Icons.attach_money),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter price";
                            }
                            if (double.tryParse(value) == null ||
                                double.parse(value) <= 0) {
                              return "Enter a valid price";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Insert Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _image != null) {
                          insertProductDialog();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _image == null
                                    ? "Please select an image"
                                    : "Please fill out all fields correctly",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
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
                        "Insert Product",
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
          ],
        ),
      ),
    );
  }

  void showSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Choose",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth / 4, screenHeight / 8)),
                  child: const Text('Gallery'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectfromGallery(),
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth / 4, screenHeight / 8)),
                  child: const Text('Camera'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectFromCamera(),
                  },
                ),
              ],
            ));
      },
    );
  }

  Future<void> _selectfromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    // print("BEFORE CROP: ");
    // print(getFileSize(_image!));
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
      setState(() {});
    } else {}
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    // print("BEFORE CROP: ");
    // print(getFileSize(_image!));
    if (pickedFile != null) {
      _image = File(pickedFile.path);

      cropImage();
      setState(() {});
    } else {}
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Please Crop Your Image',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ]);
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      print(getFileSize(_image!));
      setState(() {});
    }
  }

  double getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInKB = (sizeInBytes / (1024 * 1024)) * 1000;
    return sizeInKB;
  }

  void insertProductDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: const Text(
              "Insert Product",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () {
                  insertProduct();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductScreen()));
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }

  void insertProduct() {
    String name = nameController.text;
    String description = descriptionController.text;
    String quantity = quantityController.text;
    String price = priceController.text;
    String image = base64Encode(_image!.readAsBytesSync());
    // log(image);
    http.post(
        Uri.parse("${MyConfig.servername}/mymemberlink/api/insert_product.php"),
        body: {
          "name": name,
          "description": description,
          "price": price,
          "quantity": quantity,
          "image": image
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // log(response.body);
        if (data['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Success"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
