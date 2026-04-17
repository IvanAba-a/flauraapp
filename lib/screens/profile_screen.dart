import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/plant_presets.dart';
import 'main_plant_screen.dart'; // NEW: Imported to enable navigation

class ProfileScreen extends StatelessWidget {
  final PlantPreset activePreset;
  final String statusText;
  final Color statusColor;
  
  // NEW: We need these so we can pass them to the Main Plant Screen!
  final int currentMoisture;
  final String currentUv;

  const ProfileScreen({
    Key? key,
    required this.activePreset,
    required this.statusText,
    required this.statusColor,
    required this.currentMoisture,
    required this.currentUv,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            children: [
              // --- NEW: Interactive Back Button ---
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios_new, color: AppColors.textAccent, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Back', 
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textAccent)
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- 1. Profile Avatar & Edit Icon ---
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ],
                      image: const DecorationImage(
                        image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfI3-r3oWq9q_8XN-OqD10v4R3e9v4R3e9v4R3e9v4'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.background, width: 3),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- 2. User Info (Name, Username) ---
              const Text(
                'Ivan Halaman',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textAccent, 
                ),
              ),
              const Text(
                '@hlmnan',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.lightAccent, 
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),

              // --- 3. Bio Section ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightAccent.withValues(alpha: 0.1), 
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.lightAccent.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Bio:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textAccent,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.mainAccent, 
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Magtanim ay di biro, maghapon naka tayo',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.lightAccent,
                        height: 1.4, 
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // --- 4. "Your Plants" Section Title ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Active Plant', 
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textAccent,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        color: AppColors.lightAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // --- 5. NEW: Clickable Dynamic Plant Tile ---
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPlantScreen(
                        preset: activePreset,
                        currentMoisture: currentMoisture,
                        currentUv: currentUv,
                      ),
                    ),
                  );
                },
                child: _buildProfilePlantTile(
                  activePreset.name,
                  statusText,
                  statusColor,
                  activePreset.imagePath,
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePlantTile(String name, String statusText, Color statusColor, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightAccent.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightAccent.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 55,
              height: 55,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 14,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.lightAccent, size: 24),
        ],
      ),
    );
  }
}