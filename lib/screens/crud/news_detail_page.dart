import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tile/models/berita.dart';
import 'package:tile/services/database_helper.dart';
import 'dart:io';

class NewsDetailPage extends StatelessWidget {
  final Berita berita;
  late final DatabaseHelper _databaseHelper;

  NewsDetailPage({Key? key, required this.berita}) : super(key: key) {
    _databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(berita.judul),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNewsImage(),
              const SizedBox(height: 20),
              _buildNewsDetails(),
              const SizedBox(height: 20),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsImage() {
    return berita.imagePath.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(berita.imagePath),
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          )
        : Container(
            width: double.infinity,
            height: 250,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.image,
                color: Colors.white,
                size: 50,
              ),
            ),
          );
  }

  Widget _buildNewsDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Favorit: ${berita.favorit}',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'Deskripsi:',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          berita.deskripsi,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () async {
                await _showUpdateDialog(context);
              },
              child: Text('Update'),
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              await _confirmDelete(context);
            },
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ),
      ],
    );
  }

  Future<void> _showUpdateDialog(BuildContext context) async {
    final TextEditingController judulController = TextEditingController(text: berita.judul);
    final TextEditingController deskripsiController = TextEditingController(text: berita.deskripsi);
    final TextEditingController favoritController = TextEditingController(text: berita.favorit.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Berita', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judulController,
                  decoration: InputDecoration(labelText: 'Judul'),
                ),
                TextField(
                  controller: favoritController,
                  decoration: InputDecoration(labelText: 'Favorit'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: deskripsiController,
                  decoration: InputDecoration(labelText: 'Deskripsi'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                final updatedBerita = Berita(
                  id: berita.id,
                  judul: judulController.text,
                  imagePath: berita.imagePath,
                  favorit: int.parse(favoritController.text),
                  deskripsi: deskripsiController.text,
                );
                await _databaseHelper.updateBerita(updatedBerita);
                Navigator.of(context).pop();
              },
              child: Text('Update', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin menghapus artikel berita ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await _databaseHelper.deleteBerita(berita.id!);
        print('Berita dengan ID ${berita.id} berhasil dihapus');
        Navigator.of(context).pop(); // Tutup halaman detail
      } catch (e) {
        print('Error menghapus berita: $e');
      }
    }
  }
}
