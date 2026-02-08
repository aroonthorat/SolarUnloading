import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class InstallationLogScreen extends StatefulWidget {
  const InstallationLogScreen({super.key});

  @override
  State<InstallationLogScreen> createState() => _InstallationLogScreenState();
}

class _InstallationLogScreenState extends State<InstallationLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _farmerController = TextEditingController();
  final _serialNumberController = TextEditingController();
  
  final ImagePicker _picker = ImagePicker();
  final List<File> _installationPhotos = [];
  final List<File> _issuePhotos = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _farmerController.dispose();
    _serialNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickInstallationPhotos() async {
    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _installationPhotos.addAll(images.map((img) => File(img.path)));
      });
    }
  }

  Future<void> _pickIssuePhotos() async {
    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _issuePhotos.addAll(images.map((img) => File(img.path)));
      });
    }
  }

  Future<String?> _uploadImage(File file, String folder) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref('$folder/$fileName');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveLog() async {
    if (!_formKey.currentState!.validate()) return;

    if (_installationPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Installation photos are mandatory')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload installation photos
      final List<String> installationPhotoUrls = [];
      for (final photo in _installationPhotos) {
        final url = await _uploadImage(photo, 'installation');
        if (url != null) installationPhotoUrls.add(url);
      }

      // Upload issue photos (optional)
      final List<String> issuePhotoUrls = [];
      for (final photo in _issuePhotos) {
        final url = await _uploadImage(photo, 'installation');
        if (url != null) issuePhotoUrls.add(url);
      }

      // Save to Firestore
      await FirebaseFirestore.instance.collection('installation_log').add({
        'date': Timestamp.fromDate(DateTime.now()),
        'farmer': _farmerController.text.trim(),
        'serialNumber': _serialNumberController.text.trim(),
        'installationPhotoUrls': installationPhotoUrls,
        'issuePhotoUrls': issuePhotoUrls,
        'enteredBy': FirebaseAuth.instance.currentUser?.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Installation log saved successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving log: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildPhotoGrid(List<File> photos, bool isInstallation) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                Image.file(
                  photos[index],
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        photos.removeAt(index);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installation Log'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Date (auto-filled)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Date'),
                  subtitle: Text(DateFormat('dd MMM yyyy').format(DateTime.now())),
                ),
              ),
              const SizedBox(height: 16),

              // Farmer Name/ID
              TextFormField(
                controller: _farmerController,
                decoration: const InputDecoration(
                  labelText: 'Farmer Name or ID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Serial Number
              TextFormField(
                controller: _serialNumberController,
                decoration: const InputDecoration(
                  labelText: 'Serial Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Installation Photos (Mandatory)
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.camera_alt, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Installation Photos *',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _pickInstallationPhotos,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: Text('Add Photos (${_installationPhotos.length})'),
                      ),
                      if (_installationPhotos.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _buildPhotoGrid(_installationPhotos, true),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Issue Photos (Optional)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.warning_amber, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Issue Photos (Optional)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _pickIssuePhotos,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: Text('Add Photos (${_issuePhotos.length})'),
                      ),
                      if (_issuePhotos.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _buildPhotoGrid(_issuePhotos, false),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveLog,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Save Installation Log',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
