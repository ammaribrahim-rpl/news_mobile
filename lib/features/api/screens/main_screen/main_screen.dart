import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_mobile/lib.dart';
import 'package:shimmer/shimmer.dart';

part 'sections/search_section.dart';

class ApiScreen extends StatelessWidget {
  ApiScreen({super.key});

  final NewsController c = Get.put(NewsController());
  final TextEditingController _searchController = TextEditingController();

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMMM yyyy, HH:mm').format(dateTime);
  }

  Widget categoryChip(String label, String type) {
    return Obx(() {
      bool isSelected = c.selectedCategory.value == type;
      return ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: MainColors.primaryColor[200]!.withOpacity(0.2),
        onSelected: (bool selected) {
          if (selected) {
            c.changeCategory(type);
          }
        },
        labelStyle: TextStyle(
          color: isSelected
              ? MainColors.primaryColor
              : (c.isTheme.value
                    ? MainColors.greyColor[200]
                    : MainColors.greyColor[800]),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: const Color.fromARGB(0, 59, 47, 47),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isSelected ? MainColors.primaryColor : Colors.transparent,
            width: 1,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _searchController.addListener(() {
      c.applySearch(_searchController.text);
    });

    if (c.allNews.isEmpty) {
      c.fetchNews('');
    }

    return Obx(
      () => Scaffold(
        backgroundColor: c.isTheme.value
            ? MainColors.surfaceDark
            : MainColors.surfaceLight,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: c.isTheme.value
              ? MainColors.surfaceDark
              : MainColors.surfaceLight,
          title: Text(
            'Breaking News',
            style: TextStyle(
              color: c.isTheme.value
                  ? MainColors.textDark
                  : MainColors.textLight,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                c.isTheme.value ? Icons.dark_mode : Icons.light_mode,
                color: c.isTheme.value
                    ? MainColors.textDark
                    : MainColors.textLight,
              ),
              onPressed: () => c.changeTheme(),
            ),
            IconButton(
              icon: Icon(
                Icons.bookmark_outline_rounded,
                color: c.isTheme.value
                    ? MainColors.textDark
                    : MainColors.textLight,
                size: 26,
              ),
              onPressed: () {
                Get.to(() => NewsBookmarks());
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            // Search
            searchSection(searchController: _searchController, c: c),

            // Category
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  categoryChip('Semua', ''),
                  const SizedBox(width: 10),
                  categoryChip('Nasional', 'nasional'),
                  const SizedBox(width: 10),
                  categoryChip('Internasional', 'internasional'),
                  const SizedBox(width: 10),
                  categoryChip('Ekonomi', 'ekonomi'),
                  const SizedBox(width: 10),
                  categoryChip('Olahraga', 'olahraga'),
                  const SizedBox(width: 10),
                  categoryChip('Teknologi', 'teknologi'),
                  const SizedBox(width: 10),
                  categoryChip('Hiburan', 'hiburan'),
                  const SizedBox(width: 10),
                  categoryChip('Gaya Hidup', 'gaya-hidup'),
                ],
              ),
            ),

            // News List
            Expanded(
              child: Obx(() {
                if (c.isLoading.value) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: c.isTheme.value
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                        highlightColor: c.isTheme.value
                            ? Colors.grey.shade500
                            : Colors.grey.shade100,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: c.isTheme.value
                                ? MainColors.blackColor[600]
                                : MainColors.whiteColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          height: 260,
                        ),
                      );
                    },
                  );
                }

                if (c.filteredNews.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada berita ditemukan.',
                      style: TextStyle(
                        color: c.isTheme.value
                            ? MainColors.textDark
                            : MainColors.greyColor[600],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: c.filteredNews.length,
                    itemBuilder: (context, index) {
                      final item = c.filteredNews[index];
                      final imageUrl =
                          item['image'] != null &&
                              item['image']['large'] != null
                          ? item['image']['large']
                          : 'https://via.placeholder.com/800x400?text=No+Image';

                      return Card(
                        color: c.isTheme.value
                            ? MainColors.blackColor[600]
                            : MainColors.whiteColor,
                        margin: const EdgeInsets.only(bottom: 20),
                        elevation: 6,
                        shadowColor: MainColors.blackColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetail(news: item),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: 'newsImage-${item['title']}',
                                child: Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  height: 220,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Judul + tombol bookmark
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item['title'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: c.isTheme.value
                                                  ? MainColors.textDark
                                                  : MainColors.textLight,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        Obx(() {
                                          final isBookmarked = c.bookMarks.any(
                                            (e) => e['title'] == item['title'],
                                          );
                                          return IconButton(
                                            icon: Icon(
                                              isBookmarked
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_outline,
                                              color: isBookmarked
                                                  ? MainColors.primaryColor
                                                  : (c.isTheme.value
                                                        ? MainColors
                                                              .greyColor[400]
                                                        : MainColors
                                                              .greyColor[600]),
                                            ),
                                            onPressed: () {
                                              if (isBookmarked) {
                                                c.removeBookmark(item);
                                                Get.snackbar(
                                                  'Removed',
                                                  'Berita dihapus dari bookmarks',
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                );
                                              } else {
                                                c.addBookmark(item);
                                                Get.snackbar(
                                                  'Saved',
                                                  'Berita ditambahkan ke bookmarks',
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                );
                                              }
                                            },
                                          );
                                        }),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      formatDate(item['isoDate']),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: c.isTheme.value
                                            ? MainColors.greyColor[400]
                                            : MainColors.greyColor[600],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      item['contentSnippet'],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: c.isTheme.value
                                            ? MainColors.textDark
                                            : MainColors.blackColor[800]!
                                                  .withOpacity(0.8),
                                        height: 1.6,
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
