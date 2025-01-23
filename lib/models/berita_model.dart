class Berita {
  final int? id; // id berita, null jika baru
  final String judul;
  final String image; // URL atau path gambar
  final bool favorit; // status favorit
  final String deskripsi;

  Berita({
    this.id,
    required this.judul,
    required this.image,
    required this.favorit,
    required this.deskripsi,
  });

  // Mengubah objek berita menjadi map untuk disimpan di database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'image': image,
      'favorit': favorit ? 1 : 0, // simpan sebagai int (1/0)
      'deskripsi': deskripsi,
    };
  }

  // Mengubah map menjadi objek berita
  factory Berita.fromMap(Map<String, dynamic> map) {
    return Berita(
      id: map['id'],
      judul: map['judul'],
      image: map['image'],
      favorit: map['favorit'] == 1,
      deskripsi: map['deskripsi'],
    );
  }
}
