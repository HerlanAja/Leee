import 'package:flutter/material.dart';
import 'package:tile/models/berita.dart';
import 'package:tile/services/database_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddBeritaScreen extends StatefulWidget {
  const AddBeritaScreen({Key? key}) : super(key: key);

  @override
  _AddBeritaScreenState createState() => _AddBeritaScreenState();
}

class _AddBeritaScreenState extends State<AddBeritaScreen> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveBerita() async {
    if (_judulController.text.isEmpty || _deskripsiController.text.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom harus diisi!')),
      );
      return;
    }

    final berita = Berita(
      judul: _judulController.text,
      imagePath: _image!.path,
      favorit: 0,
      deskripsi: _deskripsiController.text,
    );

    await DatabaseHelper().insertBerita(berita);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Berita'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _judulController,
                      decoration: InputDecoration(
                        labelText: 'Judul Berita',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: _image == null
                          ? Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: const Center(
                                child: Text(
                                  'Pilih Gambar',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _image!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _deskripsiController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: _saveBerita,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
