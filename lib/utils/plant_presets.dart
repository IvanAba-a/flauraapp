import 'package:flutter/material.dart';

class PlantPreset {
  final String name;
  final int minMoisture; 
  final int idealMoisture; 
  final String lightRequirement; // Now acts as the Ideal UV Index target!
  final IconData icon;
  final String imagePath; 
  final String description; 

  PlantPreset({
    required this.name,
    required this.minMoisture,
    required this.idealMoisture,
    required this.lightRequirement,
    required this.icon,
    required this.imagePath,
    required this.description,
  });
}

class PlantDataBank {
  static final List<PlantPreset> presets = [
    // --- TIER 1: Low Moisture ---
    PlantPreset(
      name: 'Snake Plant', 
      minMoisture: 10, idealMoisture: 20, 
      lightRequirement: 'Low', // Adapted to shade/low UV
      icon: Icons.grass, imagePath: 'assets/images/snake_plant.webp',
      description: 'A near-indestructible succulent known for air purification and vertical, sword-like leaves.',
    ),
    PlantPreset(
      name: 'Aloe Vera', 
      minMoisture: 10, idealMoisture: 20, 
      lightRequirement: 'High', // Succulents love high UV
      icon: Icons.spa, imagePath: 'assets/images/aloe-vera.png',
      description: 'A sun-loving succulent famous for its soothing gel and thick, fleshy green rosettes.',
    ),
    PlantPreset(
      name: 'Jade Plant', 
      minMoisture: 10, idealMoisture: 20, 
      lightRequirement: 'High', 
      icon: Icons.nature, imagePath: 'assets/images/jade_plant.png',
      description: 'A popular symbol of good luck featuring thick, woody stems and glossy, oval-shaped leaves.',
    ),
    
    // --- TIER 2: Moderate Moisture ---
    PlantPreset(
      name: 'Monstera Deliciosa', 
      minMoisture: 25, idealMoisture: 50, 
      lightRequirement: 'Moderate', // Canopy/Diffused light
      icon: Icons.energy_savings_leaf, imagePath: 'assets/images/monstera.png',
      description: 'A striking tropical plant famous for its massive, glossy leaves with natural fenestrations (holes).',
    ),
    PlantPreset(
      name: 'Golden Pothos', 
      minMoisture: 25, idealMoisture: 50, 
      lightRequirement: 'Moderate', 
      icon: Icons.eco_outlined, imagePath: 'assets/images/golden_pothos.png',
      description: 'An incredibly resilient trailing vine with heart-shaped leaves splashed with yellow and gold.',
    ),
    PlantPreset(
      name: 'ZZ Plant', 
      minMoisture: 25, idealMoisture: 50, 
      lightRequirement: 'Moderate', 
      icon: Icons.eco, imagePath: 'assets/images/zzplant.png',
      description: 'A highly dependable houseplant with upright, wand-like stems and waxy, deep green, oval leaves.',
    ),
    PlantPreset(
      name: 'Spider Plant', 
      minMoisture: 25, idealMoisture: 50, 
      lightRequirement: 'Moderate', 
      icon: Icons.grass_outlined, imagePath: 'assets/images/spider_plant.png',
      description: 'A fast-growing, adaptable plant with long, arched leaves that produce cascading "spiderettes".',
    ),
    PlantPreset(
      name: 'Rubber Plant', 
      minMoisture: 25, idealMoisture: 50, 
      lightRequirement: 'High', 
      icon: Icons.park, imagePath: 'assets/images/rubber_plant.png',
      description: 'A bold, statement-making indoor tree featuring large, glossy, burgundy or dark green foliage.',
    ),
    PlantPreset(
      name: 'Dumbcane (Dieffenbachia)', 
      minMoisture: 25, idealMoisture: 50, 
      lightRequirement: 'Moderate', 
      icon: Icons.filter_vintage, imagePath: 'assets/images/dumbcane.png',
      description: 'A lush tropical plant appreciated for its broad, beautifully patterned green and white leaves.',
    ),
    
    // --- TIER 3: High Moisture ---
    PlantPreset(
      name: 'Peace Lily', 
      minMoisture: 45, idealMoisture: 70, 
      lightRequirement: 'Low', // Naturally grows on the dark forest floor
      icon: Icons.spa_outlined, imagePath: 'assets/images/peace_lily.png',
      description: 'An elegant, shade-tolerant plant known for its rich dark green foliage and beautiful white blooms.',
    ),
  ];
}