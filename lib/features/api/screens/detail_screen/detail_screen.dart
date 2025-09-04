import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // Pastikan package ini sudah diinstal

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> newsDetail;
  const DetailScreen({super.key, required this.newsDetail});

  // Fungsi untuk memformat tanggal
  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'Tanggal tidak tersedia';
    try {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('dd MMMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return date; // Mengembalikan string asli jika parsing gagal
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        newsDetail['image'] != null && newsDetail['image']['large'] != null
        ? newsDetail['image']['large']
        : 'https://via.placeholder.com/400x250?text=No+Image'; // Placeholder yang lebih kecil

    return Scaffold(
      backgroundColor:
          Colors.grey[100], // Konsisten dengan background awal Anda
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87, // Warna ikon back
        centerTitle: true,
        title: const Text(
          'Detail Berita',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                newsDetail['title'] ?? 'Judul Tidak Tersedia',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _formatDate(newsDetail['isoDate']),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              // Hero Animation untuk gambar
              Hero(
                tag:
                    'newsImage-${newsDetail['title']}', // TAG HARUS SAMA DENGAN DI MAIN_SCREEN
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Sedikit sudut bulat
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 200, // Tinggi gambar 200px agar tidak terlalu besar
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.blueAccent,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                newsDetail['contentSnippet'] ?? 'Deskripsi tidak tersedia.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              if (newsDetail['link'] != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final Uri url = Uri.parse(newsDetail['link']);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Tidak dapat membuka link: ${newsDetail['link']}',
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.link, color: Colors.white),
                    label: const Text(
                      'Baca Selengkapnya',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blueAccent, // Warna tombol konsisten
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
