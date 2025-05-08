import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fundraising/screens/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateCampaignPage extends StatefulWidget {
  const CreateCampaignPage({super.key});

  @override
  State<CreateCampaignPage> createState() => _CreateCampaignPageState();
}

class _CreateCampaignPageState extends State<CreateCampaignPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedCategory;
  final List<File> _images = [];
  bool _isGeneratingDescription = false;

  final List<String> _categories = ['Dhuafa', 'Kesehatan', 'Lingkungan', 'Bencana Alam'];

  Future<List<String>> uploadImagesToSupabase(List<File> images) async {
    final supabase = Supabase.instance.client;
    final List<String> publicUrls = [];

    for (final image in images) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
      final storageResponse = await supabase.storage
          .from('donation-images') // make sure the bucket exists
          .upload('public/$fileName', image);

      if (storageResponse.isEmpty) {
        throw Exception('Upload failed');
      }

      final publicUrl = supabase.storage
          .from('donation-images')
          .getPublicUrl('public/$fileName');

      publicUrls.add(publicUrl);
    }

    return publicUrls;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(); // For gallery

    if (source == ImageSource.camera) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() => _images.add(File(pickedFile.path)));
      }
    } else if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() => _images.addAll(pickedFiles.map((e) => File(e.path))));
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImages = await ImagePicker().pickMultiImage();
                  if (pickedImages != null) {
                    setState(() {
                      _images.addAll(pickedImages.map((e) => File(e.path)));
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a picture'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickedImage != null) {
                    setState(() {
                      _images.add(File(pickedImage.path));
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> _generateDescription(String prompt) async {
    try {
      const apiKey = 'AIzaSyDkBpM0BNslRzNzPYPgNyu-xmqzd1tIpN4';
      const apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': 'You are a helpful assistant that generates compelling campaign descriptions for fundraising purposes. '
                      'The descriptions should be engaging, emotional, and persuasive. '
                      'Please generate a description based on this prompt: $prompt'
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ?? 'Failed to generate description';
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to generate description');
      }
    } catch (e) {
      print('Error generating description: $e');
      throw Exception('Failed to generate description');
    }
  }

  void _showAIPromptDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Description'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter a prompt to generate a campaign description. For example: "A campaign to help underprivileged children get access to education"',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                hintText: 'Enter your prompt here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_promptController.text.isNotEmpty) {
                Navigator.pop(context);
                if (!mounted) return;
                setState(() => _isGeneratingDescription = true);
                
                try {
                  final generatedDescription = await _generateDescription(_promptController.text);
                  if (!mounted) return;
                  setState(() {
                    _descriptionController.text = generatedDescription;
                    _isGeneratingDescription = false;
                  });
                } catch (e) {
                  if (!mounted) return;
                  setState(() => _isGeneratingDescription = false);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Failed to generate description. Please try again.')),
                  // );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4ECDC4),
            ),
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _selectedDate != null && _selectedCategory != null) {
      final uploadedImageUrls = await uploadImagesToSupabase(_images);
      await saveCampaignToFirestore(
        name: _nameController.text.trim(),
        target: _targetController.text.trim(),
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        finishDate: _selectedDate!,
        imageUrls: uploadedImageUrls,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Donation campaign created successfully!'),
          backgroundColor: Color(0xFF4ECDC4),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Create Campaign'),
        backgroundColor: const Color(0xFF4ECDC4),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Donation Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Target Value (e.g. 1000000)'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (value) => value == null ? 'Select a category' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        alignLabelWithHint: true,
                      ),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  IconButton(
                    onPressed: _isGeneratingDescription ? null : _showAIPromptDialog,
                    icon: _isGeneratingDescription
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
                            ),
                          )
                        : const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFF4ECDC4),
                          ),
                    tooltip: 'Generate description using AI',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Finish Date:'),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: now,
                        lastDate: DateTime(now.year + 5),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: Text(
                      _selectedDate != null
                          ? _selectedDate!.toString().split(' ')[0]
                          : 'Pick a date',
                      style: const TextStyle(color: Color(0xFF4ECDC4)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.add_a_photo, color: Color(0xFF4ECDC4)),
                  label: const Text('Add Images', style: TextStyle(color: Color(0xFF4ECDC4))),
                  onPressed: _showImagePickerOptions,
                ),
              ),
              if (_images.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _images
                      .map(
                        (file) => Stack(
                          children: [
                            Image.file(file, width: 80, height: 80, fit: BoxFit.cover),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () => setState(() => _images.remove(file)),
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.close, size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 80), // Space to avoid button overlap
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4ECDC4),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _submit,
            child: const Text('Create Campaign'),
          ),
        ),
      ),
    );
  }
}

Future<void> saveCampaignToFirestore({
  required String name,
  required String target,
  required String category,
  required String description,
  required DateTime finishDate,
  required List<String> imageUrls,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userName = prefs.getString('userName');

    if (userId == null) {
      throw Exception("User not logged in or userId not found.");
    }

    final donationData = {
      'name': name,
      'target': int.tryParse(target) ?? 0,
      'category': category,
      'description': description,
      'finishDate': Timestamp.fromDate(finishDate),
      'imageUrls': imageUrls,
      'uid': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'progress': 0.00,
      'organization': userName,
      'vies': 0
    };

    await FirebaseFirestore.instance.collection('donations').add(donationData);
  } catch (e) {
    print('Error saving campaign: $e');
    rethrow;
  }
}
