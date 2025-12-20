import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Background Layer
          Container(
            color: const Color(0xFF0F172A),
            child: Stack(
              children: [
                Positioned(
                  top: -100,
                  right: -100,
                  child: CircleAvatar(
                    radius: 200,
                    backgroundColor: Colors.lightBlueAccent.withOpacity(0.05),
                  ),
                ),
                Positioned(
                  bottom: -150,
                  left: -150,
                  child: CircleAvatar(
                    radius: 300,
                    backgroundColor: Colors.white.withOpacity(0.02),
                  ),
                ),
                // Subtle overlay pattern if available, or just the gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF0F172A),
                        const Color(0xFF1E293B).withOpacity(0.9),
                        const Color(0xFF0F172A),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Image Background with parallax effect
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.1, end: 1.0),
            duration: const Duration(seconds: 2),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: 0.4,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/landing_bg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Core Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Spacer(),
                   TweenAnimationBuilder<double>(
                     tween: Tween<double>(begin: 0, end: 1),
                     duration: const Duration(seconds: 1),
                     curve: Curves.easeOut,
                     builder: (context, value, child) {
                       return Opacity(
                         opacity: value,
                         child: Transform.translate(
                           offset: Offset(0, 20 * (1 - value)),
                           child: child,
                         ),
                       );
                     },
                     child: Column(
                       children: [
                         Container(
                           padding: const EdgeInsets.all(16),
                           decoration: BoxDecoration(
                             border: Border.all(color: Colors.white10),
                             borderRadius: BorderRadius.circular(24),
                           ),
                           child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 32),
                         ),
                         const SizedBox(height: 32),
                         ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.white, Color(0xFF94A3B8)],
                          ).createShader(bounds),
                          child: Text(
                            'LUXE\nINTELLIGENCE',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 52,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 0.9,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Precision Identification • Real-time Analytics\nCloud Integrated Architecture',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                            height: 1.5,
                          ),
                        ),
                       ],
                     ),
                   ),
                  
                  const Spacer(),
                  
                  // Premium Get Started Button
                  _GetStartedButton(),
                  const SizedBox(height: 40),
                  
                  // Footer detail
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle)),
                      const SizedBox(width: 12),
                      Text(
                        'FIRESTORE SYNC ACTIVE',
                        style: GoogleFonts.inter(fontSize: 10, color: Colors.white24, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                      ),
                      const SizedBox(width: 12),
                      Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle)),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GetStartedButton extends StatefulWidget {
  @override
  State<_GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<_GetStartedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: _isPressed ? Colors.white.withOpacity(0.9) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'GET STARTED',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_rounded, color: Color(0xFF0F172A), size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
