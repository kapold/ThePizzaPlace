import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:pizza_place_app/utils/DbHandler.dart';

import '../models/Pizza.dart';
import '../utils/AppColor.dart';
import '../utils/Utils.dart';
import '../widgets/ImageContainer.dart';

class AddPizzaPage extends StatefulWidget {
  const AddPizzaPage({Key? key}) : super(key: key);

  @override
  State<AddPizzaPage> createState() => _AddPizzaPageState();
}

class _AddPizzaPageState extends State<AddPizzaPage> {
  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  bool isLoading = false;
  String name = "", description = "", price = "";
  File? image;
  final storageRef = FirebaseStorage.instance.ref();
  PlatformFile? file;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    nameCtrl.addListener(updateTextValue);
    descriptionCtrl.addListener(updateTextValue);
    priceCtrl.addListener(updateTextValue);

  }

  void updateTextValue() {
    setState(() {
      name = nameCtrl.text;
      description = descriptionCtrl.text;
      price = priceCtrl.text;
    });
  }

  Future pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null){
      file = result.files.single;
      print("selected");
    }
  }

  bool _isValidInfo() {
    if (name.isEmpty || description.isEmpty || price.isEmpty)
      return false;
    return true;
  }

  Future<void> _uploadImage() async {
    try {
      var ref = storageRef.child("images/${DateTime.now()}.jpg");
      var fileBytes = file?.bytes;
      ref.putData(fileBytes!);

    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<String> _getImageUrl() async {
    String img = "";
    FirebaseStorage.instance.ref().child("images/leonardo.jpeg").getDownloadURL().then((value){
      img = value;
    });
    return img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить продукт')
      ),
      body: Container(
          padding: EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
          child: SafeArea(
            child: Column(
                children: [
                  Expanded(
                      child: Column(
                          children: [
                            TextField(
                                controller: nameCtrl,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      borderSide: const BorderSide(color: Colors.grey),
                                    ),
                                    prefixIcon: Container(
                                        child: Icon(Icons.abc),
                                        padding: EdgeInsets.only(left: 16, right: 16)
                                    ),
                                    hintText: "Название"
                                )
                            ),
                            SizedBox(height: 20),
                            TextField(
                                controller: descriptionCtrl,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      borderSide: const BorderSide(color: Colors.grey),
                                    ),
                                    prefixIcon: Container(
                                        child: Icon(Icons.description),
                                        padding: EdgeInsets.only(left: 16, right: 16)
                                    ),
                                    hintText: "Описание"
                                )
                            ),
                            SizedBox(height: 20),
                            TextField(
                                controller: priceCtrl,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      borderSide: const BorderSide(color: Colors.grey),
                                    ),
                                    prefixIcon: Container(
                                        child: Icon(Icons.price_change),
                                        padding: EdgeInsets.only(left: 16, right: 16)
                                    ),
                                    hintText: "Цена"
                                )
                            ),
                            SizedBox(height: 20),
                            TextButton(
                                onPressed: () async {
                                  // pickImage();
                                  // final task = FirebaseStorageWeb.instance.ref().child('path/to/image').putBlob(blob);
                                },
                                child: Text(
                                  'Выбрать картинку',
                                  style: TextStyle(
                                      color: AppColor.pumpkin,
                                      fontSize: 16
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                        side: BorderSide(color: AppColor.pumpkin)
                                    ),
                                    padding: EdgeInsets.only(top: 20, bottom: 20, right: 100, left: 100)
                                )
                            ),
                            SizedBox(height: 40),
                            ImageContainer(
                              imageLocator: "images/leonardo.jpeg"
                            )
                          ]
                      )
                  ),
                  TextButton(
                      onPressed: isLoading ?
                        null :
                        () async {
                          setState(() { isLoading = true; });
                          _uploadImage();

                          if (_isValidInfo()) {
                            await DbHandler.addPizza(
                              new Pizza(
                                name: name,
                                description: description,
                                price: double.tryParse(price),
                                image: "none"
                              ),
                              context
                            );
                            Utils.showAlertDialog(context, "Товар успешно добавлен");
                            setState(() {
                              name = "";
                              description = "";
                              price = "";
                              nameCtrl.text = "";
                              descriptionCtrl.text = "";
                              priceCtrl.text = "";
                            });
                          }
                          else {
                            Utils.showAlertDialog(context, "Проверьте валидность данных");
                            return;
                          }
                          setState(() { isLoading = false; });
                        },
                      child: isLoading ?
                        CircularProgressIndicator(color: Colors.white) :
                        Text(
                          'Добавить продукт',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                          )
                        ),
                      style: TextButton.styleFrom(
                          backgroundColor: AppColor.pumpkin,
                          padding: EdgeInsets.only(top: 14, bottom: 14, right: 64, left: 64)
                      )
                  )
                ]
            )
          )
        )
    );
  }
}