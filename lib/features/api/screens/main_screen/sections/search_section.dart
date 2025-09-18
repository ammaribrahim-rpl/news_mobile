part of '../main_screen.dart';


class searchSection extends StatelessWidget {
  const searchSection({
    super.key,
    required TextEditingController searchController,
    required this.c,
  }) : _searchController = searchController;

  final TextEditingController _searchController;
  final NewsController c;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari Berita...',
          hintStyle: TextStyle(
            color: c.isTheme.value
                ? MainColors.greyColor[400]
                : MainColors.greyColor[600],
          ),
          prefixIcon: Icon(
            Icons.search,
            color: c.isTheme.value
                ? MainColors.greyColor[400]
                : MainColors.greyColor[600],
          ),
          filled: true,
          fillColor: c.isTheme.value
              ? MainColors.blackColor[600]
              : MainColors.greyColor[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(
          color: c.isTheme.value
              ? MainColors.textDark
              : MainColors.textLight,
        ),
      ),
    );
  }
}
