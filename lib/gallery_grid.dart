import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bookmark.dart';


class GalleryTab extends StatefulWidget {
  final List<String> bookmarkedImages;
  final Function toggleBookmark;

  GalleryTab({required this.bookmarkedImages, required this.toggleBookmark});

  @override
  _GalleryTabState createState() => _GalleryTabState();
}

class _GalleryTabState extends State<GalleryTab> {
  List<dynamic> _imageList = [];
  List<String> _bookmarkedImages = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
    _loadBookmarks();
  }

  // Fetch images from the Unsplash API
  Future<void> _fetchImages() async {
    final response = await http.get(Uri.parse('https://api.unsplash.com/photos?client_id=mVIvj0x_2xdZhofLTFbmWSkfPNQoHDnQ0ZEoV9liAGo'));

    if (response.statusCode == 200) {
      setState(() {
        _imageList = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future<void> _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _bookmarkedImages = prefs.getStringList('bookmarkedImages') ?? [];
    });
  }

  // Save bookmarks to shared preferences
  Future<void> _saveBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('bookmarkedImages', _bookmarkedImages);
  }

  // Function to handle bookmark action
  void _toggleBookmark(String imageUrl, BuildContext context) {
    setState(() {
      if (_bookmarkedImages.contains(imageUrl)) {
        _bookmarkedImages.remove(imageUrl);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from bookmarks')),
        );
      } else {
        _bookmarkedImages.add(imageUrl);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully added to bookmarks')),
        );
      }
    });

    // Save the updated bookmark list
    _saveBookmarks();  // Call the save function here
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookmarkPage(bookmarkedImages: _bookmarkedImages),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFF020B2F),
      body: _imageList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _imageList.length,
        itemBuilder: (context, index) {
          final imageUrl = _imageList[index]['urls']['small'];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageDetailPage(
                    imageUrl: _imageList[index]['urls']['regular'],
                    imageId: _imageList[index]['id'],
                    toggleBookmark: _toggleBookmark,
                    isBookmarked: _bookmarkedImages.contains(imageUrl),
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ImageDetailPage extends StatelessWidget {
  final String imageUrl;
  final String imageId;
  final Function toggleBookmark;
  final bool isBookmarked;

  ImageDetailPage({
    required this.imageUrl,
    required this.imageId,
    required this.toggleBookmark,
    required this.isBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Detail'),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border, // Toggle the icon based on bookmark state
            ),
            onPressed: () {
              toggleBookmark(imageUrl, context);  // Pass the context to show a snack bar
            },
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // Allow panning (scrolling)
          minScale: 0.5, // Minimum zoom scale
          maxScale: 5.0, // Maximum zoom scale
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.contain, // Keep the image within bounds during zoom
          ),
        ),
      ),
    );
  }
}



