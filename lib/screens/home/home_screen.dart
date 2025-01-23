import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tile/providers/auth_provider.dart';
import 'package:tile/screens/profile/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Daftar layar untuk BottomNavigationBar
  final List<Widget> _screens = [
    const BeritaScreen(),
    const FavoritScreen(),
    const ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: _screens[_currentIndex], // Navigasi ke layar sesuai index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Berita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0 // Tampilkan tombol logout hanya di layar Berita
          ? FloatingActionButton(
              onPressed: () async {
                // Logout menggunakan AuthProvider
                await authProvider.logout();

                // Arahkan pengguna ke layar login
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Icon(Icons.logout),
            )
          : null,
    );
  }
}

// Layar Berita
class BeritaScreen extends StatelessWidget {
  const BeritaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        BeritaCard(
          title: 'Berita Pertama',
          content: 'Ini adalah ringkasan berita pertama.',
        ),
        BeritaCard(
          title: 'Berita Kedua',
          content: 'Ini adalah ringkasan berita kedua.',
        ),
        BeritaCard(
          title: 'Berita Ketiga',
          content: 'Ini adalah ringkasan berita ketiga.',
        ),
      ],
    );
  }
}

// Kartu untuk menampilkan berita
class BeritaCard extends StatelessWidget {
  final String title;
  final String content;

  const BeritaCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// Layar Favorit
class FavoritScreen extends StatelessWidget {
  const FavoritScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Belum ada berita favorit.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
