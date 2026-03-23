import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'main_plant_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _activePlantName = 'Monstera Deliciosa';
  String _activeTarget = 'Needs 60%+ Moisture';
  IconData _activeIcon = Icons.energy_savings_leaf;

  void _changePreset(String name, String target, IconData icon) {
    setState(() {
      _activePlantName = name;
      _activeTarget = target;
      _activeIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning,',
                        style: TextStyle(fontSize: 16, color: AppColors.lightAccent),
                      ),
                      Text(
                        'Ivan',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textAccent),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColors.mainAccent.withOpacity(0.1),
                      radius: 24,
                      child: const Icon(Icons.person, color: AppColors.mainAccent),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.lightAccent.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, spreadRadius: 1)
                  ]
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildAmbientStat('Temp', '24°C', Icons.thermostat, Colors.orange),
                        _buildAmbientStat('Humidity', '55%', Icons.cloud, Colors.purple),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(color: AppColors.lightAccent.withOpacity(0.1), thickness: 1),
                    ),
                    Row(
                      children: [
                        _buildAmbientStat('UV Index', 'Med', Icons.light_mode, Colors.amber),
                        _buildAmbientStat('Moisture', '45%', Icons.water_drop, Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Active Preset Target',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.lightAccent),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPlantScreen()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.mainAccent,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: AppColors.mainAccent.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
                    ]
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(_activeIcon, color: AppColors.white, size: 40),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _activePlantName, 
                              style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _activeTarget, 
                                style: const TextStyle(color: AppColors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Plant Presets',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textAccent),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildPresetTile('Snake Plant', 'Needs 20%+ Moisture', Icons.eco),
              const SizedBox(height: 12),
              _buildPresetTile('Gumamela', 'Needs 50%+ Moisture', Icons.local_florist),
              const SizedBox(height: 12),
              _buildPresetTile('Aloe Vera', 'Needs 15%+ Moisture', Icons.spa),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientStat(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppColors.lightAccent, fontSize: 12)),
              Text(value, style: const TextStyle(color: AppColors.textAccent, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetTile(String title, String target, IconData icon) {
    return GestureDetector(
      onTap: () => _changePreset(title, target, icon), 
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightAccent.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.mainAccent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textAccent)),
                  const SizedBox(height: 4),
                  Text(target, style: const TextStyle(fontSize: 14, color: AppColors.lightAccent, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Icon(Icons.swap_horiz, color: AppColors.mainAccent), 
          ],
        ),
      ),
    );
  }
}