import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Inheriting background color from main.dart ThemeData, but explicit here for safety
      backgroundColor: AppColors.background, // F3F4EE
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              // Header spacer
              const SizedBox(height: 30),

              // --- 1. Profile Avatar & Edit Icon ---
              Stack(
                alignment: Alignment.center,
                children: [
                  // The main circular avatar container with border and shadow
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ],
                      image: const DecorationImage(
                        // NetworkImage placeholder for Ivan's avatar
                        image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfI3-r3oWq9q_8XN-OqD10v4R3e9v4R3e9v4R3e9v4'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // The positioned Edit Pencil Icon overlapping the bottom-right
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
                  color: AppColors.textAccent, // 112B09 (Dark green)
                ),
              ),
              const Text(
                '@hlmnan',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.lightAccent, // 2C420A (Lighter green)
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),

              // --- 3. Bio Section ---
              // Wrapped in a soft green container matching the design
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightAccent.withOpacity(0.1), // Faded green background
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.lightAccent.withOpacity(0.1)),
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
                              color: AppColors.mainAccent, // 31511E
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Tagalog text from the reference image
                    const Text(
                      'Magtanim ay di biro, maghapon naka tayo',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.lightAccent,
                        height: 1.4, // Line height for better readability
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
                    'Your Plants',
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

              // --- 5. Plant Tiles (Replicated from Dashboard style) ---
              // Snake Plant: Healthy (replicating image_10.png)
              _buildProfilePlantTile(
                'Snake Plant',
                'All normal',
                AppColors.mainAccent, // 31511E (Green status)
                Icons.eco_outlined,
              ),
              const SizedBox(height: 12),
              // Pothos: Critical UV Level (replicating image_10.png)
              _buildProfilePlantTile(
                'Pothos',
                'Critical UV Level',
                Colors.red, // Red status warning
                Icons.warning_amber_outlined,
              ),
              
              // Spacing at the bottom of the scroll view
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- Reusable widget builder for the elegant plant tiles ---
  // (Adapts the style established in the DashboardScreen for coherence)
  Widget _buildProfilePlantTile(String name, String statusText, Color statusColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightAccent.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightAccent.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        children: [
          // Icon Placeholder
          // (In a future integration, this would be a faded image like image_10.png)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.mainAccent, size: 30),
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