import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../services/classifier_service.dart';
import '../services/firestore_service.dart';

class ClassifierScreen extends StatefulWidget {
  const ClassifierScreen({super.key});

  @override
  State<ClassifierScreen> createState() => _ClassifierScreenState();
}

class _ClassifierScreenState extends State<ClassifierScreen> {
  final ClassifierService _classifierService = ClassifierService();
  final FirestoreService _firestoreService = FirestoreService();
  final ImagePicker _picker = ImagePicker();
  
  File? _image;
  List? _results;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _classifierService.loadModel();
  }

  @override
  void dispose() {
    _classifierService.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      setState(() {
        _image = File(pickedFile.path);
        _isProcessing = true;
        _results = null;
      });

      final results = await _classifierService.classifyImage(_image!);
      
      if (results != null && results.isNotEmpty) {
        final bestResult = results[0];
        try {
          await _firestoreService.logClassification(
            className: bestResult['label'],
            confidence: bestResult['confidence'],
            source: source == ImageSource.camera ? 'camera' : 'gallery',
          );
        } catch (e) {
          debugPrint("Firestore log failed: $e");
          // Don't crash if firestore fails
        }
      }

      setState(() {
        _results = results;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Identify with Precision',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 4K Premium Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/app_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Darkening Overlay
          Positioned.fill(
            child: Container(
              color: const Color(0xFF0F172A).withOpacity(0.8),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                child: Column(
                  children: [
                    // Image Container with Glassmorphism feel
                    Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: _image != null
                            ? Image.file(_image!, fit: BoxFit.cover)
                            : Container(
                              color: Colors.white.withOpacity(0.02),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.wb_sunny_outlined, size: 50, color: Colors.white24),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      'Awaiting Input',
                                      style: GoogleFonts.outfit(
                                        fontSize: 20, 
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Capture or upload a photo to begin classification',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(fontSize: 14, color: Colors.white38),
                                    ),
                                  ],
                                ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Animated Result Panel
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _isProcessing
                          ? const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(color: Colors.white),
                            )
                          : _results != null && _results!.isNotEmpty
                              ? _buildResultCard()
                              : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 40),
                    
                    // Floating Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildGlassButton(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: Icons.camera_rounded,
                            label: 'Camera',
                            isPrimary: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildGlassButton(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: Icons.photo_library_rounded,
                            label: 'Gallery',
                            isPrimary: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    final result = _results![0];
    final String label = result['label'];
    final double confidence = result['confidence'] * 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: Colors.white24, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'RESULT ARCHIVE',
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white24, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                height: 8,
                width: (MediaQuery.of(context).size.width - 96) * (confidence / 100),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ML Precision Rate',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white38),
              ),
              Text(
                '${confidence.toStringAsFixed(1)}%',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isPrimary,
  }) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: isPrimary ? Colors.white : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Center(
        child: TextButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: isPrimary ? const Color(0xFF0F172A) : Colors.white, size: 22),
          label: Text(
            label.toUpperCase(),
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              color: isPrimary ? const Color(0xFF0F172A) : Colors.white,
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
