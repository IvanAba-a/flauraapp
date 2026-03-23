import 'dart:math';

class PlantTips {
  static final List<String> _tips = [
    "Overwatering is the #1 killer of indoor plants.",
    "Wipe your plant's leaves with a damp cloth to help them breathe.",
    "Yellow leaves usually mean too much water; brown, crispy leaves mean too little.",
    "Most tropical plants love humidity—try misting them in the morning!",
    "Keep plants away from A/C vents and drafty windows.",
    "Rotate your plants a quarter-turn every week for even growth.",
    "Always use pots with drainage holes to prevent root rot.",
    "Stick your finger an inch into the soil; if it's dry, it's time to water.",
    "Grouping plants together creates a microclimate that boosts humidity.",
    "Brown leaf tips can indicate low humidity or tap water with too much fluoride.",
    "Bottom-watering helps roots grow deeper and stronger.",
    "Don't fertilize a dry plant; water it first to avoid burning the roots.",
    "Plants need less water during the winter when they go dormant.",
    "Direct sunlight can scorch the leaves of low-light plants like Snake Plants.",
    "A heavier pot usually means the soil is still wet.",
    "Neem oil is a great natural remedy for common plant pests like spider mites.",
    "Pruning yellow or dead leaves helps the plant focus energy on new growth.",
    "Aerate your soil by poking it gently with a chopstick.",
    "Succulents and cacti thrive on neglect—let their soil dry completely!",
    "Use filtered water or let tap water sit out for 24 hours to let chlorine evaporate.",
    "If a plant's roots are circling the top of the soil, it's time to repot.",
    "Calatheas are drama queens; they prefer distilled water and high humidity.",
    "Dust acts like a sunscreen, preventing your plants from photosynthesizing.",
    "Avoid sudden temperature drops; most house plants prefer it between 18°C and 24°C.",
    "Less light means less water. Adjust your watering schedule based on the season.",
    "Wilting but wet soil? You might have root rot. Let it dry out!",
    "Coffee grounds can be a good nitrogen-rich fertilizer for acid-loving plants.",
    "Pothos is one of the easiest plants to propagate in water.",
    "Don't repot a plant right after bringing it home; let it acclimate for a week or two.",
    "A healthy root system is usually firm and white, not mushy and brown."
  ];

  static String getRandomTip() {
    final random = Random();
    return _tips[random.nextInt(_tips.length)];
  }
}