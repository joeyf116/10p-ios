import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../domain/repositories/announcement_repository.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _publishing = false;

  AnnouncementRepository get _repository =>
      serviceLocator<AnnouncementRepository>();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _bodyController,
            decoration: const InputDecoration(labelText: 'Body'),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _publishing ? null : _publish,
            child: Text(_publishing ? 'Publishing...' : 'Publish Announcement'),
          ),
          const SizedBox(height: 20),
          const Text('Latest posts'),
          const SizedBox(height: 8),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('announcements')
                .orderBy('created_at', descending: true)
                .limit(20)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Could not load announcements: ${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('No announcements yet.'),
                );
              }

              return Column(
                children: docs.map((doc) {
                  final data = doc.data();
                  final timestamp = data['created_at'];
                  final createdAt = timestamp is Timestamp
                      ? timestamp.toDate().toLocal().toString()
                      : 'pending';

                  return Card(
                    child: ListTile(
                      title: Text(data['title'] as String? ?? 'Untitled'),
                      subtitle:
                          Text('${data['body'] as String? ?? ''}\n$createdAt'),
                      isThreeLine: true,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _publish() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and body are required.')),
      );
      return;
    }

    setState(() => _publishing = true);
    try {
      await _repository.publish(title: title, body: body);
      if (!mounted) return;
      _titleController.clear();
      _bodyController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement published.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Publish failed: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _publishing = false);
      }
    }
  }
}
