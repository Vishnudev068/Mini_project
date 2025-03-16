import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter_application_4/services/firestore.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? _selectedImage;
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();
  final FirestoreServices _firestoreServices = FirestoreServices();
  List<Map<String, dynamic>> _pharmacyList = [];

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() => _selectedImage = File(pickedImage.path));
      _processImage(File(pickedImage.path));
    }
  }

  Future<void> _processImage(File image) async {
    setState(() {
      _isProcessing = true;
      _textController.clear();
    });

    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer();
    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      setState(() => _textController.text = recognizedText.text.trim());
      print("Extracted Text: ${_textController.text}");
    } catch (e) {
      setState(() => _textController.text = 'Error: ${e.toString()}');
    } finally {
      textRecognizer.close();
      setState(() => _isProcessing = false);
    }
  }

  void _searchPharmacies() {
    String medicineName = _textController.text.trim().toLowerCase();
    print(medicineName);
    if (medicineName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter or scan a medicine name!')),
      );
      return;
    }

    print("Searching for medicine: $medicineName");

    _firestoreServices
        .getPharmaciesWithMedicine(medicineName)
        .listen((pharmacies) {
      print("Pharmacies found: ${pharmacies.length}");
      for (var pharmacy in pharmacies) {
        print(
            "Pharmacy: ${pharmacy['name']}, Medicines: ${pharmacy['medicines']}");
      }
      setState(() => _pharmacyList = pharmacies);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan & Find Medicines'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_selectedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_selectedImage!,
                      height: 200, width: double.infinity, fit: BoxFit.cover),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImageButton(Icons.camera_alt, "Camera",
                      () => _pickImage(ImageSource.camera)),
                  const SizedBox(width: 20),
                  _buildImageButton(Icons.image, "Gallery",
                      () => _pickImage(ImageSource.gallery)),
                ],
              ),
              const SizedBox(height: 20),
              if (_isProcessing) const CircularProgressIndicator(),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                    labelText: "Extracted Medicine Name",
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _searchPharmacies,
                child: const Text('Find Pharmacies'),
              ),
              const SizedBox(height: 20),
              _pharmacyList.isNotEmpty
                  ? _buildPharmacyList()
                  : Center(child: Text("No pharmacies found")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.blue),
          const SizedBox(height: 8),
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPharmacyList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _pharmacyList.length,
      itemBuilder: (context, index) {
        var pharmacy = _pharmacyList[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(pharmacy['name'],
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("Address: ${pharmacy['address']}")],
            ),
          ),
        );
      },
    );
  }
}
