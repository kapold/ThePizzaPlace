import 'package:flutter/material.dart';
import 'package:pizza_place_app/utils/DbHandler.dart';

import '../models/Address.dart';
import '../utils/AppColor.dart';
import '../utils/Utils.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({Key? key}) : super(key: key);

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  final addressCtrl = TextEditingController();
  String address = "";

  @override
  void initState() {
    super.initState();
    addressCtrl.addListener(updateTextValue);
  }

  void updateTextValue() {
    setState(() {
      address = addressCtrl.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Адреса'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: addressCtrl,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        prefixIcon: Container(
                            child: Icon(Icons.location_pin),
                            padding: EdgeInsets.only(left: 16, right: 16)
                        ),
                        hintText: "Новый адрес",
                    ),
                  )
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    String address = addressCtrl.text.trim();
                    if (address.isNotEmpty) {
                      await DbHandler.addAddress(new Address(user_id: Utils.currentUser?.id, address: address), context);
                      addressCtrl.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Адрес `${address}` добавлен'),
                        ),
                      );
                      Utils.userAddresses = await DbHandler.getUserAddresses(Utils.currentUser?.id, context);
                    }
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          side: BorderSide(color: AppColor.pumpkin)
                      ),
                      padding: EdgeInsets.only(top: 24, bottom: 24),
                      backgroundColor: Colors.white
                  ),
                  child: Icon(Icons.add, color: AppColor.pumpkin)
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text("Свайп для удаления адреса"),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: Utils.userAddresses.length,
              itemBuilder: (BuildContext context, int index) {
                final Address item = Utils.userAddresses[index];
                return Dismissible(
                  key: Key(item.address.toString()),
                  onDismissed: (direction) async {
                    await DbHandler.deleteUserAddress(item.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Адрес `${item.address.toString()}` удален'),
                      ),
                    );
                  },
                  background: Container(
                    color: AppColor.pumpkin,
                    child: Icon(Icons.delete),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(right: 24, left: 24),
                    title: Text(item.address.toString()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}