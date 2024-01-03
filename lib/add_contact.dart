/// ignore_for_file: prefer_const_constructors

/// Import paket dan modul yang diperlukan
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hahahaha/contact_list.dart';
import 'package:hahahaha/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

/// Import modul kustom
import 'db_manager.dart';
import 'mydrawal.dart';

/// Tentukan Flutter StatefulWidget untuk menambahkan kontak
class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

/// Tentukan state untuk widget AddContact
class _AddContactState extends State<AddContact> {
  /// Kontroller untuk bidang teks
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _emailAddress = TextEditingController();

  /// Global key untuk formulir
  final formGlobalKey = GlobalKey<FormState>();

  /// Berkas untuk menyimpan gambar yang dipilih
  File? imageFile;

  /// Instance ImagePicker
  final ImagePicker _picker = ImagePicker();

  /// String untuk menyimpan kategori saat ini
  String currentCategory = "";

  /// Variabel untuk menyimpan gambar yang dienkripsi base64
  var imageEncoded;

  /// List untuk menyimpan semua data kategori
  List<String> allCategoryData = [];

  /// Instance DatabaseHelper
  final dbHelper = DatabaseHelper.instance;

  /// Future untuk menyimpan byte gambar
  late Future<Uint8List> imageBytes;

  /// Controller tanda tangan untuk menangani input tanda tangan
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
  );

  /// Inisialisasi state
  @override
  void initState() {
    super.initState();
    _query();
    // Inisialisasi widget tanda tangan
    var _signatureCanvas = Signature(
      controller: _controller,
      width: 300,
      height: 300,
      backgroundColor: Colors.lightBlueAccent,
    );
  }

  /// Metode untuk membangun widget
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawal(),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          centerTitle: true,
          title: Text("Tambah Kontak"),
        ),
        body: ListView(
          children: [
            // Form untuk memasukkan detail kontak
            SizedBox(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formGlobalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      // Widget pemilihan gambar
                      InkWell(
                        onTap: () async {
                          // Buka galeri untuk memilih gambar
                          final XFile? pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery);

                          // Jika gambar dipilih, perbarui status
                          if (pickedFile != null) {
                            imageBytes = pickedFile.readAsBytes();
                            setState(() {
                              imageFile = File(pickedFile.path);
                            });
                          }
                        },
                        child: imageFile == null
                            ? CircleAvatar(
                                backgroundColor: MyColors.primaryColor,
                                minRadius: 50,
                                child: Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: Image.file(
                                  imageFile!,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ).image,
                                minRadius: 100,
                              ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Bidang teks untuk nama depan
                      TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.primaryColor, width: 1.0),
                          ),
                          hintText: 'Nama Depan',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        controller: _firstName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan Nama Depan';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Bidang teks untuk nama belakang
                      TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.primaryColor, width: 1.0),
                          ),
                          hintText: 'Nama Belakang',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        controller: _lastName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan Nama Belakang';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Bidang teks untuk nomor ponsel
                      TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.primaryColor, width: 1.0),
                          ),
                          hintText: 'Nomor Ponsel',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        controller: _mobileNumber,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan Nomor Ponsel';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Bidang teks untuk alamat email
                      TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.primaryColor, width: 1.0),
                          ),
                          hintText: 'Alamat Email',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        controller: _emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan Alamat Email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Dropdown untuk memilih kategori
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: MyColors.primaryColor),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            items: allCategoryData.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (selectedItem) => setState(() {
                              currentCategory = selectedItem!;
                            }),
                            hint: Text("Pilih Kategori "),
                            value: currentCategory.isEmpty
                                ? null
                                : currentCategory,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Tombol Simpan
                      TextButtonTheme(
                        data: TextButtonThemeData(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                MyColors.primaryColor),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (formGlobalKey.currentState!.validate()) {
                              _insert();
                            }
                          },
                          child: const Text(
                            "Simpan",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Metode untuk menyisipkan kontak ke dalam database
  void _insert() async {
    var base64image;
    // Periksa apakah imageFile ada
    if (imageFile?.exists() != null) {
      // Enkode gambar ke base64
      base64image = base64Encode(imageFile!.readAsBytesSync().toList());
    }

    // Baris untuk disisipkan ke dalam database
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: _firstName.text,
      DatabaseHelper.columnLName: _lastName.text,
      DatabaseHelper.columnMobile: _mobileNumber.text,
      DatabaseHelper.columnEmail: _emailAddress.text,
      DatabaseHelper.columnCategory: currentCategory,
      DatabaseHelper.columnProfile: base64image,
    };
    print('Memulai penyisipan');
    currentCategory = "";

    // Sisipkan baris ke dalam database
    final id = await dbHelper.insertContact(row);
    if (kDebugMode) {
      print('Baris berhasil disisipkan: $id');
    }
    // Perbarui daftar kategori dan navigasi ke layar daftar kontak
    _query();
    Navigator.push(context, MaterialPageRoute(builder: (_) => ContactList()));
  }

  /// Metode untuk mengambil semua baris dari database
  void _query() async {
    // Ambil semua baris dari database
    final allRows = await dbHelper.queryAllRows();
    if (kDebugMode) {
      print('Mengambil semua baris:');
    }
    // Perbarui daftar kategori
    for (var element in allRows) {
      allCategoryData.add(element["name"]);
    }
    setState(() {});
  }
}
