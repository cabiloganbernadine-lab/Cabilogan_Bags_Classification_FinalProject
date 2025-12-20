import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/bag_class.dart';
import 'classifier_screen.dart';

class DetailScreen extends StatelessWidget {
  final BagClass bag;

  const DetailScreen({super.key, required this.bag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
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
              color: const Color(0xFF0F172A).withOpacity(0.85),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 450.0,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: bag.name,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          bag.imagePath,
                          fit: BoxFit.cover,
                        ),
                        // Soft darkness transition
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Color(0xFF010203)],
                              stops: [0.6, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bag.name,
                                  style: GoogleFonts.outfit(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    "IDENTIFIED LUXE CLASS",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Detailed Overview',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        bag.description,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.8,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Premium Feature Icons
                      Row(
                        children: [
                          _buildFeatureItem(Icons.verified_rounded, "Official"),
                          const SizedBox(width: 12),
                          _buildFeatureItem(Icons.auto_awesome_rounded, "Precision"),
                          const SizedBox(width: 12),
                          _buildFeatureItem(Icons.storage_rounded, "Cloud Log"),
                        ],
                      ),
                      const SizedBox(height: 140), 
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ClassifierScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.center_focus_strong_rounded, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      'ANALYZE NOW',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white54, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}
