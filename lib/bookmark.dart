import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookmarkPage extends StatelessWidget {
  final List<String> bookmarkedImages;

  BookmarkPage({required this.bookmarkedImages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: bookmarkedImages.isEmpty
          ? Center(child: Text('No bookmarked images'))
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,  // Two images per row
          crossAxisSpacing: 8.0,  // Space between columns
          mainAxisSpacing: 8.0,  // Space between rows
        ),
        itemCount: bookmarkedImages.length,
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: bookmarkedImages[index],
            width: double.infinity,  // Make the image take full width of each cell
            height: 250,  // Adjust the height to fit within the grid cell
            fit: BoxFit.cover,  // Ensure the image covers the space
          );
        },
      ),
    );
  }
}