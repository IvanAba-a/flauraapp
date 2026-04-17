import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/app_colors.dart';
import '../utils/plant_presets.dart';

class MainPlantScreen extends StatefulWidget {
  final PlantPreset preset;
  final int currentMoisture;
  final String currentUv; 
  
  const MainPlantScreen({
    Key? key, 
    required this.preset,
    this.currentMoisture = 0, 
    this.currentUv = 'Low',   
  }) : super(key: key);

  @override
  _MainPlantScreenState createState() => _MainPlantScreenState();
}

class _MainPlantScreenState extends State<MainPlantScreen> {

  // ==========================================
  // --- UI MATH ENGINE: MOISTURE ---
  // ==========================================
  int get _moistureTolerance => (widget.preset.idealMoisture - widget.preset.minMoisture).abs();

  double _getMoistureFill() {
    double maxScale = widget.preset.idealMoisture * 2.0; 
    return (widget.currentMoisture / maxScale).clamp(0.0, 1.0);
  }

  Color _getMoistureColor() {
    int diff = (widget.currentMoisture - widget.preset.idealMoisture).abs();
    if (diff <= _moistureTolerance / 2) return Colors.greenAccent.shade700; 
    if (diff <= _moistureTolerance) return Colors.orange; 
    return Colors.redAccent; 
  }

  String _getMoistureStatus() {
    int diff = widget.currentMoisture - widget.preset.idealMoisture;
    int absDiff = diff.abs();
    
    if (absDiff <= _moistureTolerance / 2) return 'Optimal';
    if (absDiff <= _moistureTolerance) return diff < 0 ? 'Warning: Getting Dry' : 'Warning: Getting Wet';
    return diff < 0 ? 'Critical: Too Dry' : 'Critical: Too Wet';
  }

  // ==========================================
  // --- STRICT CATEGORY UI ENGINE: UV LIGHT ---
  // ==========================================
  
  // 1. The exact categories sent by Firebase, locked in order.
  final List<String> _uvScale = ['low', 'moderate', 'high', 'very high', 'extreme'];

  // 2. Parser: Finds the mathematical position (0 to 4) of the string in the list
  int _getUvIndexPosition(String category) {
    int index = _uvScale.indexOf(category.toLowerCase().trim());
    return index == -1 ? 0 : index; // Fallback to 'low' if Firebase sends corrupted data
  }

  // 3. Bar Fill: Compares positions to shift the bar 12.5% per tier
  double _getDynamicUvFill() {
    int idealPos = _getUvIndexPosition(widget.preset.lightRequirement);
    int currentPos = _getUvIndexPosition(widget.currentUv);
    
    int diff = currentPos - idealPos;
    double fill = 0.5 + (diff * 0.125); 
    
    return fill.clamp(0.05, 0.95); 
  }

  // 4. Color Logic: How far apart are the array positions?
  Color _getDynamicUvColor() {
    int diff = (_getUvIndexPosition(widget.currentUv) - _getUvIndexPosition(widget.preset.lightRequirement)).abs();
    
    if (diff == 0) return Colors.greenAccent.shade700; // Perfect match
    if (diff == 1) return Colors.orange; // Slightly off (1 tier variance)
    return Colors.redAccent; // Way off (2+ tiers variance)
  }

  // 5. Text Status: Evaluates the direction of the variance
  String _getDynamicUvStatus() {
    int idealPos = _getUvIndexPosition(widget.preset.lightRequirement);
    int currentPos = _getUvIndexPosition(widget.currentUv);
    int diff = currentPos - idealPos;
    
    if (diff == 0) return 'Optimal';
    if (diff < 0) return 'Warning: Too Dark';
    if (diff == 1) return 'Warning: Too Bright';
    return 'Critical: Sunburn Risk'; 
  }

  // ==========================================
  // --- UI BUILD METHOD ---
  // ==========================================

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF90A583),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.55,
            child: Image.asset(widget.preset.imagePath, fit: BoxFit.cover),
          ),
          Positioned(
            top: screenHeight * 0.45,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF90A583),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 24),
                            SizedBox(width: 8),
                            Text('Back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.25),
                  
                  // --- The Glassmorphism Live Status Card ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.white.withValues(alpha: 0.5), Colors.white.withValues(alpha: 0.1)],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.preset.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                                      Text('Target UV: ${_capitalize(widget.preset.lightRequirement)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54)),
                                    ],
                                  ),
                                  Text('Live Data', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black.withValues(alpha: 0.6))),
                                ],
                              ),
                              const SizedBox(height: 24),
                              
                              _buildMoistureGauge(),
                              const SizedBox(height: 24),
                              _buildUvGauge(), // Powered by the categorical array engine
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // --- Bottom Description Box ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Text(widget.preset.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 8),
                        Text(
                          widget.preset.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: AppColors.mainAccent, borderRadius: BorderRadius.circular(24)),
                          child: Column(
                            children: [
                              _buildInfoRow(Icons.water_drop, 'Moisture', 'Min: ${widget.preset.minMoisture}% | Ideal: ${widget.preset.idealMoisture}%', Colors.lightBlueAccent),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Colors.white24, height: 1)),
                              _buildInfoRow(Icons.wb_sunny, 'Light / UV', 'Needs ${_capitalize(widget.preset.lightRequirement)} exposure', Colors.amber),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Colors.white24, height: 1)),
                              _buildInfoRow(Icons.eco, 'Care Tier', widget.preset.idealMoisture > 40 ? 'High Moisture' : (widget.preset.idealMoisture > 20 ? 'Moderate Moisture' : 'Low Moisture / Arid'), Colors.white),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- REVISED MEASUREMENT UI GAUGES ---
  
  Widget _buildMoistureGauge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Moisture (${widget.currentMoisture}%)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text(_getMoistureStatus(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _getMoistureColor())),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 16,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black.withValues(alpha: 0.1)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _getMoistureFill(),
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: _getMoistureColor())),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black.withValues(alpha: 0.4))),
            Text('Ideal: ${widget.preset.idealMoisture}%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.greenAccent.shade700)),
            Text('${widget.preset.idealMoisture * 2}%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black.withValues(alpha: 0.4))),
          ],
        ),
      ],
    );
  }

  Widget _buildUvGauge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Current UV: ${_capitalize(widget.currentUv)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text(_getDynamicUvStatus(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _getDynamicUvColor())),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 16,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black.withValues(alpha: 0.1)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _getDynamicUvFill(),
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: _getDynamicUvColor())),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Too Dark', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black.withValues(alpha: 0.4))),
            Text('Target: ${_capitalize(widget.preset.lightRequirement)}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.greenAccent.shade700)),
            Text('Too Bright', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black.withValues(alpha: 0.4))),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String description, Color iconColor) {
    return Row(
      children: [
        Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(description, style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.4), textAlign: TextAlign.center),
        ),
      ],
    );
  }

  // Capitalizes strings perfectly for the UI ("very high" -> "Very High")
  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
  }
}