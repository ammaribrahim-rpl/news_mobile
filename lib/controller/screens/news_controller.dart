// controllers/news_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart'; // For Get.changeTheme (optional)
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NewsController extends GetxController {
  var url = 'https://berita-indo-api.vercel.app/v1/cnn-news/'.obs;
  var search = ''.obs;
  var isTheme = true.obs;
  var bookMarks = <Map<String, dynamic>>[].obs;
  var selectedCategory = ''.obs;
  var allNews = <Map<String, dynamic>>[].obs;
  var filteredNews = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  Future<void> fetchNews(String type) async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
        "https://berita-indo-api.vercel.app/v1/cnn-news/$type",
      ));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final jsonList = json['data'] as List;
        allNews.value = jsonList.map((e) => e as Map<String, dynamic>).toList();
        filteredNews.value = allNews;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void applySearch(String query) {
    search.value = query;
    if (query.isEmpty) {
      filteredNews.value = allNews;
    } else {
      filteredNews.value = allNews.where((item) {
        final title = item['title'].toString().toLowerCase();
        final snippet = item['contentSnippet'].toString().toLowerCase();
        final e = query.toLowerCase();
        return title.contains(e) || snippet.contains(e);
      }).toList();
    }
  }

  void changeCategory(String type) {
    selectedCategory.value = type;
    fetchNews(type);
  }

  void changeTheme() {
    isTheme.value = !isTheme.value;
    if (isTheme.value) {
      Get.changeTheme(ThemeData.dark());
    } else {
      Get.changeTheme(ThemeData.light());
    }
  }

  void addBookmark(Map<String, dynamic> news) {
    if (!bookMarks.contains(news)) {
      bookMarks.add(news);
    }
  }

  void removeBookmark(Map<String, dynamic> news) {
    bookMarks.remove(news);
  }

  bool isBookmarked(Map<String, dynamic> news) {
    return bookMarks.contains(news);
  }
}