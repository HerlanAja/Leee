class Berita {
  final int? id;
  final String judul;
  final String imagePath; // Ubah nama property dari image menjadi imagePath
  final int favorit;
  final String deskripsi;

  Berita({
    this.id,
    required this.judul,
    required this.imagePath, // Update constructor
    required this.favorit,
    required this.deskripsi,
  });

  factory Berita.fromMap(Map<String, dynamic> map) {
    return Berita(
      id: map['id'],
      judul: map['judul'],
      imagePath: map['image'], // Ganti image dengan imagePath
      favorit: map['favorit'],
      deskripsi: map['deskripsi'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'image': imagePath, // Ganti image dengan imagePath
      'favorit': favorit,
      'deskripsi': deskripsi,
    };
  }
}
