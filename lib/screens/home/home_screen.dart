import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:tile/services/database_helper.dart';
import 'package:tile/models/berita.dart';
import 'package:tile/screens/crud/add_berita.dart';
import 'package:tile/screens/crud/news_detail_page.dart';
import 'package:tile/screens/profile/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const BeritaScreen(),
    const Center(
      child: Text('Favorit', style: TextStyle(fontSize: 18, color: Colors.grey)),
    ),
    const ProfilScreen(), // Ensure this points to the correct ProfileScreen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: Text('Home', style: GoogleFonts.poppins(color: Colors.black)),
        backgroundColor: Colors.white, // Set AppBar color to white
        elevation: 0, // Remove elevation
        iconTheme: IconThemeData(color: Colors.black), // Set icon color to black
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black, // Selected icon color
        unselectedItemColor: Colors.grey, // Unselected icon color
        backgroundColor: Colors.white, // BottomNavigationBar color
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
      floatingActionButton: _currentIndex == 0 // Show FAB only on Berita screen
          ? FloatingActionButton(
              backgroundColor: Colors.black, // Set FAB color to black
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddBeritaScreen()),
                );
              },
              child: const Icon(Icons.add, color: Colors.white), // Set icon color to white
            )
          : null, // Set to null to hide the button on other screens
    );
  }
}

class BeritaScreen extends StatefulWidget {
  const BeritaScreen({Key? key}) : super(key: key);

  @override
  _BeritaScreenState createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  List<Berita> _beritaList = [];
  List<Berita> _filteredBeritaList = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchBerita();
  }

  void _fetchBerita() async {
    final beritaList = await DatabaseHelper().getBerita();
    setState(() {
      _beritaList = beritaList;
      _filteredBeritaList = beritaList; // Set awal untuk menampilkan semua berita
    });
  }

  void _searchBerita(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isNotEmpty) {
        _filteredBeritaList = _beritaList
            .where((berita) => berita.judul.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        _filteredBeritaList = _beritaList; // Kembalikan ke semua berita jika query kosong
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: MediaQuery.of(context).size.height * 0.05),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: _searchBerita,
            decoration: InputDecoration(
              hintText: "Cari berita...",
              hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.black), // Change icon color to black
              filled: true,
              fillColor: Colors.grey[200], // Light grey background for the text field
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Image Slider
          Container(
            height: MediaQuery.of(context).size.height * 0.25, // Responsive height
            child: PageView(
              children: [
                Image.asset('assets/image1.jpg', fit: BoxFit.cover),
                Image.asset('assets/image2.jpg', fit: BoxFit.cover),
                Image.asset('assets/image3.jpg', fit: BoxFit.cover),
                // Tambahkan lebih banyak gambar sesuai kebutuhan
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Grid of News Articles
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75, // Maintain aspect ratio
              ),
              itemCount: _filteredBeritaList.length,
              itemBuilder: (context, index) {
                final berita = _filteredBeritaList[index];
                return BeritaCard(berita: berita);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BeritaCard extends StatelessWidget {
  final Berita berita;

  const BeritaCard({
    Key? key,
    required this.berita,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsDetailPage(berita: berita)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
        shadowColor: Colors.grey.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (berita.imagePath.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.file(
                    File(berita.imagePath),
                    height: MediaQuery.of(context).size.height * 0.15, // Responsive height
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                berita.judul,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                berita.deskripsi,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
