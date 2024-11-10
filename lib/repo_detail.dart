import 'package:flutter/material.dart';
import 'repo_model.dart';

class RepoDetailPage extends StatelessWidget {
  final Repo repo;
  RepoDetailPage(this.repo);

  @override
  Widget build(BuildContext context) {
    final files = repo.files ?? {}; // Handle null files gracefully

    return Scaffold(
      appBar: AppBar(
        title: Text(repo.owner?.login ?? 'Unknown Owner'), // Handle null owner
      ),
      body: Column(
        children: [
          // Header Section with repo info and owner details
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(repo.owner?.avatarUrl ??
                      'https://via.placeholder.com/150'),
                  radius: 24,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        repo.owner?.login ?? 'Unknown',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'By ${repo.owner?.login ?? 'Unknown'}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        repo.description ?? 'No description provided',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tabs for different sections like files, issues
          DefaultTabController(
            length: 2,
            child: Expanded(
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Files'),
                      Tab(text: 'Issues'), // You can add more tabs if needed
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Files Tab
                        files.isNotEmpty
                            ? ListView.builder(
                                itemCount: files.length,
                                itemBuilder: (context, index) {
                                  final fileName = files.keys.elementAt(index);
                                  final file = files[fileName];
                                  final fileType = file['type'] ?? 'Unknown';

                                  return ListTile(
                                    title: Text(fileName),
                                    subtitle: Text('Type: $fileType'),
                                  );
                                },
                              )
                            : Center(
                                child: Text('No files available for this repo'),
                              ),
                        // Issues Tab (can replace with real data or more tabs)
                        Center(child: Text('Issues list would be here')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
