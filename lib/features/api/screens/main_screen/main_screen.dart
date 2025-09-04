import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_mobile/api/api.dart';
import 'package:news_mobile/features/api/screens/detail_screen/detail_screen.dart';
import 'package:shimmer/shimmer.dart'; // Tambahkan ini di pubspec.yaml

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  String _selectedCategory = '';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allNews = [];
  List<Map<String, dynamic>> _filteredNews = [];
  bool isLoading = false;

  Future<void> fetchNews(String type) async {
    setState(() {
      isLoading = true;
    });

    final data = await Api().getApi(category: type);
    setState(() {
      _allNews = data;
      _filteredNews = data;
      isLoading = false;
    });
  }

  _applySearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredNews = _allNews;
      });
    } else {
      setState(() {
        _filteredNews = _allNews.where((item) {
          final title = item['title'].toString().toLowerCase();
          final snippet = item['contentSnippet'].toString().toLowerCase();
          final search = query.toLowerCase();
          return title.contains(search) || snippet.contains(search);
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews(_selectedCategory);

    _searchController.addListener(() {
      _applySearch(_searchController.text);
    });
  }

  Widget categoryChip(String label, String type) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedCategory == type,
      selectedColor: Colors.deepPurple.shade200, // Warna lebih menarik
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _selectedCategory = type;
          });
          fetchNews(type);
        }
      },
      labelStyle: TextStyle(
        color: _selectedCategory == type
            ? Colors.deepPurple.shade900
            : Colors.grey.shade700,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: _selectedCategory == type
              ? Colors.deepPurple.shade400
              : Colors.grey.shade300,
          width: 1,
        ),
      ),
    );
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMMM yyyy, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Latar belakang yang lebih terang
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false, // Judul rata kiri
        title: const Text(
          'Breaking News', // Judul yang lebih menarik
          style: TextStyle(
            color: Colors.black87,
            fontSize: 26, // Ukuran font lebih besar
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {
              // Tambahkan fungsionalitas notifikasi
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari Berita...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Border lebih bulat
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                    width: 1.5,
                  ), // Efek saat fokus
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                categoryChip('Semua', ''),
                const SizedBox(width: 8),
                categoryChip('Nasional', 'nasional'),
                const SizedBox(width: 8),
                categoryChip('Internasional', 'internasional'),
                const SizedBox(width: 8),
                categoryChip('Ekonomi', 'ekonomi'),
                const SizedBox(width: 8),
                categoryChip('Olahraga', 'olahraga'),
                const SizedBox(width: 8),
                categoryChip('Teknologi', 'teknologi'),
                const SizedBox(width: 8),
                categoryChip('Hiburan', 'hiburan'),
                const SizedBox(width: 8),
                categoryChip('Gaya Hidup', 'gaya-hidup'),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 5, // Tampilkan 5 efek shimmer saat loading
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 18,
                                      color: Colors.white,
                                      margin: const EdgeInsets.only(bottom: 6),
                                    ),
                                    Container(
                                      width: 150,
                                      height: 14,
                                      color: Colors.white,
                                      margin: const EdgeInsets.only(bottom: 8),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 15,
                                      color: Colors.white,
                                      margin: const EdgeInsets.only(bottom: 4),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 15,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : _filteredNews.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada berita ditemukan.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredNews.length,
                    itemBuilder: (context, index) {
                      final item = _filteredNews[index];
                      // Pastikan ada 'image' key dan 'large' key di dalamnya
                      final imageUrl =
                          item['image'] != null &&
                              item['image']['large'] != null
                          ? item['image']['large']
                          : 'https://via.placeholder.com/150'; // Fallback image

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation:
                            4, // Meningkatkan elevasi untuk efek 3D ringan
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            16,
                          ), // Radius yang lebih besar
                        ),
                        clipBehavior: Clip.antiAlias, // Penting untuk ClipRRect
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(newsDetail: item),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag:
                                    'newsImage-${item['title']}', // Tag unik untuk Hero Animation
                                child: Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
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
                              Padding(
                                padding: const EdgeInsets.all(
                                  16,
                                ), // Padding lebih besar
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize:
                                            20, // Ukuran font judul lebih besar
                                        fontWeight: FontWeight
                                            .bold, // Judul lebih tebal
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      formatDate(item['isoDate']),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      item['contentSnippet'],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[800],
                                        height: 1.5, // Spasi baris lebih baik
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
