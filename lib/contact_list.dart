/// contact_list.dart
///
/// File ini berisi implementasi widget ContactList, yang menampilkan daftar kontak yang diambil dari database.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hahahaha/mydrawal.dart';

import 'colors.dart';
import 'db_manager.dart';

/// Widget ContactList menampilkan daftar kontak.
class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

/// State dari ContactList yang berisi logika dan tampilan daftar kontak.
class _ContactListState extends State<ContactList> {
  /// Instance dari DatabaseHelper untuk interaksi dengan database.
  final dbHelper = DatabaseHelper.instance;

  /// List berisi data kategori kontak.
  List<Map<String, dynamic>> allCategoryData = [];

  /// Metode initState dipanggil saat widget pertama kali dibuat.
  @override
  void initState() {
    super.initState();
    _query();
  }

  /// Metode build merender tampilan daftar kontak.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawal(),
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          title: Text("Daftar Kontak"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: allCategoryData.length,
                padding: EdgeInsets.zero,
                itemBuilder: (_, index) {
                  var item = allCategoryData[index];
                  Uint8List bytes = base64Decode(item['profile']);
                  return Container(
                    color: MyColors.orangeTile,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            CircleAvatar(
                              child: Image.memory(
                                bytes,
                                fit: BoxFit.cover,
                              ),
                              minRadius: 20,
                              maxRadius: 25,
                            ),
                            Text("${item['name']}"),
                            Text("${item['lname']}"),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                // Handle edit action
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                _delete(item['_id']);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                        const Divider(
                          color: MyColors.orangeDivider,
                          thickness: 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Metode _query mengambil semua baris dari database dan memperbarui daftar kategori.
  void _query() async {
    final allRows = await dbHelper.queryAllRowsofContact();
    print('query all rows:');
    allRows.forEach(print);
    allCategoryData = allRows;
    setState(() {});
  }

  /// Metode _delete menghapus kontak berdasarkan ID dari database.
  void _delete(int id) async {
    final rowsDeleted = await dbHelper.deleteContact(id);
    print('deleted $rowsDeleted row(s): row $id');
    _query();
  }
}
