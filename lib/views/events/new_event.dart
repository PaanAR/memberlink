import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({super.key});

  @override
  State<NewEventScreen> createState() => _NewEventState();
}

class _NewEventState extends State<NewEventScreen> {
  String startDateTime = "", endDateTime = "";
  var selectedStartDateTime, selectedEndDateTime;
  late double screenWidth, screenHeight;

  File? _image;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Events",
          style: GoogleFonts.monoton(color: const Color(0xFFF4F3EE)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF463F3A), // Dark brown
        iconTheme: const IconThemeData(
          color: Color(0xFFF4F3EE), // Light cream for back arrow
        ),
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
                                    ? const AssetImage(
                                        "assets/images/camera.png")
                                    : FileImage(_image!) as ImageProvider),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.grey),
                          ),
                          height: screenHeight * 0.4),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "Enter Title" : null,
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        filled: true,
                        fillColor: Color(0xFFBCB8B1), // Greyish beige
                        hintText: "Event Title",
                        hintStyle: TextStyle(color: Color(0xFF8A817C)), // Taupe
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          child: Column(
                            children: [
                              const Text("Select Start Date"),
                              Text(startDateTime)
                            ],
                          ),
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2030),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((selectTime) {
                                  if (selectTime != null) {
                                    selectedStartDateTime = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectTime.hour,
                                      selectTime.minute,
                                    );
                                    print(selectedStartDateTime.toString());
                                    var formatter =
                                        DateFormat('dd-MM-yyyy hh:mm a');
                                    String formattedDate =
                                        formatter.format(selectedStartDateTime);
                                    startDateTime = formattedDate.toString();
                                    setState(() {});
                                  }
                                });
                              }
                            });
                          },
                        ),
                        GestureDetector(
                          child: Column(
                            children: [
                              const Text("Select End Date"),
                              Text(endDateTime)
                            ],
                          ),
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2030),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((selectTime) {
                                  if (selectTime != null) {
                                    selectedEndDateTime = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectTime.hour,
                                      selectTime.minute,
                                    );
                                    var formatter =
                                        DateFormat('dd-MM-yyyy hh:mm a');
                                    String formattedDate =
                                        formatter.format(selectedEndDateTime);
                                    endDateTime = formattedDate.toString();
                                    print(endDateTime);
                                    print(selectedEndDateTime);
                                    setState(() {});
                                  }
                                });
                              }
                            });
                          },
                        )
                      ],
                    )
                  ],
                ))
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
              "Select from",
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
      // setState(() {
      //   _image = File(pickedFile.path);
      // });
      cropImage();
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
      ],
    );
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

  Future<void> _selectfromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    print("BEFORE CROP: ");
    print(getFileSize(_image!));
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      // setState(() {
      //   _image = File(pickedFile.path);
      // });
      cropImage();
    } else {}
  }
}
