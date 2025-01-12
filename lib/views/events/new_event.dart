import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../myconfig.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({super.key});

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  String startDateTime = "", endDateTime = "";
  String eventtypevalue = 'Conference';
  var selectedStartDateTime, selectedEndDateTime;

  var items = [
    'Conference',
    'Exibition',
    'Seminar',
    'Hackathon',
  ];
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
          title: const Text("New Event"),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                elevation: 4.0, // Adds a shadow for a lifted look
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded edges
                ),
                child: Padding(
                    padding: const EdgeInsets.all(
                        16.0), // Add padding inside the card
                    child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                                : FileImage(_image!)
                                                    as ImageProvider),
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    hintText: "Event Title",
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      child: Column(
                                        children: [
                                          const Text("Select Start Date"),
                                          Text(startDateTime.isNotEmpty
                                              ? startDateTime
                                              : "Not selected"),
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
                                                selectedStartDateTime =
                                                    DateTime(
                                                  selectedDate.year,
                                                  selectedDate.month,
                                                  selectedDate.day,
                                                  selectTime.hour,
                                                  selectTime.minute,
                                                );
                                                var formatter = DateFormat(
                                                    'dd-MM-yyyy hh:mm a');
                                                String formattedDate =
                                                    formatter.format(
                                                        selectedStartDateTime);
                                                startDateTime =
                                                    formattedDate.toString();
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
                                          Text(endDateTime.isNotEmpty
                                              ? endDateTime
                                              : "Not selected"),
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
                                                var formatter = DateFormat(
                                                    'dd-MM-yyyy hh:mm a');
                                                String formattedDate =
                                                    formatter.format(
                                                        selectedEndDateTime);
                                                endDateTime =
                                                    formattedDate.toString();
                                                setState(() {});
                                              }
                                            });
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  validator: (value) =>
                                      value!.isEmpty ? "Enter Location" : null,
                                  controller: locationController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      hintText: "Event Location"),
                                ),
                                const SizedBox(height: 10),
                                DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    labelStyle: TextStyle(),
                                  ),
                                  value: eventtypevalue,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      eventtypevalue = newValue!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  validator: (value) => value!.isEmpty
                                      ? "Enter Description"
                                      : null,
                                  controller: descriptionController,
                                  maxLines: 10,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      hintText: "Event Description"),
                                ),
                                const SizedBox(height: 10),
                                MaterialButton(
                                  elevation: 10,
                                  onPressed: () {
                                    if (!_formKey.currentState!.validate()) {
                                      print("still here");
                                      return;
                                    }
                                    if (_image == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("Please take photo"),
                                              backgroundColor: Colors.red));
                                      return;
                                    }
                                    double filesize = getFileSize(_image!);

                                    if (filesize > 100) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Image size too large"),
                                        backgroundColor: Colors.red,
                                      ));
                                      return;
                                    }

                                    if (startDateTime == "" ||
                                        endDateTime == "") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Please select start/end date"),
                                        backgroundColor: Colors.red,
                                      ));
                                      return;
                                    }

                                    insertEventDialog();
                                  },
                                  minWidth: screenWidth,
                                  height: 50,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  child: Text(
                                    "Insert",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ])))));
  }

  void showSelectionDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
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
                  child: const Text("Gallery"),
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
                  child: const Text("Camera"),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectfromCamera(),
                  },
                ),
              ],
            ),
          );
        });
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

  Future<void> _selectfromCamera() async {
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

  void insertEventDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Insert Event",
              style: TextStyle(),
            ),
            content: const Text("Are you sure ?", style: TextStyle()),
            actions: [
              TextButton(
                onPressed: () {
                  insertEvent();
                  Navigator.of(context).pop();
                },
                child: const Text("Yes", style: TextStyle()),
              )
            ],
          );
        });
  }

  void insertEvent() {
    String title = titleController.text;
    String location = locationController.text;
    String description = descriptionController.text;
    String start = selectedStartDateTime.toString();
    String end = selectedEndDateTime.toString();
    String image = base64Encode(_image!.readAsBytesSync());

    http.post(
        Uri.parse("${MyConfig.servername}/mymemberlink/api/insert_event.php"),
        body: {
          "title": title,
          "location": location,
          "description": description,
          "eventtype": eventtypevalue,
          "start": start,
          "end": end,
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Server Error: ${response.statusCode}"),
          backgroundColor: Colors.red,
        ));
      }
    }).catchError((error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $error"),
        backgroundColor: Colors.red,
      ));
    });
  }
}
