import 'package:flutter/material.dart';
import 'dart:ui'; // Required for the Glassmorphism blur effect!
import '../utils/app_colors.dart';

class MainPlantScreen extends StatefulWidget {
  const MainPlantScreen({Key? key}) : super(key: key);

  @override
  _MainPlantScreenState createState() => _MainPlantScreenState();
}

class _MainPlantScreenState extends State<MainPlantScreen> {
  int _selectedIndex = 0; // Keeping the bottom nav state

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // --- 1. The Background Image (Top Half) ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.55,
            child: Image.asset(
            'assets/images/snake_plant.webp',
            fit: BoxFit.cover,
          ),
          ),

          // --- 2. The Sage Green Background (Bottom Half) ---
          Positioned(
            top: screenHeight * 0.45, // Starts slightly higher to go behind the glass card
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF90A583), // Soft Sage Green from your design
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),
          ),

          // --- 3. The Scrollable Foreground Content ---
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back Button Header
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
                            Text(
                              'Back',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Invisible spacer to push the Glass Card down over the image border
                  SizedBox(height: screenHeight * 0.25),

                  // --- 4. The Glassmorphism Status Card ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2), // The frosted glass base
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.5),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Snake Plant', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                                      Text('Shade loving', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                                    ],
                                  ),
                                  Text('More info', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.8))),
                                ],
                              ),
                              const SizedBox(height: 20),
                              
                              const Text('Moisture Level: Normal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              _buildGradientBar(), // Custom function below!
                              
                              const SizedBox(height: 20),
                              const Text('UV Level: Normal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              _buildGradientBar(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- 5. Bottom Description & Info Box ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const Text(
                          'Snake Plant',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'A near-indestructible succulent known for air\npurification and vertical, sword-like leaves.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(height: 24),

                        // The Dark Green Info Box
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.mainAccent, // 0xFF31511E
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(Icons.water_drop, 'Moisture', 'Dry Soil. Water only when 100% dry\n(every 2-4 weeks).', Colors.lightBlueAccent),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Colors.white24, height: 1)),
                              _buildInfoRow(Icons.wb_sunny, 'Light / UV', 'Bright, Indirect Light. 8-10 hours\ndaily. Moderate UV.', Colors.amber),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Colors.white24, height: 1)),
                              _buildInfoRow(Icons.cloud, 'Humidity', '30% - 50%. Average household\nhumidity.', Colors.white),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40), // Bottom padding
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) { setState(() { _selectedIndex = index; }); },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF90A583), // Matches the sage background
        selectedItemColor: AppColors.textAccent,
        unselectedItemColor: AppColors.mainAccent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0, // Removes the shadow to make it blend into the sage green
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 30), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.eco_outlined, size: 30), label: 'Presets'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 30), label: 'Profile'),
        ],
      ),
    );
  }

  // Helper Widget for the specific dark-to-light gradient progress bars
  Widget _buildGradientBar() {
    return Container(
      height: 20,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [AppColors.textAccent, Colors.white], // Darkest green fading to white
          stops: [0.3, 1.0], // Controls where the fade starts
        ),
      ),
    );
  }

  // Helper Widget for the 3 rows inside the dark green box
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
          child: Text(
            description,
            style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}