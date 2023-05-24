import 'package:http/http.dart' as http;

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pizza_place_app/utils/DbHandler.dart';

import '../models/Pizza.dart';
import '../utils/AppColor.dart';
import '../utils/Utils.dart';

class AddPizzaPage extends StatefulWidget {
  const AddPizzaPage({Key? key}) : super(key: key);

  @override
  State<AddPizzaPage> createState() => _AddPizzaPageState();
}

class _AddPizzaPageState extends State<AddPizzaPage> {
  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final imageCtrl = TextEditingController();
  bool isLoading = false;
  String name = "", description = "", price = "", image = "";
  final storageRef = FirebaseStorage.instance.ref();
  PlatformFile? file;
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    nameCtrl.addListener(updateTextValue);
    descriptionCtrl.addListener(updateTextValue);
    priceCtrl.addListener(updateTextValue);
    imageCtrl.addListener(updateTextValue);
  }

  Future<void> _uploadImage() async {
    try {
      var ref = storageRef.child("images/${DateTime.now()}.jpg");
      var fileBytes = file?.bytes;
      ref.putData(fileBytes!);
    }
    on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null){
      file = result.files.single;
      print("selected");
    }
  }

  void updateTextValue() {
    setState(() {
      name = nameCtrl.text;
      description = descriptionCtrl.text;
      price = priceCtrl.text;
    });
  }

  bool _isValidInfo() {
    if (name.isEmpty || description.isEmpty || price.isEmpty)
      return false;
    return true;
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
                            TextField(
                                controller: imageCtrl,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      borderSide: const BorderSide(color: Colors.grey),
                                    ),
                                    prefixIcon: Container(
                                        child: Icon(Icons.image),
                                        padding: EdgeInsets.only(left: 16, right: 16)
                                    ),
                                    hintText: "Ссылка на картинку"
                                )
                            ),

                            // TextButton(
                            //     onPressed: () async {
                            //       pickImage();
                            //     },
                            //     child: Text(
                            //       'Выбрать картинку',
                            //       style: TextStyle(
                            //           color: AppColor.pumpkin,
                            //           fontSize: 16
                            //       ),
                            //     ),
                            //     style: TextButton.styleFrom(
                            //         shape: RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.circular(50.0),
                            //             side: BorderSide(color: AppColor.pumpkin)
                            //         ),
                            //         padding: EdgeInsets.only(top: 20, bottom: 20, right: 100, left: 100)
                            //     )
                            // ),

                            // Image.network(
                            //   "https://dodopizza-a.akamaihd.net/static/Img/Products/f05b3d7ed33647a985d383d68a94bf09_366x366.webp",
                            //   scale: 2,
                            //   fit: BoxFit.fill,
                            //   loadingBuilder: (BuildContext context, Widget child,
                            //       ImageChunkEvent? loadingProgress) {
                            //     if (loadingProgress == null) return child;
                            //     return Center(
                            //       child: CircularProgressIndicator(
                            //         value: loadingProgress.expectedTotalBytes != null
                            //             ? loadingProgress.cumulativeBytesLoaded /
                            //             loadingProgress.expectedTotalBytes!
                            //             : null,
                            //       ),
                            //     );
                            //   },
                            // )
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
                                image: imageCtrl.text
                              ),
                              context
                            );
                            Utils.showAlertDialog(context, "Товар успешно добавлен");
                            setState(() {
                              name = "";
                              description = "";
                              price = "";
                              image = "";
                              nameCtrl.text = "";
                              descriptionCtrl.text = "";
                              priceCtrl.text = "";
                              imageCtrl.text = "";
                            });
                          }
                          else {
                            Utils.showAlertDialog(context, "Проверьте валидность данных");
                            setState(() { isLoading = false; });
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