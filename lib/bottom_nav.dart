import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gitpic_explorer/repo_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gitpic_explorer/repo_detail.dart';
import 'gallery_grid.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;
  late List<Widget> pages;
  late Widget currentPage;
  late RepoListPage homePage;
  late GalleryTab nextPage;

  // Shared list of bookmarked images
  List<String> _bookmarkedImages = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks(); // Load bookmarks when the app starts

    // Initialize pages with shared bookmark list and toggle function
    homePage = RepoListPage(
      bookmarkedImages: _bookmarkedImages,
      toggleBookmark: _toggleBookmark,
    );
    nextPage = GalleryTab(
      bookmarkedImages: _bookmarkedImages,
      toggleBookmark: _toggleBookmark,
    );

    // Add both pages to the list
    pages = [homePage, nextPage];
  }

  // Function to load bookmarks from shared preferences
  Future<void> _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _bookmarkedImages = prefs.getStringList('bookmarkedImages') ?? [];
    });
  }

  // Function to save bookmarks to shared preferences
  Future<void> _saveBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('bookmarkedImages', _bookmarkedImages);
  }

  // Function to toggle bookmarks and save changes
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
          SnackBar(content: Text('Added to bookmarks')),
        );
      }
    });
    _saveBookmarks(); // Save updated bookmarks
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 58,
        backgroundColor: Color(0xFFF3F5FA),
        color: Colors.black54,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(Icons.folder, color: Colors.white, size: 30),
          Icon(Icons.photo_library, color: Colors.white, size: 30),
        ],
      ),
      body: pages[
          currentTabIndex], // Display the current page based on the tab index
    );
  }
}
