import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tile/providers/auth_provider.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background hitam elegan
          Container(
            color: Colors.black,
          ),
          Center(
            child: FutureBuilder<DocumentSnapshot>(
              future: authProvider.getUserData(), // Ambil data pengguna
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading user data'));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('User not found'));
                }

                // Ambil data pengguna dari snapshot
                var userData = snapshot.data!.data() as Map<String, dynamic>;

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: const NetworkImage(
                            'https://via.placeholder.com/150'), // Placeholder gambar profil
                      ),
                      const SizedBox(height: 20),
                      Text(
                        userData['username'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userData['email'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.white), // Mengubah warna ikon menjadi putih
                        title: Text('Nomor Telepon', style: TextStyle(color: Colors.white)),
                        subtitle: Text('+62 812 3456 7890', style: TextStyle(color: Colors.grey)), // Update sesuai data Anda
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on, color: Colors.white), // Mengubah warna ikon menjadi putih
                        title: Text('Alamat', style: TextStyle(color: Colors.white)),
                        subtitle: Text('Jl. Contoh Alamat, Sukabumi, Indonesia', style: TextStyle(color: Colors.grey)), // Update sesuai data Anda
                      ),
                      ListTile(
                        leading: Icon(Icons.calendar_today, color: Colors.white), // Mengubah warna ikon menjadi putih
                        title: Text('Tanggal Bergabung', style: TextStyle(color: Colors.white)),
                        subtitle: Text('10 Januari 2025', style: TextStyle(color: Colors.grey)), // Update sesuai data Anda
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Menambahkan AppBar kustom di bagian atas
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true, // Mengatur agar judul berada di tengah
              title: const Text(
                'Profile Pengguna',
                style: TextStyle(color: Colors.white),
              ),
              leading: Container(), // Menghilangkan tombol back
            ),
          ),
        ],
      ),
    );
  }
}
