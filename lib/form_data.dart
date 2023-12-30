import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'database/db_helper.dart';
import 'model/data.dart';
import 'package:image_picker/image_picker.dart';

class FormData extends StatefulWidget {
  final Data? data;

  FormData({this.data});

  @override
  _FormDataState createState() => _FormDataState();
}

class _FormDataState extends State<FormData> {
  DbHelper dbHelper = DbHelper();

  TextEditingController? namaController;
  TextEditingController? nimController;
  TextEditingController? nohpController;
  TextEditingController? alamatController;

  Uint8List? _imageBytes;

  @override
  void initState() {
    namaController = TextEditingController(text: widget.data?.nama ?? '');
    nimController = TextEditingController(text: widget.data?.nim ?? '');
    nohpController = TextEditingController(text: widget.data?.nohp ?? '');
    alamatController = TextEditingController(text: widget.data?.alamat ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Data Mahasiswa'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          GestureDetector(
            onTap: _getImageFromGallery,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 50,
                child: _imageBytes != null
                    ? ClipOval(
                        child: Image.memory(
                          _imageBytes!,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.blue,
                      ),
              ),
            ),
          ),
          _buildTextField(namaController, 'Nama', 'Masukkan nama'),
          _buildTextField(nimController, 'NIM', 'Masukkan NIM'),
          _buildTextField(nohpController, 'No. HP', 'Masukkan nomor HP'),
          _buildTextField(alamatController, 'Alamat', 'Masukkan alamat'),
          ElevatedButton(
            onPressed: () async {
              await _saveDataToDatabase();
            },
            child: widget.data == null
                ? Text('Tambah', style: TextStyle(color: Colors.white))
                : Text('Perbarui', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController? controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
    );
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _saveDataToDatabase() async {
    try {
      // Membuat objek Data dari nilai-nilai yang dimasukkan dalam form
      Data newData = Data(
        nama: namaController!.text,
        nim: nimController!.text,
        nohp: nohpController!.text,
        alamat: alamatController!.text,
        imageBytes: _imageBytes ?? Uint8List(0),
      );

      if (widget.data == null) {
        await dbHelper.saveDataWithImage(newData);
        Navigator.pop(context, 'save');
      } else {
        newData.id = widget.data!.id;
        await dbHelper.updateDataWithImage(newData);
        Navigator.pop(context, 'update');
      }
    } catch (e) {
      _showErrorDialog("Error saving data", e.toString());
      print("Error saving data to database: $e");
      // Tambahkan penanganan kesalahan sesuai kebutuhan aplikasi Anda
      // Contoh: menampilkan pesan kesalahan kepada pengguna, logging, dsb.
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    namaController?.dispose();
    nimController?.dispose();
    nohpController?.dispose();
    alamatController?.dispose();
    super.dispose();
  }
}
