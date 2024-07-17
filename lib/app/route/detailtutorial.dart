import 'package:flutter/material.dart';

class PlantCareDetail extends StatelessWidget {
  final String categoryType;

  const PlantCareDetail({super.key, required this.categoryType});

  @override
  Widget build(BuildContext context) {
    String title = '';
    List<CareInstruction> careInstructions = [];

    switch (categoryType) {
      case 'indoor':
        title = 'Indoor Plants Care';
        careInstructions = [
          CareInstruction(
            title: 'Light',
            description: 'Place indoor plants where they receive bright, indirect sunlight.',
            icon: Icons.wb_sunny,
          ),
          CareInstruction(
            title: 'Water',
            description: 'Water the plants when the top inch of soil feels dry. Avoid overwatering.',
            icon: Icons.water,
          ),
          CareInstruction(
            title: 'Humidity',
            description: 'Indoor plants prefer higher humidity levels. Mist the leaves regularly.',
            icon: Icons.cloud,
          ),
          CareInstruction(
            title: 'Temperature',
            description: 'Keep the room temperature between 65-75°F (18-24°C).',
            icon: Icons.thermostat,
          ),
          CareInstruction(
            title: 'Fertilizer',
            description: 'Feed indoor plants with a balanced, water-soluble fertilizer every month during the growing season.',
            icon: Icons.local_florist,
          ),
        ];
        break;
      case 'balcony':
        title = 'Balcony Plants Care';
        careInstructions = [
          CareInstruction(
            title: 'Light',
            description: 'Ensure balcony plants receive at least 6 hours of sunlight daily.',
            icon: Icons.wb_sunny,
          ),
          CareInstruction(
            title: 'Water',
            description: 'Water the plants early in the morning or late in the evening. Ensure proper drainage to prevent root rot.',
            icon: Icons.water,
          ),
          CareInstruction(
            title: 'Wind',
            description: 'Protect plants from strong winds by using windbreakers or placing them in sheltered spots.',
            icon: Icons.air,
          ),
          CareInstruction(
            title: 'Soil',
            description: 'Use well-draining soil mixed with compost for balcony plants.',
            icon: Icons.grass,
          ),
          CareInstruction(
            title: 'Fertilizer',
            description: 'Apply a slow-release fertilizer at the beginning of the growing season.',
            icon: Icons.local_florist,
          ),
        ];
        break;
      case 'aquatic':
        title = 'Aquatic Bonsai Care';
        careInstructions = [
          CareInstruction(
            title: 'Light',
            description: 'Place aquatic bonsai in bright, indirect light.',
            icon: Icons.wb_sunny,
          ),
          CareInstruction(
            title: 'Water',
            description: 'Keep the roots submerged in water. Change the water every two weeks.',
            icon: Icons.water,
          ),
          CareInstruction(
            title: 'Temperature',
            description: 'Maintain the water temperature between 70-80°F (21-27°C).',
            icon: Icons.thermostat,
          ),
          CareInstruction(
            title: 'Humidity',
            description: 'Ensure high humidity levels around the plant.',
            icon: Icons.cloud,
          ),
          CareInstruction(
            title: 'Fertilizer',
            description: 'Use liquid aquatic plant fertilizer once a month.',
            icon: Icons.local_florist,
          ),
        ];
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: careInstructions.length,
        itemBuilder: (context, index) {
          final instruction = careInstructions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Icon(instruction.icon, color: Colors.green),
              title: Text(
                instruction.title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                instruction.description,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CareInstruction {
  final String title;
  final String description;
  final IconData icon;

  CareInstruction({
    required this.title,
    required this.description,
    required this.icon,
  });
}
