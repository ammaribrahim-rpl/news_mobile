import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_mobile/lib.dart';

class NewsBookmarks extends StatelessWidget {
  final c = Get.find<NewsController>();

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMM yyyy, HH:mm').format(parsed);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
        centerTitle: true,
        actions: [
          Obx(
            () => c.bookMarks.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined),
                    tooltip: "Clear all bookmarks",
                    onPressed: () => c.bookMarks.clear(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (c.bookMarks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: 100,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  "No bookmarks yet",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: c.bookMarks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = c.bookMarks[index];
            final smallImage = item['image']?['small']?.toString() ?? '';
            final imageUrl = smallImage.isNotEmpty
                ? smallImage
                : "https://via.placeholder.com/150x100?text=No+Image";

            return InkWell(
              onTap: () => Get.to(() => NewsDetail(news: item)),
              borderRadius: BorderRadius.circular(16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    // Thumbnail
                    Container(
                      width: 110,
                      height: 110,
                      color: theme.colorScheme.surfaceVariant,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    // Info
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] ?? "No title",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item['contentSnippet'] ?? "",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.7,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _formatDate(item['isoDate']),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Remove bookmark button
                    IconButton(
                      icon: Icon(
                        Icons.bookmark,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: () => c.removeBookmark(item),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
