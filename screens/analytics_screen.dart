import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/firestore_service.dart';

class AnalyticsScreen extends StatelessWidget {
  AnalyticsScreen({super.key});

  final FirestoreService _firestoreService = FirestoreService();

  static final List<Color> _palette = [
    const Color(0xFF6366F1), // Indigo
    const Color(0xFFEC4899), // Pink
    const Color(0xFF10B981), // Emerald
    const Color(0xFFF59E0B), // Amber
    const Color(0xFF3B82F6), // Blue
    const Color(0xFF8B5CF6), // Violet
    const Color(0xFFF43F5E), // Rose
    const Color(0xFF06B6D4), // Cyan
    const Color(0xFF84CC16), // Lime
    const Color(0xFFF97316), // Orange
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Analytics',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w800, 
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
            onPressed: () => _showClearConfirmation(context),
          ),
          const SizedBox(width: 8),
        ],
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
              color: const Color(0xFF0F172A).withOpacity(0.85),
            ),
          ),

          SafeArea(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getClassifications(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Sync Error: ${snapshot.error}', style: GoogleFonts.inter(color: Colors.redAccent)));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return _buildEmptyState();
                }

                // Process Data for Charts
                final Map<String, int> classCounts = {};
                final Map<String, double> classAccuracy = {};

                for (var doc in docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  final label = data['className'] ?? 'Unknown';
                  final confidence = (data['confidence'] ?? 0.0).toDouble();
                  
                  classCounts[label] = (classCounts[label] ?? 0) + 1;
                  classAccuracy[label] = (classAccuracy[label] ?? 0.0) + confidence;
                }

                // Average accuracy calc
                classAccuracy.updateAll((key, value) => value / classCounts[key]!);

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        'LATEST INSIGHTS',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.white24,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLatestResultHeader(docs.first.data() as Map<String, dynamic>),
                      const SizedBox(height: 40),
                      
                      _buildSectionTitle('Results: Statistical Distribution'),
                      const SizedBox(height: 8),
                      Text('Cloud-synchronized data stream', style: GoogleFonts.inter(fontSize: 10, color: Colors.white24, letterSpacing: 1)),
                      const SizedBox(height: 16),
                      _buildBarChart(classCounts),
                      
                      const SizedBox(height: 40),
                      _buildSectionTitle('Classes: Accuracy Metrics'),
                      const SizedBox(height: 16),
                      _buildClassAccuracyList(classAccuracy),
                      
                      const SizedBox(height: 40),
                      _buildSectionTitle('Analytics: Frequency Pulse'),
                      const SizedBox(height: 16),
                      _buildFrequencyGraph(classCounts),
                      
                      const SizedBox(height: 40),
                      _buildSectionTitle('Circle Graph: Overall Shares'),
                      const SizedBox(height: 16),
                      _buildCircleGraph(classCounts),
                      
                      const SizedBox(height: 60),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLatestResultHeader(Map<String, dynamic> latest) {
    final String label = latest['className'] ?? 'Unknown';
    final double conf = (latest['confidence'] ?? 0.0) * 100;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACTIVE CLASSIFICATION',
            style: GoogleFonts.inter(color: Colors.white24, fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSimpleStat('Confidence Rate:', '${conf.toStringAsFixed(1)}%'),
              _buildSimpleStat('Status:', conf > 95 ? 'OPTIMAL' : 'VALID'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _palette[0], // Latest always gets first color for highlight
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Live Signature Active',
                style: GoogleFonts.inter(fontSize: 10, color: Colors.white38, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildBarChart(Map<String, int> data) {
    final sortedLabels = data.keys.toList()..sort();
    return Container(
      height: 250,
      padding: const EdgeInsets.fromLTRB(10, 24, 24, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (data.values.isNotEmpty ? data.values.reduce((a, b) => a > b ? a : b) : 0).toDouble() + 5,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.white,
              tooltipBorder: const BorderSide(color: Colors.white10),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${sortedLabels[group.x.toInt()]}\n${rod.toY.toInt()} Hits',
                  GoogleFonts.inter(color: const Color(0xFF0F172A), fontSize: 12, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < sortedLabels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        sortedLabels[value.toInt()].substring(0, 1).toUpperCase(),
                        style: GoogleFonts.inter(color: Colors.white38, fontWeight: FontWeight.w800, fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: sortedLabels.asMap().entries.map((e) {
            final color = _palette[e.key % _palette.length];
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: data[e.value]!.toDouble(),
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.3), color],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 16,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildClassAccuracyList(Map<String, double> accuracy) {
    return Column(
      children: accuracy.entries.map((e) {
        final acc = e.value * 100;
        final isExcellent = acc >= 95;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.analytics_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.key,
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      'Rate: Precision Tracking',
                      style: GoogleFonts.inter(color: Colors.white24, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${acc.toStringAsFixed(1)}%',
                    style: GoogleFonts.outfit(
                      color: isExcellent ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    isExcellent ? 'OPTIMAL' : 'AVERAGE',
                    style: GoogleFonts.inter(
                      color: isExcellent ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFrequencyGraph(Map<String, int> data) {
    // Matches the sketch "Analytics" with vertical bar style
    return _buildBarChart(data);
  }

  Widget _buildCircleGraph(Map<String, int> data) {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: PieChart(
        PieChartData(
          sectionsSpace: 4,
          centerSpaceRadius: 50,
          sections: data.entries.toList().asMap().entries.map((e) {
            final index = e.key;
            final entry = e.value;
            final count = entry.value;
            final color = _palette[index % _palette.length];
            
            return PieChartSectionData(
              color: color,
              value: count.toDouble(),
              title: '${((count / data.values.reduce((a, b) => a + b)) * 100).toStringAsFixed(0)}%',
              radius: 70,
              titleStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Firebase.apps.isEmpty ? Icons.cloud_off_rounded : Icons.bar_chart_rounded, 
              size: 64, 
              color: Colors.white
            ),
          ),
          const SizedBox(height: 32),
          Text(
            Firebase.apps.isEmpty ? 'Firebase Not Linked' : 'Analyzing Patterns...',
            style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              Firebase.apps.isEmpty 
                ? 'The app is strictly local because google-services.json is missing. Please add it to the android/app folder to enable cloud analytics.'
                : 'Capture images to generate real-time metrics and precision dashboards.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.white38, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text('Purge Analytics?', style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: Colors.white)),
        content: Text('This action will permanently delete all cloud-logged classification records.', style: GoogleFonts.inter(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('CANCEL', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white38)),
          ),
          TextButton(
            onPressed: () {
              _firestoreService.clearLogs();
              Navigator.pop(context);
            },
            child: Text('PURGE DATA', style: GoogleFonts.inter(fontWeight: FontWeight.w900, color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
