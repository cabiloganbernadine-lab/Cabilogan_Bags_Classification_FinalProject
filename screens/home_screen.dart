import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/bag_data.dart';
import '../models/bag_class.dart';
import 'detail_screen.dart';
import 'classifier_screen.dart';
import 'analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<BagClass> _filteredClasses = BagData.bagClasses;

  void _filterClasses(String query) {
    setState(() {
      _filteredClasses = BagData.bagClasses
          .where((bag) => bag.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 900 ? 4 : (screenWidth > 600 ? 3 : 2);
    
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
              color: const Color(0xFF0F172A).withOpacity(0.8),
            ),
          ),
          
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Premium Header
              SliverAppBar(
                expandedHeight: 180.0,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 24, bottom: 64),
                  title: Text(
                    'Class Library',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                  background: Stack(
                    children: [
                      Positioned(
                        right: -50,
                        top: -50,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _CircleIconButton(
                            icon: Icons.analytics_outlined,
                            onPressed: () {
                              try {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AnalyticsScreen()));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                              }
                            },
                          ),
                          const SizedBox(width: 12),
                          _CircleIconButton(
                            icon: Icons.add_a_photo_rounded,
                            isPrimary: true,
                            onPressed: () {
                              try {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ClassifierScreen()));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Search and Stats Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: _filterClasses,
                              style: GoogleFonts.inter(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Search identified classes...',
                                hintStyle: GoogleFonts.inter(color: Colors.white54, fontSize: 14),
                                prefixIcon: const Icon(Icons.search_rounded, color: Colors.white54),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'AVAILABLE CLASSES (${_filteredClasses.length})',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white54,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const Icon(Icons.filter_list_rounded, size: 18, color: Colors.white54),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'OVERVIEW',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white.withOpacity(0.4), letterSpacing: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Grid with premium cards
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: _filteredClasses.isEmpty 
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Text('No classes found', style: TextStyle(color: Colors.white54)),
                        ),
                      ),
                    )
                  : SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final bag = _filteredClasses[index];
                          return BagCard(bag: bag, index: index);
                        },
                        childCount: _filteredClasses.length,
                      ),
                    ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: isPrimary ? Colors.white : Colors.white10,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: IconButton(
          icon: Icon(icon, color: isPrimary ? const Color(0xFF0F172A) : Colors.white, size: 20),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class BagCard extends StatefulWidget {
  final BagClass bag;
  final int index;

  const BagCard({super.key, required this.bag, required this.index});

  @override
  State<BagCard> createState() => _BagCardState();
}

class _BagCardState extends State<BagCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, animation, secondaryAnimation) => DetailScreen(bag: widget.bag),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white.withOpacity(0.03),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Hero(
                          tag: widget.bag.name,
                          child: Image.asset(
                            widget.bag.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.image_not_supported_outlined, color: Colors.white12, size: 30),
                          ),
                        ),
                      ),
                    ),
                    // Glassy Tag
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Text(
                          'PREMIUM',
                          style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.bag.name.toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.bag.description,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.5),
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'DISCOVER',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
