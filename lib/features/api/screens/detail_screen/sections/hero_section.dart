part of '../detail_screen.dart';


class heroSection extends StatelessWidget {
  const heroSection({
    super.key,
    required this.news,
    required this.imageUrl,
    required this.c,
  });

  final Map<String, dynamic> news;
  final dynamic imageUrl;
  final NewsController c;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'newsImage-${news['title']}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: double.infinity,
              height: 220,
              color: c.isTheme.value
                  ? MainColors.blackColor[600]
                  : MainColors.greyColor[200],
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: MainColors.primaryColor,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 220,
              color: c.isTheme.value
                  ? MainColors.blackColor[600]
                  : MainColors.greyColor[200],
              child: Icon(
                Icons.broken_image,
                color: MainColors.greyColor,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}