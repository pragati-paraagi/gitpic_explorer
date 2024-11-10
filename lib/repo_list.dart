import 'package:flutter/material.dart';
import 'package:gitpic_explorer/bookmark.dart';
import 'package:gitpic_explorer/repo_detail.dart';
import 'repo_model.dart';
import 'repo_list.dart';
import 'repo_services.dart';
import 'package:intl/intl.dart';

class RepoListPage extends StatefulWidget {
  final List<String> bookmarkedImages;
  final Function toggleBookmark;

  RepoListPage({required this.bookmarkedImages, required this.toggleBookmark});

  @override
  _RepoListPageState createState() => _RepoListPageState();
}

class _RepoListPageState extends State<RepoListPage> {
  List<Repo> _repos = [];
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _fetchRepos();
  }

  Future<void> _fetchRepos() async {
    try {
      final repos = await fetchRepos();
      setState(() {
        _repos = repos;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  String _formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  void _showOwnerInfo(BuildContext context, RepoOwner? owner) {
    if (owner == null) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(owner.avatarUrl),
                radius: 70,
              ),
              SizedBox(height: 16),
              Text(
                owner.login,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text('URL: ${owner.url}', style: TextStyle(color: Colors.blue)),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Public Repos'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.bookmark),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => BookmarkPage(
        //             bookmarkedImages: widget.bookmarkedImages,
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      backgroundColor: Color(0xFF020B2F),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _error
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Failed to load repositories',
                          style: TextStyle(color: Colors.white)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchRepos,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _repos.length,
                  itemBuilder: (context, index) {
                    final repo = _repos[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RepoDetailPage(repo)),
                        );
                      },
                      onLongPress: () {
                        _showOwnerInfo(context, repo.owner);
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    repo.owner?.avatarUrl ??
                                        'https://via.placeholder.com/80',
                                  ),
                                  radius: 40,
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    repo.owner?.login ?? 'Unknown',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Description: ${repo.description.isNotEmpty ? repo.description : 'No description available'}',
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Comment Count: ${repo.commentCount}',
                              style: TextStyle(color: Colors.black54),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Created Date: ${_formatDate(repo.createdAt)}',
                              style: TextStyle(color: Colors.black54),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Updated Date: ${_formatDate(repo.updatedAt)}',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
