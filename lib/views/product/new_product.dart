import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlinks/myconfig.dart';

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
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Product"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showSelectionDialog();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: _image == null
                                ? const AssetImage("assets/images/camera.png")
                                : FileImage(_image!) as ImageProvider),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.grey),
                      ),
                      height: screenHeight * 0.4,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "Enter Product Name" : null,
                      controller: nameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          hintText: "Product Name")),
                  const SizedBox(height: 10),
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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: "Product Description",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        icon: const Icon(Icons.remove),
                      ),

                      // Quantity input field with validator
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
                          onChanged: (value) {
                            setState(() {
                              int? newQuantity = int.tryParse(value);
                              if (newQuantity == null || newQuantity <= 0) {
                                quantityController.text =
                                    "1"; // Reset to 1 if invalid
                              }
                            });
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
                        icon: const Icon(Icons.add),
                      ),

                      // Price input field with validator
                      Expanded(
                        child: TextFormField(
                          controller: priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Book price must contain value";
                            }
                            if (double.tryParse(value) == null ||
                                double.parse(value) <= 0) {
                              return "Enter a valid number";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: '  Price',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.money),
                            prefixText: "   RM ",
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  MaterialButton(
                    elevation: 10,
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        print("STILL HERE");
                        return;
                      }
                      if (_image == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Please take a photo"),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }
                      double filesize = getFileSize(_image!);
                      print(filesize);

                      if (filesize > 100) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Image size too large"),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }
                      insertProductDialog();
                    },
                    minWidth: screenWidth,
                    height: 50,
                    color: Theme.of(context).colorScheme.secondary,
                    child: Text("Insert",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        )),
                  )
                ],
              ),
            )
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
                  Navigator.of(context).pop();
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
