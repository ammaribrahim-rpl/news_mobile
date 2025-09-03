import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_mobile/api/api.dart';
import 'package:news_mobile/features/api/screens/detail_screen/detail_screen.dart';

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

  Widget categoryButton(String label, String type) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedCategory == type
            ? Colors.blueAccent
            : Colors.blueGrey,
      ),
      onPressed: () {
        setState(() {
          _selectedCategory = type;
        });
        fetchNews(type);
      },
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMMM yyyy, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'News App',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search News',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 0,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                categoryButton('All', ''),
                const SizedBox(width: 8),
                categoryButton('Nasional', 'nasional'),
                const SizedBox(width: 8),
                categoryButton('Internasional', 'internasional'),
                const SizedBox(width: 8),
                categoryButton('Ekonomi', 'ekonomi'),
                const SizedBox(width: 8),
                categoryButton('Olahraga', 'olahraga'),
                const SizedBox(width: 8),
                categoryButton('Teknologi', 'teknologi'),
                const SizedBox(width: 8),
                categoryButton('Hiburan', 'hiburan'),
                const SizedBox(width: 8),
                categoryButton('Gaya Hidup', 'gaya-hidup'),
              ],
            ),
          ),

          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredNews.isEmpty
                ? Center(child: Text('No news found'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredNews.length,
                    itemBuilder: (context, index) {
                      final item = _filteredNews[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            // Navigasi ke detail berita
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(newsDetail: item),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Gambar berita (full width)
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  topRight: Radius.circular(14),
                                ),
                                child: Image.network(
                                  item['image']['large'],
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

                              // Konten berita
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Judul berita
                                    Text(
                                      item['title'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // Tanggal berita
                                    Text(
                                      formatDate(item['isoDate']),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const SizedBox(height: 10),
                                    // Deskripsi berita
                                    Text(
                                      item['contentSnippet'],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[800],
                                        height: 1.4,
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
