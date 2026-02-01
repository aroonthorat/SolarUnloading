import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart';

class UnloadingLogScreen extends StatefulWidget {
  const UnloadingLogScreen({super.key});

  @override
  State<UnloadingLogScreen> createState() => _UnloadingLogScreenState();
}

class _UnloadingLogScreenState extends State<UnloadingLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _farmerController = TextEditingController();
  final _materialTypeController = TextEditingController();
  final _serialNumberController = TextEditingController();
  
  final ImagePicker _picker = ImagePicker();
  File? _qrImage;
  final List<File> _unloadingPhotos = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _farmerController.dispose();
    _materialTypeController.dispose();
    _serialNumberController.dispose();
    super.dispose();
  }

  Future<void> _scanQR() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QRScannerScreen(
          onScanned: (code, image) {
            setState(() {
              _serialNumberController.text = code;
              _qrImage = image;
            });
          },
        ),
      ),
    );
  }

  Future<void> _pickUnloadingPhotos() async {
    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _unloadingPhotos.addAll(images.map((img) => File(img.path)));
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

    setState(() => _isLoading = true);

    try {
      // Upload QR image
      String? qrImageUrl;
      if (_qrImage != null) {
        qrImageUrl = await _uploadImage(_qrImage!, 'unloading');
      }

      // Upload unloading photos
      final List<String> unloadingPhotoUrls = [];
      for (final photo in _unloadingPhotos) {
        final url = await _uploadImage(photo, 'unloading');
        if (url != null) unloadingPhotoUrls.add(url);
      }

      // Save to Firestore
      await FirebaseFirestore.instance.collection('unloading_log').add({
        'date': Timestamp.fromDate(DateTime.now()),
        'farmer': _farmerController.text.trim(),
        'materialType': _materialTypeController.text.trim(),
        'serialNumber': _serialNumberController.text.trim(),
        'qrImageUrl': qrImageUrl,
        'unloadingPhotoUrls': unloadingPhotoUrls,
        'enteredBy': FirebaseAuth.instance.currentUser?.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unloading log saved successfully')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unloading Log'),
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

              // Material Type
              TextFormField(
                controller: _materialTypeController,
                decoration: const InputDecoration(
                  labelText: 'Material Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // QR Scanner Button
              ElevatedButton.icon(
                onPressed: _scanQR,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan QR Code'),
              ),
              const SizedBox(height: 16),

              // Serial Number (auto-filled from QR)
              TextFormField(
                controller: _serialNumberController,
                decoration: const InputDecoration(
                  labelText: 'Serial Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                  helperText: 'Auto-filled from QR or enter manually',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // QR Image Preview
              if (_qrImage != null)
                Card(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(Icons.qr_code),
                        title: Text('QR Code Image Captured'),
                      ),
                      Image.file(_qrImage!, height: 150),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              // Unloading Photos
              ElevatedButton.icon(
                onPressed: _pickUnloadingPhotos,
                icon: const Icon(Icons.add_photo_alternate),
                label: Text('Add Unloading Photos (${_unloadingPhotos.length})'),
              ),
              const SizedBox(height: 8),

              // Photos Preview
              if (_unloadingPhotos.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _unloadingPhotos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Stack(
                          children: [
                            Image.file(
                              _unloadingPhotos[index],
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
                                    _unloadingPhotos.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
                        'Save Unloading Log',
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

// QR Scanner Screen
class QRScannerScreen extends StatefulWidget {
  final Function(String code, File? image) onScanned;

  const QRScannerScreen({super.key, required this.onScanned});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        controller.pauseCamera();
        
        // QR image capture not supported by qr_code_scanner package
        // Just extract the serial number from QR code

        if (mounted) {
          widget.onScanned(scanData.code!, null);
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
      ),
    );
  }
}
