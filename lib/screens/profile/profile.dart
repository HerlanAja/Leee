import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tile/providers/auth_provider.dart';
import 'package:tile/screens/auth/login.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient biru ke hitam untuk nuansa modern
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: FutureBuilder<DocumentSnapshot>(
              future: authProvider.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading user data',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(
                    child: Text(
                      'User not found',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  );
                }

                // Ambil data pengguna
                var userData = snapshot.data!.data() as Map<String, dynamic>;

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: const NetworkImage(
                            'https://via.placeholder.com/150'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        userData['username'],
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userData['email'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ListTile(
                        leading: const Icon(Icons.phone, color: Colors.white),
                        title: Text(
                          'Nomor Telepon',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        subtitle: Text(
                          '+62 812 3456 7890',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.location_on, color: Colors.white),
                        title: Text(
                          'Alamat',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Jl. Contoh Alamat, Sukabumi, Indonesia',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_today,
                            color: Colors.white),
                        title: Text(
                          'Tanggal Bergabung',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        subtitle: Text(
                          '10 Januari 2025',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20), // Jarak sebelum ikon logout
                      // Ikon Logout di bawah tanggal bergabung
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white, size: 30),
                            onPressed: () {
                              _showLogoutDialog(context, authProvider);
                            },
                          ),
                          const SizedBox(width: 8), // Jarak antara ikon dan teks
                          Text(
                            'Keluar',
                            style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50), // Tambahkan jarak di bagian bawah
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Profile Pengguna',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Menampilkan dialog konfirmasi logout
  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Konfirmasi Logout',
            style: GoogleFonts.poppins(),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () async {
                await authProvider.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
