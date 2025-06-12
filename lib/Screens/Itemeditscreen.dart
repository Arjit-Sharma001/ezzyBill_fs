// import 'package:ezzybill/DataBase/dbHelper.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezzybill/consts/consts.dart';
import 'package:ezzybill/consts/list.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FoodItem {
  final String name;
  final int price;

  FoodItem({
    required this.name,
    required this.price,
  });
}

class ItemEditScreen extends StatefulWidget {
  @override
  State<ItemEditScreen> createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends State<ItemEditScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageURLController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  String? _selectedCategory;
  String? _selectedImage; // Default image

  // Future<void> addItem() async {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("ERRorrrrrrrrrrr")),
  //   );
  // }
  File? _pickedImage;
  String? imageUrl;

  Future<void> pickAndUploadImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });

      final fileName = picked.name;
      final destination = 'food_images/$fileName';

      try {
        final ref = FirebaseStorage.instance.ref(destination);
        ref.putFile(_pickedImage!);
        final url = await ref.getDownloadURL();

        setState(() {
          imageUrl = url;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("hello $imageUrl error : $e")),
        );
        print('Image upload failed: $e');
      }
    }
  }

//Firebase Database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addItem() async {
    String name = nameController.text.trim();
    String priceText = priceController.text.trim();
    String? category = _selectedCategory;

    if (name.isEmpty || priceText.isEmpty || category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    int? price = int.tryParse(priceText);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid price value")),
      );
      return;
    }

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please upload an image")),
      );
    }

    try {
      await _firestore.collection('food_items').add({
        'name': name,
        'price': price,
        'image_url': imageUrl ?? "",
        'category': category,
        'createdAt': Timestamp.now(), // optional
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item added to Firebase")),
      );

      // Clear input fields
      nameController.clear();
      priceController.clear();
      setState(() {
        _selectedCategory = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

// FOR SQL LOCAL DATABASE

  // DataBaseHelper.instance.insertRecord({
  //   DataBaseHelper.columnName: nameController.text,
  //   DataBaseHelper.price: int.parse(priceController.text),
  // });

// List<Map<String, dynamic>> foodItemList = await DataBaseHelper.instance.queryDatabase();

//     // print(FooditemListtt);
//     String items = foodItemList.map((item) => "${foodItemList.name} - ₹${foodItemList.price}")
//         .join("\n");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(FooditemListtt )),
//     );

  // void addItem() {
  //   String name = nameController.text.trim();
  //   String priceText = priceController.text.trim();

  //   if (name.isNotEmpty && priceText.isNotEmpty) {
  //     int price = int.tryParse(priceText) ?? 0;

  //     setState(() {
  //       FooditemListtt.add(FoodItem(name: name, price: price));
  //     });

  //     // Clear input fields
  //     nameController.clear();
  //     priceController.clear();
  //   }
  //   String items = FooditemListtt.map((item) => "${item.name} - ₹${item.price}")
  //       .join("\n");

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(items)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var _image = null;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("New Edit         ",
              style: TextStyle(
                color: primaryColor,
                fontSize: screenWidth * 0.06,
              )),
        ),
        backgroundColor: secondaryColor,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          width: screenWidth * 0.8,
          height: screenHeight * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(2, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
// Image picker
              GestureDetector(
                onTap: () {
                  pickAndUploadImage();
                },
                child: Container(
                  width: double.infinity,
                  height: screenHeight * 0.25, // Responsive image height
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black87),
                  ),
                  child: _image == null
                      ? Image.asset(
                          icUploadImage,
                          color: Colors.grey,
                          fit: BoxFit.contain,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(imgfood1, fit: BoxFit.cover),
                        ),
                ),
              ),

              SizedBox(height: 20),
// Item Name Input Field
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: itemNameHint, // This acts as the floating label
                  labelStyle: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: secondaryColor, // Change color as needed
                    fontFamily: semibold,
                  ),
                  floatingLabelBehavior:
                      FloatingLabelBehavior.auto, // Moves up when typing
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: secondaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100], // Light background
                ),
                // keyboardType: TextInputType.number, // Shows number keyboard
              ),
              SizedBox(height: 10),

              // Price Section
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: mrpHint, // This acts as the floating label
                        labelStyle: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: secondaryColor, // Change color as needed
                          fontFamily: semibold,
                        ),
                        floatingLabelBehavior:
                            FloatingLabelBehavior.auto, // Moves up when typing
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: secondaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100], // Light background
                      ),
                      keyboardType:
                          TextInputType.number, // Shows number keyboard
                    ),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Item Category",
                        labelStyle: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: secondaryColor,
                          fontFamily: semibold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: secondaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      hint: Row(
                        children: [
                          Text(
                            "Select",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: secondaryColor, // Change color as needed
                              fontFamily: semibold,
                            ),
                          ), // Hint Text
                        ],
                      ),
                      items: FoodCatagoryList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [Text(value)],
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Spacer(),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await addItem();
                  },
                  // onPressed: () async {
                  //   await DataBaseHelper.instance.insertRecord({
                  //     DataBaseHelper.columnName: nameController.text,
                  //     DataBaseHelper.price: int.parse(priceController.text),
                  //   });
                  // },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Add Item",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
