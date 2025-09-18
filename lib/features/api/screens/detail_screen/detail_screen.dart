import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_mobile/lib.dart';
import 'package:url_launcher/url_launcher.dart';

part 'sections/hero_section.dart';

class NewsDetail extends StatelessWidget {
  final Map<String, dynamic> news;
  final NewsController c = Get.find<NewsController>();

  NewsDetail({super.key, required this.news});

  // Format tanggal
  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'Tanggal tidak tersedia';
    try {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('dd MMMM yyyy, HH:mm').format(dateTime);
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = news['image'] != null && news['image']['large'] != null
        ? news['image']['large']
        : 'https://via.placeholder.com/400x250?text=No+Image';

    return Obx(
      () => Scaffold(
        backgroundColor: c.isTheme.value
            ? MainColors.blackColor[800]
            : MainColors.whiteColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: c.isTheme.value
              ? MainColors.blackColor[800]
              : MainColors.whiteColor,
          foregroundColor: c.isTheme.value
              ? MainColors.whiteColor
              : MainColors.blackColor[800],
          centerTitle: true,
          title: Text(
            'Detail Berita',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: c.isTheme.value
                  ? MainColors.whiteColor
                  : MainColors.blackColor[800],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                c.isTheme.value ? Icons.dark_mode : Icons.light_mode,
                color: c.isTheme.value
                    ? MainColors.whiteColor
                    : MainColors.blackColor[800],
              ),
              onPressed: () => c.changeTheme(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul
                Text(
                  news['title'] ?? 'Judul Tidak Tersedia',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: c.isTheme.value
                        ? MainColors.whiteColor
                        : MainColors.blackColor[800],
                  ),
                ),
                const SizedBox(height: 10),

                // Tanggal
                Text(
                  _formatDate(news['isoDate']),
                  style: TextStyle(
                    fontSize: 14,
                    color: c.isTheme.value
                        ? MainColors.greyColor[400]
                        : MainColors.greyColor[600],
                  ),
                ),
                const SizedBox(height: 16),

                // Gambar dengan Hero
                heroSection(news: news, imageUrl: imageUrl, c: c),
                const SizedBox(height: 16),

                // Isi berita
                Text(
                  news['contentSnippet'] ?? 'Deskripsi tidak tersedia.',
                  style: TextStyle(
                    fontSize: 16,
                    color: c.isTheme.value
                        ? MainColors.whiteColor
                        : MainColors.blackColor[800],
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol baca selengkapnya
                if (news['link'] != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final Uri url = Uri.parse(news['link']);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          Get.snackbar(
                            "Error",
                            "Tidak dapat membuka link",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      icon: const Icon(Icons.link, color: Colors.white),
                      label: const Text(
                        'Baca Selengkapnya',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MainColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
